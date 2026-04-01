/// P3 EventStreamDriver tests — /dev/ticker over real Unix sockets.
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
    tmpDir = Directory.systemTemp.createTempSync('event_stream_driver_test_');
    sockUri = Uri.parse('unix://${tmpDir.path}/driver.sock');
    msgId = 0;
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('EventStreamDriver ticker', () {
    late EventStreamDriver<int> driver;
    late TestClient client;
    var activated = false;
    var deactivated = false;

    setUp(() async {
      activated = false;
      deactivated = false;
      driver = EventStreamDriver<int>(EventStreamOps(
        encodeEvent: (n) => Uint8List.fromList(utf8.encode('tick $n\n')),
        onActivate: () => activated = true,
        onDeactivate: () => deactivated = true,
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
        _msg(nextId(), 1, FuseRequest(open: OpenReq(flags: 0))),
      );
      expect(resp.response.err, 0);
      expect(resp.response.whichReply(), FuseResponse_Reply.open);
    });

    test('first open triggers onActivate', () async {
      expect(activated, isFalse);
      await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(open: OpenReq(flags: 0))),
      );
      expect(activated, isTrue, reason: 'onActivate fires on first open');
    });

    test('second open does not re-trigger onActivate', () async {
      await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(open: OpenReq(flags: 0))),
      );
      activated = false; // reset
      await client.roundTrip(
        _msg(nextId(), 2, FuseRequest(open: OpenReq(flags: 0))),
      );
      expect(activated, isFalse, reason: 'onActivate only fires once');
    });

    test('last close triggers onDeactivate', () async {
      await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(open: OpenReq(flags: 0))),
      );
      await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(release: ReleaseReq(flags: 0))),
      );
      expect(deactivated, isTrue, reason: 'onDeactivate fires on last close');
    });

    test('close with remaining listeners does not deactivate', () async {
      await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(open: OpenReq(flags: 0))),
      );
      await client.roundTrip(
        _msg(nextId(), 2, FuseRequest(open: OpenReq(flags: 0))),
      );
      await client.roundTrip(
        _msg(nextId(), 1, FuseRequest(release: ReleaseReq(flags: 0))),
      );
      expect(deactivated, isFalse,
          reason: 'onDeactivate waits for last listener');
    });

    test('write returns EACCES — read-only device', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(
                data: utf8.encode('nope'), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 13, reason: 'EACCES on write to P3 device');
    });

    test('read with no events returns empty', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
      expect(resp.response.buf.data, isEmpty);
    });

    test('emit delivers event to listener', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      driver.emit(42);

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
      expect(utf8.decode(resp.response.buf.data), 'tick 42\n');
    });

    test('emit broadcasts to all listeners', () async {
      const fh1 = 1;
      const fh2 = 2;
      await client.roundTrip(
        _msg(nextId(), fh1, FuseRequest(open: OpenReq(flags: 0))),
      );
      await client.roundTrip(
        _msg(nextId(), fh2, FuseRequest(open: OpenReq(flags: 0))),
      );

      driver.emit(7);

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
      expect(utf8.decode(r1.response.buf.data), 'tick 7\n');
      expect(utf8.decode(r2.response.buf.data), 'tick 7\n');
    });

    test('multiple events queue up', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      driver.emit(1);
      driver.emit(2);
      driver.emit(3);

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
      expect(utf8.decode(resp.response.buf.data), 'tick 1\ntick 2\ntick 3\n');
    });

    test('whole-event delivery — never splits events', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      driver.emit(1); // "tick 1\n" = 7 bytes
      driver.emit(2); // "tick 2\n" = 7 bytes

      // Read with size=10 — fits first event (7) but not both (14).
      final r1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(10), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'tick 1\n',
          reason: 'only complete events delivered');

      // Second event still in queue.
      final r2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r2.response.buf.data), 'tick 2\n');
    });

    test('emit with no listeners is a no-op', () async {
      // No open fhs — emit should not throw.
      driver.emit(99);
      expect(driver.active, isFalse);
    });

    test('drop-oldest overflow policy', () async {
      final smallDriver = EventStreamDriver<int>(
        EventStreamOps(
          encodeEvent: (n) => Uint8List.fromList(utf8.encode('$n\n')),
        ),
        maxEventsPerListener: 3,
      );
      await smallDriver.serve(sockUri);
      final c = TestClient(await connectDriver(sockUri));

      const fh = 1;
      await c.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      // Emit 5 events with max=3 — should keep last 3.
      for (var i = 1; i <= 5; i++) {
        smallDriver.emit(i);
      }

      final resp = await c.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), '3\n4\n5\n',
          reason: 'oldest events dropped');

      await c.close();
      await smallDriver.close();
    });

    test('poll: POLLIN when events queued, nothing when empty', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      // Empty — no POLLIN.
      final p1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p1.response.poll.revents & 0x01, isZero,
          reason: 'no POLLIN when empty');
      expect(p1.response.poll.revents & 0x04, isZero,
          reason: 'no POLLOUT on read-only device');

      // Emit event.
      driver.emit(1);

      final p2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p2.response.poll.revents & 0x01, isNonZero,
          reason: 'POLLIN when events queued');
    });

    test('release cleans up listener', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(release: ReleaseReq(flags: 0))),
      );

      // Read on released fh returns EIO.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(
                size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 5, reason: 'EIO on released listener');
    });

    test('flush returns success', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 0))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
    });
  });

  group('EventStreamOps contract', () {
    test('no FUSE types in EventStreamOps signature', () {
      final ops = EventStreamOps<String>(
        encodeEvent: (s) => Uint8List.fromList(utf8.encode(s)),
      );
      expect(ops.encodeEvent, isNotNull);
      expect(ops.onActivate, isNull);
      expect(ops.onDeactivate, isNull);
    });
  });
}
