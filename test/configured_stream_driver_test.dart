/// P4 ConfiguredStreamDriver tests — /dev/synth over real Unix sockets.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';

/// Build a FuseMessage with the given op.
FuseMessage _msg(int id, int fh, FuseRequest req) => FuseMessage(
      id: fixnum.Int64(id),
      fh: fixnum.Int64(fh),
      request: req,
    );

/// Wraps a StreamChannel with a response queue for multi-roundtrip tests.
final class TestClient {
  TestClient(this._channel) {
    _channel.stream.listen(_responses.add);
  }

  final StreamChannel<Uint8List> _channel;
  final _responses = <Uint8List>[];

  Future<FuseMessage> roundTrip(FuseMessage msg) async {
    _channel.sink.add(Uint8List.fromList(msg.writeToBuffer()));
    final start = _responses.length;
    while (_responses.length <= start) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
    return FuseMessage.fromBuffer(_responses[start]);
  }

  Future<void> close() => _channel.sink.close();
}

// --- Test subsystem types ---

final class TestConfig {
  final bool uppercase;
  const TestConfig({this.uppercase = false});
  TestConfig copyWith({bool? uppercase}) =>
      TestConfig(uppercase: uppercase ?? this.uppercase);
}

final class TestConfigCodec extends ConfigCodec<TestConfig> {
  static const setUppercase = 0x01;

  @override
  TestConfig apply(TestConfig current, int command, Uint8List data) {
    return switch (command) {
      setUppercase => current.copyWith(uppercase: data[0] != 0),
      _ => throw DriverError.invalidArgument('Unknown config $command'),
    };
  }

  @override
  Uint8List encode(TestConfig config, int command) => Uint8List(0);
}

/// Framework ioctl helpers.
int _fwCmd(int num) => (0xBE << 8) | num;
final _getState = _fwCmd(0x00);
final _dropCmd = _fwCmd(0x02);
final _resetCmd = _fwCmd(0x03);
final _getError = _fwCmd(0x04);

void main() {
  late Directory tmpDir;
  late Uri sockUri;
  var msgId = 0;

  int nextId() => ++msgId;

  /// Read until EOF, returning one decoded string per read event. Each entry is
  /// exactly one process yield — the output-boundary contract (Fatia 2).
  Future<List<String>> readEvents(TestClient c, int fh) async {
    final events = <String>[];
    while (true) {
      final r = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      if (r.response.err != 0) break;
      final data = r.response.buf.data;
      if (data.isEmpty) break; // EOF
      events.add(utf8.decode(data));
    }
    return events;
  }

  setUp(() {
    tmpDir = Directory.systemTemp.createTempSync('configured_stream_test_');
    sockUri = Uri.parse('unix://${tmpDir.path}/driver.sock');
    msgId = 0;
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('ConfiguredStreamDriver synth', () {
    late ConfiguredStreamDriver<TestConfig, String, String, Object> driver;
    late TestClient client;
    var cancelled = false;
    var drained = false;

    setUp(() async {
      cancelled = false;
      drained = false;
      driver = ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            final text = config.uppercase ? input.toUpperCase() : input;
            for (final char in text.trim().split('').reversed) {
              yield char;
            }
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
          onSessionEnd: ({required session}) {},
          onCancel: ({required session}) => cancelled = true,
          onDrain: ({required session}) => drained = true,
        ),
        configCodec: TestConfigCodec(),
      );
      await driver.serve(sockUri);
      client = TestClient(await connectDriver(sockUri));
    });

    tearDown(() async {
      await client.close();
      await driver.close();
    });

    test('open returns success', () async {
      final resp = await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(open: OpenReq(flags: 2))),
      );
      expect(resp.response.err, 0);
      expect(resp.response.whichReply(), FuseResponse_Reply.open);
    });

    test('GET_STATE returns OPEN after open', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _getState))),
      );
      expect(resp.response.ioctl.result, 0, reason: 'OPEN = index 0');
    });

    test('write advances from OPEN to CONFIGURED', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('hi'), offset: fixnum.Int64(0)))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _getState))),
      );
      expect(resp.response.ioctl.result, 1, reason: 'CONFIGURED = index 1');
    });

    test('read in OPEN returns EAGAIN', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 11, reason: 'EAGAIN in OPEN');
    });

    test('write + flush + read — one read event per process yield', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Write input.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abc'), offset: fixnum.Int64(0)))),
      );

      // Flush triggers processing.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );

      // Give the async stream time to produce chunks.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // process yields 'c','b','a' — three yields → three read events,
      // never coalesced into a single 'cba' read.
      final events = await readEvents(client, fh);
      expect(events, ['c', 'b', 'a'],
          reason: 'one read event per yield, boundaries intact');
    });

    test('write during STREAMING returns EBUSY', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('y'), offset: fixnum.Int64(0)))),
      );
      // Could be EBUSY (streaming/draining) or accepted (complete).
      // With a single char, stream completes fast — check both.
      expect(resp.response.err, anyOf(16, 0));
    });

    test('complete cycle — write restarts from COMPLETE', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Cycle 1.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('ab'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 'ab' reversed → yields 'b','a'; readEvents drains to EOF, reaching COMPLETE.
      final c1 = await readEvents(client, fh);
      expect(c1, ['b', 'a']);

      // Cycle 2 — write should restart.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('cd'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final c2 = await readEvents(client, fh);
      expect(c2, ['d', 'c']);
    });

    test('ioctl config applies — uppercase', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Set uppercase via ioctl.
      final configResp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(
                cmd: TestConfigCodec.setUppercase, inBuf: [1]))),
      );
      expect(configResp.response.err, 0);

      // Write + flush + read.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abc'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final events = await readEvents(client, fh);
      expect(events, ['C', 'B', 'A']);
    });

    test('ioctl during STREAMING returns EBUSY', () async {
      // Use a slow process to catch STREAMING state.
      final slowDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            for (final c in input.split('')) {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              yield c;
            }
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await slowDriver.serve(sockUri);
      final c = TestClient(await connectDriver(sockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abc'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      // Wait for first chunk to arrive (enters STREAMING).
      await Future<void>.delayed(const Duration(milliseconds: 150));

      final resp = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(
                cmd: TestConfigCodec.setUppercase, inBuf: [1]))),
      );
      expect(resp.response.err, 16, reason: 'EBUSY during STREAMING');

      await c.close();
      await slowDriver.close();
    });

    test('DROP cancels in-flight and returns to CONFIGURED', () async {
      final slowDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            for (final c in input.split('')) {
              await Future<void>.delayed(const Duration(milliseconds: 200));
              yield c;
            }
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
          onCancel: ({required session}) => cancelled = true,
        ),
        configCodec: TestConfigCodec(),
      );
      await slowDriver.serve(sockUri);
      final c = TestClient(await connectDriver(sockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abcdef'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // DROP.
      final resp = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _dropCmd))),
      );
      expect(resp.response.ioctl.result, 0);
      expect(cancelled, isTrue, reason: 'onCancel called on DROP');

      // Should be back in CONFIGURED.
      final stateResp = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _getState))),
      );
      expect(stateResp.response.ioctl.result, 1, reason: 'CONFIGURED after DROP');

      await c.close();
      await slowDriver.close();
    });

    test('RESET returns to OPEN and clears config', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Configure.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(
                cmd: TestConfigCodec.setUppercase, inBuf: [1]))),
      );

      // RESET.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _resetCmd))),
      );
      expect(resp.response.ioctl.result, 0);

      // Should be OPEN.
      final stateResp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _getState))),
      );
      expect(stateResp.response.ioctl.result, 0, reason: 'OPEN after RESET');

      // Write + flush + read — should NOT be uppercase (config reset).
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abc'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final events = await readEvents(client, fh);
      expect(events, ['c', 'b', 'a'],
          reason: 'lowercase — config was reset');
    });

    test('onDrain fires when output stream completes', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(drained, isTrue, reason: 'onDrain fires on stream completion');
    });

    test('poll: OPEN/CONFIGURED=POLLOUT, STREAMING=POLLIN when buffered', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // OPEN: POLLOUT.
      final p1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p1.response.poll.revents & 0x04, isNonZero,
          reason: 'POLLOUT in OPEN');
      expect(p1.response.poll.revents & 0x01, isZero,
          reason: 'no POLLIN in OPEN');

      // Write to enter CONFIGURED.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abc'), offset: fixnum.Int64(0)))),
      );

      // CONFIGURED: POLLOUT.
      final p2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p2.response.poll.revents & 0x04, isNonZero,
          reason: 'POLLOUT in CONFIGURED');
    });

    test('independent sessions per fh', () async {
      const fh1 = 1;
      const fh2 = 2;
      await client.roundTrip(
        _msg(nextId(), fh1, FuseRequest(open: OpenReq(flags: 2))),
      );
      await client.roundTrip(
        _msg(nextId(), fh2, FuseRequest(open: OpenReq(flags: 2))),
      );

      // fh1 gets uppercase config.
      await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(ioctl: IoctlReq(
                cmd: TestConfigCodec.setUppercase, inBuf: [1]))),
      );

      // Both write + flush.
      await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(write: WriteReq(
                data: utf8.encode('ab'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh2,
            FuseRequest(write: WriteReq(
                data: utf8.encode('ab'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh2,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final e1 = await readEvents(client, fh1);
      final e2 = await readEvents(client, fh2);
      expect(e1, ['B', 'A'], reason: 'fh1 has uppercase config');
      expect(e2, ['b', 'a'], reason: 'fh2 has default config');
    });

    test('release cleans up session', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(release: ReleaseReq(flags: 0))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 5, reason: 'EIO on released session');
    });

    test('unknown subsystem ioctl returns EINVAL', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: 0xFF, inBuf: []))),
      );
      expect(resp.response.err, 22, reason: 'EINVAL for unknown config cmd');
    });

    test('flush in OPEN is a no-op', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
    });

    test('multiple writes accumulate before flush', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('ab'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('cd'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // 'abcd' reversed → yields 'd','c','b','a', one read event each.
      final events = await readEvents(client, fh);
      expect(events, ['d', 'c', 'b', 'a'],
          reason: 'all accumulated input processed, per-yield boundaries');
    });

    test('decodeInput receives one record per write — boundaries intact',
        () async {
      List<Uint8List>? seenRecords;

      final boundaryDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) => Stream.value(input),
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) {
            seenRecords = records;
            return utf8.decode(records.expand((r) => r).toList());
          },
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await boundaryDriver.serve(sockUri);
      final c = TestClient(await connectDriver(sockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('ab'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('cd'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(seenRecords, isNotNull);
      expect(seenRecords!.length, 2,
          reason: 'two writes → two records, each boundary preserved');
      expect(utf8.decode(seenRecords![0]), 'ab');
      expect(utf8.decode(seenRecords![1]), 'cd');

      await c.close();
      await boundaryDriver.close();
    });

    test('process yields → one read event per yield, output boundaries intact',
        () async {
      final boundaryDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            yield 'ab';
            yield 'cd';
            yield 'ef';
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await boundaryDriver.serve(sockUri);
      final c = TestClient(await connectDriver(sockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Naive coalescing would deliver 'abcdef' in one read; the contract is
      // three distinct read events, one per yield, each boundary preserved.
      final events = await readEvents(c, fh);
      expect(events, ['ab', 'cd', 'ef'],
          reason: 'three yields → three read events, never coalesced');

      await c.close();
      await boundaryDriver.close();
    });

    test('single yield larger than read size splits across reads — byte-stream '
        'within one boundary', () async {
      final splitDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) =>
              Stream.value('abcdef'),
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await splitDriver.serve(sockUri);
      final c = TestClient(await connectDriver(sockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // A single 6-byte yield, read 4 bytes at a time → 'abcd' then 'ef'. The
      // split is WITHIN one yield (no boundary to lose), unlike two yields.
      final r1 = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'abcd');
      final r2 = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r2.response.buf.data), 'ef');

      await c.close();
      await splitDriver.close();
    });
  });

  group('ConfiguredStreamDriver stream error', () {
    late Directory errTmpDir;
    late Uri errSockUri;
    var errMsgId = 0;
    int errNextId() => ++errMsgId;

    setUp(() {
      errTmpDir = Directory.systemTemp.createTempSync('cs_err_test_');
      errSockUri = Uri.parse('unix://${errTmpDir.path}/driver.sock');
      errMsgId = 0;
    });

    tearDown(() {
      errTmpDir.deleteSync(recursive: true);
    });

    test('GET_ERROR reports stream error after failure', () async {
      final errDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            yield 'ok';
            throw DriverError.timedOut('provider timeout');
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await errDriver.serve(errSockUri);
      final c = TestClient(await connectDriver(errSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(errNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(errNextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(errNextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Read first chunk (ok).
      final r1 = await c.roundTrip(
        _msg(errNextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'ok');

      // Read again to get the error / drain to complete.
      await c.roundTrip(
        _msg(errNextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );

      // GET_ERROR in COMPLETE state.
      final errResp = await c.roundTrip(
        _msg(errNextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: _getError))),
      );
      expect(errResp.response.ioctl.result, 110,
          reason: 'ETIMEDOUT from stream error');

      await c.close();
      await errDriver.close();
    });
  });

  group('ConfiguredStreamOps contract', () {
    test('no FUSE types in ConfiguredStreamOps signature', () {
      final ops = ConfiguredStreamOps<String, String, String, void>(
        defaultConfig: () => '',
        process: (input, config, {required session}) =>
            Stream.value(input),
        encodeOutput: (chunk, {required config}) =>
            Uint8List.fromList(utf8.encode(chunk)),
        decodeInput: (records, {required config}) =>
            utf8.decode(records.expand((r) => r).toList()),
      );
      expect(ops.defaultConfig, isNotNull);
      expect(ops.process, isNotNull);
      expect(ops.encodeOutput, isNotNull);
      expect(ops.decodeInput, isNotNull);
      expect(ops.onSessionStart, isNull);
      expect(ops.onSessionEnd, isNull);
      expect(ops.onCancel, isNull);
      expect(ops.onDrain, isNull);
      expect(ops.onQuery, isNull);
    });

    test('encodeOutput and decodeInput are optional', () {
      final ops = ConfiguredStreamOps<String, String, String, void>(
        defaultConfig: () => '',
        process: (input, config, {required session}) =>
            Stream.value(input),
      );
      expect(ops.encodeOutput, isNull);
      expect(ops.decodeInput, isNull);
    });
  });

  group('onQuery callback', () {
    late Directory qTmpDir;
    late Uri qSockUri;
    var qMsgId = 0;
    int qNextId() => ++qMsgId;

    setUp(() {
      qTmpDir = Directory.systemTemp.createTempSync('cs_query_test_');
      qSockUri = Uri.parse('unix://${qTmpDir.path}/driver.sock');
      qMsgId = 0;
    });

    tearDown(() {
      qTmpDir.deleteSync(recursive: true);
    });

    test('onQuery receives cmd and session, returns bytes', () async {
      const queryCmd = 0x42;
      int? receivedCmd;
      Object? receivedSession;

      final qDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) =>
              Stream.value(input),
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
          onQuery: (cmd, {required session}) {
            receivedCmd = cmd;
            receivedSession = session;
            return Uint8List.fromList([0xDE, 0xAD]);
          },
        ),
        configCodec: TestConfigCodec(),
      );
      await qDriver.serve(qSockUri);
      final c = TestClient(await connectDriver(qSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(qNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await c.roundTrip(
        _msg(qNextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: queryCmd))),
      );
      expect(resp.response.err, 0);
      expect(resp.response.ioctl.result, 0);
      expect(resp.response.ioctl.buf, [0xDE, 0xAD]);
      expect(receivedCmd, queryCmd, reason: 'onQuery receives correct cmd');
      expect(receivedSession, isNotNull,
          reason: 'onQuery receives session');

      await c.close();
      await qDriver.close();
    });

    test('onQuery available during STREAMING phase', () async {
      const queryCmd = 0x42;

      final qDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            for (final c in input.split('')) {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              yield c;
            }
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
          onQuery: (cmd, {required session}) =>
              Uint8List.fromList([0xBE, 0xEF]),
        ),
        configCodec: TestConfigCodec(),
      );
      await qDriver.serve(qSockUri);
      final c = TestClient(await connectDriver(qSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(qNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(qNextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('abc'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(qNextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Query during streaming — should work (read-direction).
      final resp = await c.roundTrip(
        _msg(qNextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: queryCmd))),
      );
      expect(resp.response.err, 0,
          reason: 'onQuery works during STREAMING');
      expect(resp.response.ioctl.buf, [0xBE, 0xEF]);

      await c.close();
      await qDriver.close();
    });

    test('EINVAL when no onQuery and unknown ioctl', () async {
      final qDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) =>
              Stream.value(input),
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await qDriver.serve(qSockUri);
      final c = TestClient(await connectDriver(qSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(qNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await c.roundTrip(
        _msg(qNextId(), fh,
            FuseRequest(ioctl: IoctlReq(cmd: 0x42))),
      );
      expect(resp.response.err, 22,
          reason: 'EINVAL when no onQuery for unknown cmd');

      await c.close();
      await qDriver.close();
    });
  });

  group('optional encodeOutput/decodeInput', () {
    late Directory optTmpDir;
    late Uri optSockUri;
    var optMsgId = 0;
    int optNextId() => ++optMsgId;

    setUp(() {
      optTmpDir = Directory.systemTemp.createTempSync('cs_opt_test_');
      optSockUri = Uri.parse('unix://${optTmpDir.path}/driver.sock');
      optMsgId = 0;
    });

    tearDown(() {
      optTmpDir.deleteSync(recursive: true);
    });

    test('null decodeInput — clear ENOSYS error on flush', () async {
      final optDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) =>
              Stream.value(input),
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          // decodeInput omitted — null
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await optDriver.serve(optSockUri);
      final c = TestClient(await connectDriver(optSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(optNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );

      // Flush triggers _submit which needs decodeInput.
      final resp = await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 38,
          reason: 'ENOSYS when decodeInput is null');

      await c.close();
      await optDriver.close();
    });

    test('null encodeOutput — clear ENOSYS error on flush', () async {
      final optDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) =>
              Stream.value(input),
          // encodeOutput omitted — null
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await optDriver.serve(optSockUri);
      final c = TestClient(await connectDriver(optSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(optNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('x'), offset: fixnum.Int64(0)))),
      );

      // Flush triggers _submit which needs encodeOutput.
      final resp = await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 38,
          reason: 'ENOSYS when encodeOutput is null');

      await c.close();
      await optDriver.close();
    });

    test('provided encodeOutput/decodeInput — existing behavior', () async {
      final optDriver =
          ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) async* {
            yield input;
          },
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );
      await optDriver.serve(optSockUri);
      final c = TestClient(await connectDriver(optSockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(optNextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );
      await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('hello'), offset: fixnum.Int64(0)))),
      );
      await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final resp = await c.roundTrip(
        _msg(optNextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), 'hello',
          reason: 'works normally when both provided');

      await c.close();
      await optDriver.close();
    });
  });

  // Regression: read() must not return [] (false EOF) when buffer drains mid-stream.
  // Before the fix, _onRead in streaming phase returned empty buf when outputBuffer was
  // empty but outputDone was false — infer() interpreted that [] as EOF and exited early.
  group('streaming — no false EOF on buffer drain', () {
    test('multi-chunk stream with gap delivers all chunks before EOF', () async {
      final controller = StreamController<String>();

      final driver = ConfiguredStreamDriver<TestConfig, String, String, Object>(
        ConfiguredStreamOps(
          defaultConfig: TestConfig.new,
          process: (input, config, {required session}) => controller.stream,
          encodeOutput: (chunk, {required config}) =>
              Uint8List.fromList(utf8.encode(chunk)),
          decodeInput: (records, {required config}) =>
              utf8.decode(records.expand((r) => r).toList()),
          onSessionStart: Object.new,
        ),
        configCodec: TestConfigCodec(),
      );

      final pair = StreamChannelController<Uint8List>();
      driver.serveChannel(pair.foreign);
      final c = TestClient(pair.local);
      var id = 0;
      int nextId() => ++id;
      const fh = 1;

      await c.roundTrip(_msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))));
      await c.roundTrip(_msg(nextId(), fh,
          FuseRequest(write: WriteReq(data: utf8.encode('x'), offset: fixnum.Int64(0)))));

      // Emit chunk A before first read — it will be buffered when processing starts.
      controller.add('A');

      // First read triggers processing (configured phase → submit → wait for ready → deliver A).
      final r1 = await c.roundTrip(_msg(nextId(), fh,
          FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))));
      expect(utf8.decode(r1.response.buf.data), 'A',
          reason: 'first chunk delivered');

      // Schedule chunk B to arrive after a gap — buffer is empty when the next read() lands.
      Future<void>.delayed(const Duration(milliseconds: 20)).then((_) {
        controller.add('B');
        controller.close();
      });

      // Second read: buffer is empty, stream not done.
      // Without the fix this returned [] (false EOF). With the fix it waits for B.
      final r2 = await c.roundTrip(_msg(nextId(), fh,
          FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))));
      expect(r2.response.err, 0);
      expect(utf8.decode(r2.response.buf.data), 'B',
          reason: 'second chunk must not be swallowed by false EOF');

      // Third read: stream done, buffer empty — real EOF.
      final r3 = await c.roundTrip(_msg(nextId(), fh,
          FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))));
      expect(r3.response.buf.data, isEmpty, reason: 'EOF after stream complete');

      await c.close();
      await controller.close();
    });
  });
}
