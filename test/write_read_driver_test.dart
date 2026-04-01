/// P2 WriteReadDriver tests — /dev/kv over real Unix sockets.
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

void main() {
  late Directory tmpDir;
  late Uri sockUri;
  var msgId = 0;

  int nextId() => ++msgId;

  setUp(() {
    tmpDir = Directory.systemTemp.createTempSync('write_read_driver_test_');
    sockUri = Uri.parse('unix://${tmpDir.path}/driver.sock');
    msgId = 0;
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('WriteReadDriver kv', () {
    late WriteReadDriver<Object> driver;
    late TestClient client;
    final store = <String, String>{};

    setUp(() async {
      store.clear();
      driver = WriteReadDriver<Object>(WriteReadOps(
        onSessionStart: (flags) => Object(),
        onRequest: (input, {required session}) async {
          final text = utf8.decode(input).trim();
          if (text.contains('=')) {
            final parts = text.split('=');
            store[parts[0]] = parts.sublist(1).join('=');
            return Uint8List.fromList(utf8.encode('OK\n'));
          } else {
            return Uint8List.fromList(
                utf8.encode('${store[text] ?? "(not found)"}\n'));
          }
        },
        onSessionEnd: ({required session}) {},
      ));
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

    test('write returns bytes consumed', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final payload = utf8.encode('name=bentos');
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: payload, offset: fixnum.Int64(0)))),
      );
      expect(resp.response.write.count, fixnum.Int64(payload.length));
    });

    test('read in IDLE returns EAGAIN', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 11, reason: 'EAGAIN when no request pending');
    });

    test('write then flush then read yields response', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Write a store command.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('color=blue'), offset: fixnum.Int64(0)))),
      );

      // Flush triggers submission.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );

      // Read the response.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
      expect(utf8.decode(resp.response.buf.data), 'OK\n');
    });

    test('read triggers submission (implicit flush)', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Write a retrieve command.
      store['lang'] = 'dart';
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('lang'), offset: fixnum.Int64(0)))),
      );

      // Read without flush — should submit and return response.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
      expect(utf8.decode(resp.response.buf.data), 'dart\n');
    });

    test('multiple writes accumulate before submission', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Write in two chunks: "na" + "me=bentos"
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('na'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('me=bentos'), offset: fixnum.Int64(0)))),
      );

      // Flush + read.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), 'OK\n');
      expect(store['name'], 'bentos');
    });

    test('write during RESPONSE_READY returns EBUSY', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Write + flush to get to RESPONSE_READY.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('x=1'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );

      // Try to write before consuming response.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('y=2'), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 16, reason: 'EBUSY during RESPONSE_READY');
    });

    test('response consumed resets to IDLE — new cycle works', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Cycle 1: store.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('os=bentos'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      final r1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'OK\n');

      // Cycle 2: retrieve.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('os'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      final r2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r2.response.buf.data), 'bentos\n');
    });

    test('partial read — response larger than read size', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // Store a long value.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('msg=hello world'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );

      // Read only 2 bytes.
      final r1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(2), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'OK');

      // Read the rest.
      final r2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r2.response.buf.data), '\n');
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

      // fh1: store.
      await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(write: WriteReq(data: utf8.encode('a=1'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );

      // fh2 should still be in IDLE — read returns EAGAIN.
      final r2idle = await client.roundTrip(
        _msg(nextId(), fh2,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(r2idle.response.err, 11, reason: 'fh2 is IDLE, EAGAIN');

      // fh1: read response.
      final r1 = await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'OK\n');
    });

    test('release cleans up session', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(release: ReleaseReq(flags: 0))),
      );

      // Read on released fh returns EIO.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 5, reason: 'EIO on released session');
    });

    test('poll: IDLE/ACCUMULATING=POLLOUT, RESPONSE_READY=POLLIN, mutually exclusive', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // IDLE: POLLOUT only.
      final p1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p1.response.poll.revents & 0x04, isNonZero, reason: 'POLLOUT in IDLE');
      expect(p1.response.poll.revents & 0x01, isZero, reason: 'no POLLIN in IDLE');

      // Write to enter ACCUMULATING.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('k=v'), offset: fixnum.Int64(0)))),
      );

      // ACCUMULATING: POLLOUT only.
      final p2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p2.response.poll.revents & 0x04, isNonZero, reason: 'POLLOUT in ACCUMULATING');
      expect(p2.response.poll.revents & 0x01, isZero, reason: 'no POLLIN in ACCUMULATING');

      // Flush to enter RESPONSE_READY.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );

      // RESPONSE_READY: POLLIN only.
      final p3 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p3.response.poll.revents & 0x01, isNonZero, reason: 'POLLIN in RESPONSE_READY');
      expect(p3.response.poll.revents & 0x04, isZero, reason: 'no POLLOUT in RESPONSE_READY');
    });

    test('flush in IDLE is a no-op', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0, reason: 'flush in IDLE is no-op success');
    });

    test('not-found key returns "(not found)"', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('nonexistent'), offset: fixnum.Int64(0)))),
      );
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), '(not found)\n');
    });
  });

  group('WriteReadOps contract', () {
    test('no FUSE types in WriteReadOps signature', () {
      // Compile-time check: WriteReadOps<S> should not reference
      // FuseMessage, FuseResponse, FuseRequest, etc.
      final ops = WriteReadOps<void>(
        onRequest: (input, {required session}) async => input,
      );
      expect(ops.onRequest, isNotNull);
      expect(ops.onSessionStart, isNull);
      expect(ops.onSessionEnd, isNull);
    });
  });
}
