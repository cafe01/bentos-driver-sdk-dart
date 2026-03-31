/// P1 Pure Stream framework — composes [BentosDriver] from [StreamOps].
///
/// Handles per-session state management, output buffering, poll readiness,
/// and error translation. The driver developer provides domain callbacks
/// via [StreamOps] and never touches FUSE types.
library;

import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:logging/logging.dart';

import 'driver.dart';
import 'driver_context.dart';
import 'driver_error.dart';
import 'stream_ops.dart';

final _log = Logger('StreamDriver');

/// Per-session runtime state managed by the framework.
final class _Session<S> {
  _Session({required this.state});

  /// Driver-provided session state (opaque to framework).
  final S? state;

  /// Buffered output chunks from the output stream.
  final outputBuffer = Queue<Uint8List>();

  /// Subscription to the output stream.
  StreamSubscription<Uint8List>? outputSub;

  /// Whether the output stream has ended.
  bool outputDone = false;
}

/// Pattern 1: Pure Stream framework.
///
/// Wraps [StreamOps] into a [BentosDriver] that manages per-fd sessions,
/// output buffering, and FUSE op translation.
///
/// ```dart
/// final driver = StreamDriver(StreamOps(
///   onData: (data, {required session}) {
///     // echo: push written data to output
///     return data.length;
///   },
///   outputStream: ({required session}) => myStream,
/// ));
/// await driver.serve(Uri.parse('unix:///tmp/my.sock'));
/// ```
final class StreamDriver<S> {
  StreamDriver(this.ops);

  final StreamOps<S> ops;

  late final BentosDriver _driver;
  final _sessions = <int, _Session<S>>{};

  /// Start serving on [endpoint].
  Future<void> serve(Uri endpoint) async {
    _driver = BentosDriver(
      onOpen: _onOpen,
      onRead: _onRead,
      onWrite: _onWrite,
      onFlush: _onFlush,
      onRelease: _onRelease,
      onPoll: _onPoll,
    );
    await _driver.serve(endpoint);
  }

  Future<FuseResponse> _onOpen(OpenReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    S? state;
    if (ops.onSessionStart != null) {
      state = await ops.onSessionStart!(req.flags);
    }

    final session = _Session<S>(state: state);

    // Start output stream if provided.
    if (ops.outputStream != null) {
      final stream = ops.outputStream!(session: state);
      session.outputSub = stream.listen(
        (chunk) => session.outputBuffer.add(chunk),
        onDone: () => session.outputDone = true,
        onError: (Object e, StackTrace st) {
          _log.warning('Output stream error for fh=$fh', e, st);
          session.outputDone = true;
        },
      );
    } else {
      session.outputDone = true;
    }

    _sessions[fh] = session;
    return FuseResponse(open: OpenReply());
  }

  FuseResponse _onRead(ReadReq req, DriverContext ctx) {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    final size = req.size.toInt();

    if (session.outputBuffer.isEmpty) {
      // No data available — return empty (EOF-like for chardev).
      return FuseResponse(buf: BufReply(data: []));
    }

    // Drain up to `size` bytes from the output buffer.
    final result = BytesBuilder(copy: false);
    var remaining = size;
    while (remaining > 0 && session.outputBuffer.isNotEmpty) {
      final chunk = session.outputBuffer.removeFirst();
      if (chunk.length <= remaining) {
        result.add(chunk);
        remaining -= chunk.length;
      } else {
        result.add(Uint8List.sublistView(chunk, 0, remaining));
        session.outputBuffer.addFirst(
            Uint8List.sublistView(chunk, remaining));
        remaining = 0;
      }
    }

    return FuseResponse(buf: BufReply(data: result.takeBytes()));
  }

  Future<FuseResponse> _onWrite(WriteReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    try {
      final consumed = await ops.onData(
        Uint8List.fromList(req.data),
        session: session.state,
      );
      return FuseResponse(
        write: WriteReply(count: fixnum.Int64(consumed)),
      );
    } on DriverError catch (e) {
      return FuseResponse(err: e.errno);
    }
  }

  FuseResponse _onFlush(FlushReq req, DriverContext ctx) {
    return FuseResponse();
  }

  Future<FuseResponse> _onRelease(ReleaseReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions.remove(fh);
    if (session == null) return FuseResponse();

    await session.outputSub?.cancel();

    if (ops.onSessionEnd != null) {
      await ops.onSessionEnd!(session: session.state);
    }

    return FuseResponse();
  }

  FuseResponse _onPoll(PollReq req, DriverContext ctx) {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    var revents = 0;
    // POLLOUT — always ready (driver can always accept writes).
    const pollout = 0x04;
    // POLLIN — output buffer has data.
    const pollin = 0x01;

    revents |= pollout;
    if (session.outputBuffer.isNotEmpty) {
      revents |= pollin;
    }

    return FuseResponse(poll: PollReply(revents: revents));
  }

  /// Stop serving and close all sessions.
  Future<void> close() async {
    for (final session in _sessions.values) {
      await session.outputSub?.cancel();
    }
    _sessions.clear();
    await _driver.close();
  }
}
