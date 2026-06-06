/// Driver SDK tests — BentosDriver over real Unix sockets.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';

void main() {
  late Directory tmpDir;
  late Uri sockUri;

  setUp(() {
    tmpDir = Directory.systemTemp.createTempSync('bentos_driver_test_');
    sockUri = Uri.parse('unix://${tmpDir.path}/driver.sock');
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('BentosDriver', () {
    test('serves read requests over unix socket', () async {
      final greeting = utf8.encode('Hello from driver!\n');

      final driver = BentosDriver(
        onRead: (req, ctx) => FuseResponse(
          buf: BufReply(data: greeting),
        ),
      );
      await driver.serve(sockUri);

      // Connect as if we were bentosd.
      final channel = await connectDriver(sockUri);

      // Send a read request.
      final readMsg = FuseMessage(
        id: fixnum.Int64(1),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)),
        ),
      );
      channel.sink.add(Uint8List.fromList(readMsg.writeToBuffer()));

      // Receive the response.
      final respBytes = await channel.stream.first;
      final resp = FuseMessage.fromBuffer(respBytes);

      expect(resp.id, equals(fixnum.Int64(1)));
      expect(resp.response.err, equals(0));
      expect(resp.response.buf.data, equals(greeting));

      await channel.sink.close();
      await driver.close();
    });

    test('serves write requests', () async {
      var lastWritten = <int>[];

      final driver = BentosDriver(
        onWrite: (req, ctx) {
          lastWritten = req.data;
          return FuseResponse(
            write: WriteReply(count: fixnum.Int64(req.data.length)),
          );
        },
      );
      await driver.serve(sockUri);

      final channel = await connectDriver(sockUri);

      final payload = utf8.encode('test data');
      final writeMsg = FuseMessage(
        id: fixnum.Int64(2),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          write: WriteReq(data: payload, offset: fixnum.Int64(0)),
        ),
      );
      channel.sink.add(Uint8List.fromList(writeMsg.writeToBuffer()));

      final respBytes = await channel.stream.first;
      final resp = FuseMessage.fromBuffer(respBytes);

      expect(resp.response.write.count, equals(fixnum.Int64(payload.length)));
      expect(lastWritten, equals(payload));

      await channel.sink.close();
      await driver.close();
    });

    test('returns ENOSYS for unimplemented ops', () async {
      final driver = BentosDriver(); // no handlers
      await driver.serve(sockUri);

      final channel = await connectDriver(sockUri);

      final msg = FuseMessage(
        id: fixnum.Int64(3),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(100), offset: fixnum.Int64(0)),
        ),
      );
      channel.sink.add(Uint8List.fromList(msg.writeToBuffer()));

      final respBytes = await channel.stream.first;
      final resp = FuseMessage.fromBuffer(respBytes);

      expect(resp.response.err, equals(38)); // ENOSYS

      await channel.sink.close();
      await driver.close();
    });

    test('open defaults to success when no handler', () async {
      final driver = BentosDriver();
      await driver.serve(sockUri);

      final channel = await connectDriver(sockUri);

      final msg = FuseMessage(
        id: fixnum.Int64(4),
        fh: fixnum.Int64(0),
        request: FuseRequest(open: OpenReq(flags: 0)),
      );
      channel.sink.add(Uint8List.fromList(msg.writeToBuffer()));

      final respBytes = await channel.stream.first;
      final resp = FuseMessage.fromBuffer(respBytes);

      expect(resp.response.err, equals(0));
      expect(resp.response.whichReply(), FuseResponse_Reply.open);

      await channel.sink.close();
      await driver.close();
    });

    test('handles multiple connections', () async {
      var readCount = 0;
      final driver = BentosDriver(
        onRead: (req, ctx) {
          readCount++;
          return FuseResponse(buf: BufReply(data: [readCount]));
        },
      );
      await driver.serve(sockUri);

      // Two connections (simulating two fuse_sessions).
      final ch1 = await connectDriver(sockUri);
      final ch2 = await connectDriver(sockUri);

      final msg = FuseMessage(
        id: fixnum.Int64(1),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(1), offset: fixnum.Int64(0)),
        ),
      );
      ch1.sink.add(Uint8List.fromList(msg.writeToBuffer()));
      ch2.sink.add(Uint8List.fromList(msg.writeToBuffer()));

      final r1 = FuseMessage.fromBuffer(await ch1.stream.first);
      final r2 = FuseMessage.fromBuffer(await ch2.stream.first);

      expect(r1.response.buf.data, isNotEmpty);
      expect(r2.response.buf.data, isNotEmpty);
      expect(readCount, equals(2));

      await ch1.sink.close();
      await ch2.sink.close();
      await driver.close();
    });

    test('DriverContext provides fh and connection', () async {
      DriverContext? captured;
      final driver = BentosDriver(
        onRead: (req, ctx) {
          captured = ctx;
          return FuseResponse(buf: BufReply(data: []));
        },
      );
      await driver.serve(sockUri);

      final channel = await connectDriver(sockUri);

      final msg = FuseMessage(
        id: fixnum.Int64(1),
        fh: fixnum.Int64(42),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(1), offset: fixnum.Int64(0)),
        ),
      );
      channel.sink.add(Uint8List.fromList(msg.writeToBuffer()));
      await channel.stream.first;

      expect(captured, isNotNull);
      expect(captured!.fh, equals(fixnum.Int64(42)));
      expect(captured!.connection, isA<DriverConnection>());

      await channel.sink.close();
      await driver.close();
    });

    test('DriverError from callback maps to errno in response', () async {
      final driver = BentosDriver(
        onRead: (req, ctx) =>
            throw DriverError.notFound('key missing'),
      );
      await driver.serve(sockUri);

      final channel = await connectDriver(sockUri);

      final msg = FuseMessage(
        id: fixnum.Int64(1),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(100), offset: fixnum.Int64(0)),
        ),
      );
      channel.sink.add(Uint8List.fromList(msg.writeToBuffer()));

      final respBytes = await channel.stream.first;
      final resp = FuseMessage.fromBuffer(respBytes);

      expect(resp.response.err, equals(2)); // ENOENT

      await channel.sink.close();
      await driver.close();
    });

    test('serveChannel serves over an in-process channel pair (no socket)',
        () async {
      final driver = BentosDriver(
        onRead: (req, ctx) =>
            FuseResponse(buf: BufReply(data: utf8.encode('in-process'))),
      );
      // A connected channel pair — kernel end (local) ↔ driver end (foreign).
      final pair = StreamChannelController<Uint8List>();
      driver.serveChannel(pair.foreign);

      final msg = FuseMessage(
        id: fixnum.Int64(7),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)),
        ),
      );
      pair.local.sink.add(Uint8List.fromList(msg.writeToBuffer()));

      final resp = FuseMessage.fromBuffer(await pair.local.stream.first);
      expect(resp.id, equals(fixnum.Int64(7)));
      expect(resp.response.err, equals(0));
      expect(utf8.decode(resp.response.buf.data), equals('in-process'));

      await driver.close();
    });

    test('async callbacks work correctly', () async {
      final driver = BentosDriver(
        onRead: (req, ctx) async {
          // Simulate async work.
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return FuseResponse(
            buf: BufReply(data: utf8.encode('async result')),
          );
        },
      );
      await driver.serve(sockUri);

      final channel = await connectDriver(sockUri);

      final msg = FuseMessage(
        id: fixnum.Int64(1),
        fh: fixnum.Int64(1),
        request: FuseRequest(
          read: ReadReq(size: fixnum.Int64(4096), offset: fixnum.Int64(0)),
        ),
      );
      channel.sink.add(Uint8List.fromList(msg.writeToBuffer()));

      final respBytes = await channel.stream.first;
      final resp = FuseMessage.fromBuffer(respBytes);

      expect(resp.response.err, equals(0));
      expect(utf8.decode(resp.response.buf.data), equals('async result'));

      await channel.sink.close();
      await driver.close();
    });
  });
}
