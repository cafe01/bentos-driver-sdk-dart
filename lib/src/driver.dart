/// Driver-side SDK for the BentOS FUSE/CUSE op tunnel.
///
/// A driver is a Dart program that implements FUSE/CUSE ops. It listens on a
/// socket, receives [FuseMessage] requests from bentosd, and sends
/// [FuseResponse] replies back.
///
/// ```dart
/// final driver = BentosDriver(
///   onRead: (req, ctx) => FuseResponse(buf: BufReply(data: utf8.encode('Hello!\n'))),
///   onWrite: (req, ctx) => FuseResponse(write: WriteReply(count: Int64(req.data.length))),
/// );
/// await driver.serve(Uri.parse('unix:///run/bentos/drivers/hello.sock'));
/// ```
///
/// No libfuse3 dependency — pure Dart.
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';

import 'driver_context.dart';
import 'driver_error.dart';
import 'generated/fuse_wire.pb.dart';
import 'length_prefixed.dart';
import 'socket_sink.dart';

export 'generated/fuse_wire.pb.dart';

final _log = Logger('BentosDriver');

/// A driver connection — one fuse_session talking to this driver.
final class DriverConnection {
  DriverConnection._(this._channel);

  final StreamChannel<Uint8List> _channel;
  StreamSubscription<Uint8List>? _sub;

  void _listen(Future<FuseMessage> Function(FuseMessage, DriverConnection) handler) {
    _sub = _channel.stream.listen((bytes) async {
      final msg = FuseMessage.fromBuffer(bytes);
      try {
        final resp = await handler(msg, this);
        _channel.sink.add(Uint8List.fromList(resp.writeToBuffer()));
      } catch (e, st) {
        _log.severe('Handler error for request id=${msg.id}', e, st);
        // Reply with EIO on unhandled errors.
        final errResp = FuseMessage(
          id: msg.id,
          fh: msg.fh,
          response: FuseResponse(err: 5),
        );
        _channel.sink.add(Uint8List.fromList(errResp.writeToBuffer()));
      }
    });
  }

  Future<void> close() async {
    await _sub?.cancel();
    await _channel.sink.close();
  }
}

/// Callback-based driver that serves FUSE/CUSE ops over a socket.
///
/// Each callback receives the request-specific message and a [DriverContext],
/// and returns the reply. Callbacks may be sync or async (`FutureOr`).
/// Return null to reply with ENOSYS.
final class BentosDriver {
  BentosDriver({
    this.onOpen,
    this.onRead,
    this.onWrite,
    this.onFlush,
    this.onRelease,
    this.onFsync,
    this.onIoctl,
    this.onPoll,
  });

  final FutureOr<FuseResponse> Function(OpenReq req, DriverContext ctx)? onOpen;
  final FutureOr<FuseResponse> Function(ReadReq req, DriverContext ctx)? onRead;
  final FutureOr<FuseResponse> Function(WriteReq req, DriverContext ctx)? onWrite;
  final FutureOr<FuseResponse> Function(FlushReq req, DriverContext ctx)? onFlush;
  final FutureOr<FuseResponse> Function(ReleaseReq req, DriverContext ctx)? onRelease;
  final FutureOr<FuseResponse> Function(FsyncReq req, DriverContext ctx)? onFsync;
  final FutureOr<FuseResponse> Function(IoctlReq req, DriverContext ctx)? onIoctl;
  final FutureOr<FuseResponse> Function(PollReq req, DriverContext ctx)? onPoll;

  ServerSocket? _server;
  final _connections = <DriverConnection>[];

  /// Start serving on [endpoint]. Supports `unix://` and `tcp://` schemes.
  Future<void> serve(Uri endpoint) async {
    switch (endpoint.scheme) {
      case 'unix':
        // Remove stale socket file if present.
        final file = File(endpoint.path);
        if (file.existsSync()) file.deleteSync();
        _server = await ServerSocket.bind(
          InternetAddress(endpoint.path, type: InternetAddressType.unix),
          0,
        );
      case 'tcp':
        _server = await ServerSocket.bind(endpoint.host, endpoint.port);
      default:
        throw ArgumentError.value(
          endpoint, 'endpoint', 'Unsupported scheme: ${endpoint.scheme}');
    }

    _log.info('Serving on $endpoint');
    _server!.listen(_handleConnection);
  }

  void _handleConnection(Socket socket) {
    _log.fine('New connection');
    final raw = StreamChannel<Uint8List>(
      socket.cast<Uint8List>(),
      SocketSink(socket),
    );
    final framed = raw.transform(lengthPrefixedTransformer());
    final conn = DriverConnection._(framed);
    _connections.add(conn);
    conn._listen(_dispatch);
  }

  Future<FuseMessage> _dispatch(FuseMessage msg, DriverConnection conn) async {
    if (!msg.hasRequest()) {
      return FuseMessage(
        id: msg.id,
        fh: msg.fh,
        response: FuseResponse(err: 22), // EINVAL
      );
    }

    final ctx = DriverContext(fh: msg.fh, connection: conn);
    final resp = await _dispatchOp(msg.request, ctx);
    return FuseMessage(id: msg.id, fh: msg.fh, response: resp);
  }

  Future<FuseResponse> _dispatchOp(FuseRequest req, DriverContext ctx) async {
    try {
      return switch (req.whichOp()) {
        FuseRequest_Op.open =>
          await _call(onOpen, req.open, ctx) ??
              FuseResponse(open: OpenReply()),
        FuseRequest_Op.read =>
          await _call(onRead, req.read, ctx) ?? _enosys(),
        FuseRequest_Op.write =>
          await _call(onWrite, req.write, ctx) ?? _enosys(),
        FuseRequest_Op.flush =>
          await _call(onFlush, req.flush, ctx) ?? FuseResponse(),
        FuseRequest_Op.release =>
          await _call(onRelease, req.release, ctx) ?? FuseResponse(),
        FuseRequest_Op.fsync =>
          await _call(onFsync, req.fsync, ctx) ?? FuseResponse(),
        FuseRequest_Op.ioctl =>
          await _call(onIoctl, req.ioctl, ctx) ?? _enosys(),
        FuseRequest_Op.poll =>
          await _call(onPoll, req.poll, ctx) ?? _enosys(),
        _ => _enosys(),
      };
    } on DriverError catch (e) {
      _log.fine('DriverError in op: $e');
      return FuseResponse(err: e.errno);
    }
  }

  /// Call a nullable async callback, returning null if the callback is null.
  static Future<FuseResponse?> _call<R>(
    FutureOr<FuseResponse> Function(R req, DriverContext ctx)? handler,
    R req,
    DriverContext ctx,
  ) async {
    if (handler == null) return null;
    return handler(req, ctx);
  }

  static FuseResponse _enosys() => FuseResponse(err: 38);

  /// Stop serving and close all connections.
  Future<void> close() async {
    await _server?.close();
    for (final conn in _connections) {
      await conn.close();
    }
    _connections.clear();
  }
}
