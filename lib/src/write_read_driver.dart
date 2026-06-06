/// P2 Write-then-Read framework — composes [BentosDriver] from [WriteReadOps].
///
/// State machine: IDLE -> ACCUMULATING -> PROCESSING -> RESPONSE_READY -> IDLE.
/// write() accumulates input; flush()/read() triggers submission to [onRequest].
/// POLLIN and POLLOUT are mutually exclusive.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';

import 'driver.dart';
import 'driver_context.dart';
import 'driver_error.dart';
import 'write_read_ops.dart';

final _log = Logger('WriteReadDriver');

/// Per-session state machine phases.
enum _Phase { idle, accumulating, processing, responseReady }

/// Per-session runtime state managed by the framework.
final class _Session<S> {
  _Session({required this.state});

  /// Driver-provided session state (opaque to framework).
  final S? state;

  /// Current state machine phase.
  _Phase phase = _Phase.idle;

  /// Accumulated write data (request buffer).
  final _input = BytesBuilder(copy: false);

  /// Response buffer from onRequest.
  Uint8List? _response;

  /// Byte offset into response for partial reads.
  int _responseOffset = 0;
}

/// Pattern 2: Write-then-Read framework.
///
/// Wraps [WriteReadOps] into a [BentosDriver] that manages per-fd sessions,
/// request accumulation, state machine enforcement, and FUSE op translation.
///
/// ```dart
/// final driver = WriteReadDriver(WriteReadOps(
///   onRequest: (input, {required session}) async {
///     return utf8.encode('got: ${utf8.decode(input)}') as Uint8List;
///   },
/// ));
/// await driver.serve(Uri.parse('unix:///tmp/my.sock'));
/// ```
final class WriteReadDriver<S> {
  WriteReadDriver(this.ops);

  final WriteReadOps<S> ops;

  late final BentosDriver _driver;
  final _sessions = <int, _Session<S>>{};

  BentosDriver _build() => BentosDriver(
        onOpen: _onOpen,
        onRead: _onRead,
        onWrite: _onWrite,
        onFlush: _onFlush,
        onRelease: _onRelease,
        onPoll: _onPoll,
      );

  /// Start serving on [endpoint].
  Future<void> serve(Uri endpoint) async {
    _driver = _build();
    await _driver.serve(endpoint);
  }

  /// Serve this pattern over an already-framed [channel] — the in-process seam
  /// (see [BentosDriver.serveChannel]).
  void serveChannel(StreamChannel<Uint8List> channel) {
    _driver = _build();
    _driver.serveChannel(channel);
  }

  Future<FuseResponse> _onOpen(OpenReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    S? state;
    if (ops.onSessionStart != null) {
      state = await ops.onSessionStart!(req.flags);
    }
    _sessions[fh] = _Session<S>(state: state);
    return FuseResponse(open: OpenReply());
  }

  Future<FuseResponse> _onRead(ReadReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    switch (session.phase) {
      case _Phase.idle:
        // No request submitted — nothing to read.
        return FuseResponse(err: 11); // EAGAIN

      case _Phase.accumulating:
        // read() triggers submission (same as flush then read).
        await _submit(session);
        return _deliverResponse(session, req.size.toInt());

      case _Phase.processing:
        // Still processing — should not happen in single-threaded model,
        // but guard anyway.
        return FuseResponse(err: 11); // EAGAIN

      case _Phase.responseReady:
        return _deliverResponse(session, req.size.toInt());
    }
  }

  FuseResponse _deliverResponse(_Session<S> session, int size) {
    final resp = session._response!;
    final offset = session._responseOffset;
    final remaining = resp.length - offset;

    if (remaining <= 0) {
      // Response fully consumed — back to IDLE.
      session.phase = _Phase.idle;
      session._response = null;
      session._responseOffset = 0;
      return FuseResponse(buf: BufReply(data: []));
    }

    final toSend = remaining < size ? remaining : size;
    final chunk = Uint8List.sublistView(resp, offset, offset + toSend);
    session._responseOffset += toSend;

    // If fully consumed after this read, transition to IDLE.
    if (session._responseOffset >= resp.length) {
      session.phase = _Phase.idle;
      session._response = null;
      session._responseOffset = 0;
    }

    return FuseResponse(buf: BufReply(data: chunk));
  }

  Future<FuseResponse> _onWrite(WriteReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    switch (session.phase) {
      case _Phase.idle:
        // First write — transition to ACCUMULATING.
        session.phase = _Phase.accumulating;
        session._input.add(Uint8List.fromList(req.data));
        return FuseResponse(
          write: WriteReply(count: fixnum.Int64(req.data.length)),
        );

      case _Phase.accumulating:
        // More writes append.
        session._input.add(Uint8List.fromList(req.data));
        return FuseResponse(
          write: WriteReply(count: fixnum.Int64(req.data.length)),
        );

      case _Phase.processing:
      case _Phase.responseReady:
        // Cannot write during processing or while response pending.
        return FuseResponse(err: 16); // EBUSY
    }
  }

  Future<FuseResponse> _onFlush(FlushReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    if (session.phase == _Phase.accumulating) {
      await _submit(session);
    }
    return FuseResponse();
  }

  /// Submit accumulated input to [onRequest].
  Future<void> _submit(_Session<S> session) async {
    session.phase = _Phase.processing;
    final input = session._input.takeBytes();
    try {
      final response = await ops.onRequest(
        input,
        session: session.state as S,
      );
      session._response = response;
      session._responseOffset = 0;
      session.phase = _Phase.responseReady;
    } on DriverError catch (e) {
      _log.warning('onRequest error: $e');
      // On error, reset to IDLE so the session is usable again.
      session.phase = _Phase.idle;
      rethrow;
    } catch (e, st) {
      _log.warning('onRequest unhandled error', e, st);
      session.phase = _Phase.idle;
      rethrow;
    }
  }

  Future<FuseResponse> _onRelease(ReleaseReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions.remove(fh);
    if (session == null) return FuseResponse();

    if (ops.onSessionEnd != null) {
      await ops.onSessionEnd!(session: session.state as S);
    }

    return FuseResponse();
  }

  FuseResponse _onPoll(PollReq req, DriverContext ctx) {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    var revents = 0;
    const pollout = 0x04;
    const pollin = 0x01;

    // POLLIN and POLLOUT are mutually exclusive for P2.
    switch (session.phase) {
      case _Phase.idle:
      case _Phase.accumulating:
        revents |= pollout;
      case _Phase.processing:
        // Neither — request in flight.
        break;
      case _Phase.responseReady:
        revents |= pollin;
    }

    return FuseResponse(poll: PollReply(revents: revents));
  }

  /// Stop serving and close all sessions.
  Future<void> close() async {
    _sessions.clear();
    await _driver.close();
  }
}
