/// P1 StreamDriver tests — echo driver over real Unix sockets.
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
    tmpDir = Directory.systemTemp.createTempSync('stream_driver_test_');
    sockUri = Uri.parse('unix://${tmpDir.path}/driver.sock');
    msgId = 0;
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('StreamDriver echo', () {
    late StreamDriver<StreamController<Uint8List>> driver;
    late TestClient client;

    setUp(() async {
      driver = StreamDriver<StreamController<Uint8List>>(StreamOps(
        onSessionStart: (flags) => StreamController<Uint8List>(),
        onData: (data, {required session}) {
          session!.add(Uint8List.fromList(data));
          return data.length;
        },
        outputStream: ({required session}) => session!.stream,
        onSessionEnd: ({required session}) => session!.close(),
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

      final payload = utf8.encode('hello echo');
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: payload, offset: fixnum.Int64(0)))),
      );
      expect(resp.response.write.count, fixnum.Int64(payload.length));
    });

    test('write then read echoes data back', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final payload = utf8.encode('echo me');
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: payload, offset: fixnum.Int64(0)))),
      );

      // Give the stream controller time to deliver.
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final readResp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(readResp.response.err, 0);
      expect(utf8.decode(readResp.response.buf.data), 'echo me');
    });

    test('read with no data returns empty (EOF)', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final readResp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(readResp.response.err, 0);
      expect(readResp.response.buf.data, isEmpty);
    });

    test('multiple writes accumulate in output buffer', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('aaa'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('bbb'), offset: fixnum.Int64(0)))),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Read enough to get both chunks.
      final resp = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(resp.response.buf.data), 'aaabbb');
    });

    test('read size is respected — partial drain', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('hello world'), offset: fixnum.Int64(0)))),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Read only 5 bytes.
      final r1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(5), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r1.response.buf.data), 'hello');

      // Read the rest.
      final r2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      expect(utf8.decode(r2.response.buf.data), ' world');
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

      await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(write: WriteReq(data: utf8.encode('fh1'), offset: fixnum.Int64(0)))),
      );
      await client.roundTrip(
        _msg(nextId(), fh2,
            FuseRequest(write: WriteReq(data: utf8.encode('fh2'), offset: fixnum.Int64(0)))),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));

      final r1 = await client.roundTrip(
        _msg(nextId(), fh1,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );
      final r2 = await client.roundTrip(
        _msg(nextId(), fh2,
            FuseRequest(read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)))),
      );

      expect(utf8.decode(r1.response.buf.data), 'fh1');
      expect(utf8.decode(r2.response.buf.data), 'fh2');
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
      expect(resp.response.err, 5); // EIO
    });

    test('poll returns POLLOUT always, POLLIN when data buffered', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      // No data — should have POLLOUT only.
      final p1 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p1.response.poll.revents & 0x04, isNonZero); // POLLOUT
      expect(p1.response.poll.revents & 0x01, isZero); // no POLLIN

      // Write data.
      await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(write: WriteReq(data: utf8.encode('data'), offset: fixnum.Int64(0)))),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Now should have both POLLIN and POLLOUT.
      final p2 = await client.roundTrip(
        _msg(nextId(), fh,
            FuseRequest(poll: PollReq(events: 0x05, kh: fixnum.Int64(0)))),
      );
      expect(p2.response.poll.revents & 0x04, isNonZero); // POLLOUT
      expect(p2.response.poll.revents & 0x01, isNonZero); // POLLIN
    });

    test('flush returns success', () async {
      const fh = 1;
      await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(open: OpenReq(flags: 2))),
      );

      final resp = await client.roundTrip(
        _msg(nextId(), fh, FuseRequest(flush: FlushReq(lockOwner: fixnum.Int64(0)))),
      );
      expect(resp.response.err, 0);
    });
  });

  group('StreamOps contract', () {
    test('no FUSE types in StreamOps signature', () {
      // This test is a compile-time check: StreamOps<S> should not
      // reference FuseMessage, FuseResponse, FuseRequest, etc.
      // If this compiles, the contract is clean.
      final ops = StreamOps<void>(
        onData: (data, {required session}) => data.length,
      );
      expect(ops.onData, isNotNull);
      expect(ops.outputStream, isNull);
      expect(ops.onSessionStart, isNull);
      expect(ops.onSessionEnd, isNull);
    });
  });
}
