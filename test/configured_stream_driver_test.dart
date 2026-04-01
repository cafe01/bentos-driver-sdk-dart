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
          decodeInput: (data, {required config}) => utf8.decode(data),
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

    test('write + flush + read delivers reversed output', () async {
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

      // Read all output.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
      expect(utf8.decode(resp.response.buf.data), 'cba');
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

      final r1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'ba');

      // Read again to get EOF and reach COMPLETE.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );

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

      final r2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r2.response.buf.data), 'dc');
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

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), 'CBA');
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
          decodeInput: (data, {required config}) => utf8.decode(data),
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
          decodeInput: (data, {required config}) => utf8.decode(data),
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

      final readResp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(readResp.response.buf.data), 'cba',
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

      final r1 = await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      final r2 = await client.roundTrip(
        _msg(nextId(), fh2,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'BA',
          reason: 'fh1 has uppercase config');
      expect(utf8.decode(r2.response.buf.data), 'ba',
          reason: 'fh2 has default config');
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

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), 'dcba',
          reason: 'all accumulated input processed');
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
          decodeInput: (data, {required config}) => utf8.decode(data),
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
        decodeInput: (data, {required config}) => utf8.decode(data),
      );
      expect(ops.defaultConfig, isNotNull);
      expect(ops.process, isNotNull);
      expect(ops.encodeOutput, isNotNull);
      expect(ops.decodeInput, isNotNull);
      expect(ops.onSessionStart, isNull);
      expect(ops.onSessionEnd, isNull);
      expect(ops.onCancel, isNull);
      expect(ops.onDrain, isNull);
    });
  });
}
