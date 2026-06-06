/// P4 Configured Stream framework — composes [BentosDriver] from
/// [ConfiguredStreamOps] + [ConfigCodec].
///
/// State machine: OPEN -> CONFIGURED -> PROCESSING -> STREAMING -> DRAINING -> COMPLETE.
/// ioctl configures, write() accumulates, flush()/read() triggers processing,
/// output stream chunks delivered via read().
library;

import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';

import 'driver.dart';
import 'driver_context.dart';
import 'driver_error.dart';
import 'configured_stream_ops.dart';

final _log = Logger('ConfiguredStreamDriver');

/// State machine phases for P4.
enum _Phase { open, configured, processing, streaming, draining, complete }

/// Framework-level ioctl commands (type byte 0xBE).
class _FwIoctl {
  static const typeByte = 0xBE;

  // Command numbers within 0xBE type.
  static const getState = 0x00;
  static const drain = 0x01;
  static const drop = 0x02;
  static const reset = 0x03;
  static const getError = 0x04;

  /// Extract type byte from ioctl cmd (bits 15-8).
  static int typeOf(int cmd) => (cmd >> 8) & 0xFF;

  /// Extract number from ioctl cmd (bits 7-0).
  static int numberOf(int cmd) => cmd & 0xFF;
}

/// Per-session runtime state managed by the framework.
final class _Session<C, S> {
  _Session({required this.config, required this.state});

  /// Current config.
  C config;

  /// Driver-provided session state (opaque to framework).
  final S? state;

  /// Current state machine phase.
  _Phase phase = _Phase.open;

  /// Accumulated write data (input buffer).
  final input = BytesBuilder(copy: false);

  /// Buffered output chunks (serialized).
  final outputBuffer = Queue<Uint8List>();

  /// Subscription to the process output stream.
  StreamSubscription<Uint8List>? outputSub;

  /// Whether the output stream has ended.
  bool outputDone = false;

  /// Stream error, if the process stream errored.
  Object? streamError;
  StackTrace? streamErrorStack;
}

/// Pattern 4: Configured Stream framework.
///
/// Wraps [ConfiguredStreamOps] + [ConfigCodec] into a [BentosDriver] that
/// manages per-fd sessions, config via ioctl, input accumulation, output
/// streaming, state machine enforcement, and FUSE op translation.
///
/// ```dart
/// final driver = ConfiguredStreamDriver(synthOps, configCodec: SynthConfigCodec());
/// await driver.serve(Uri.parse('unix:///tmp/my.sock'));
/// ```
final class ConfiguredStreamDriver<C, I, O, S> {
  ConfiguredStreamDriver(this.ops, {required this.configCodec});

  final ConfiguredStreamOps<C, I, O, S> ops;
  final ConfigCodec<C> configCodec;

  late final BentosDriver _driver;
  final _sessions = <int, _Session<C, S>>{};

  BentosDriver _build() => BentosDriver(
        onOpen: _onOpen,
        onRead: _onRead,
        onWrite: _onWrite,
        onFlush: _onFlush,
        onRelease: _onRelease,
        onIoctl: _onIoctl,
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
      state = await ops.onSessionStart!();
    }

    _sessions[fh] = _Session<C, S>(
      config: ops.defaultConfig(),
      state: state,
    );
    return FuseResponse(open: OpenReply());
  }

  Future<FuseResponse> _onRead(ReadReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    switch (session.phase) {
      case _Phase.open:
      case _Phase.configured:
        // No data to read yet — EAGAIN.
        return FuseResponse(err: 11); // EAGAIN

      case _Phase.processing:
        // Still waiting for first chunk — implicit flush if accumulating,
        // but from PROCESSING we just wait. Return EAGAIN.
        return FuseResponse(err: 11); // EAGAIN

      case _Phase.streaming:
      case _Phase.draining:
        if (session.outputBuffer.isEmpty) {
          if (session.outputDone) {
            // Check for stream error.
            if (session.streamError != null) {
              final err = session.streamError;
              session.phase = _Phase.complete;
              if (err is DriverError) return FuseResponse(err: err.errno);
              return FuseResponse(err: 5); // EIO
            }
            // All output consumed — EOF, transition to COMPLETE.
            session.phase = _Phase.complete;
            return FuseResponse(buf: BufReply(data: []));
          }
          // Stream still running but no buffered data — empty.
          return FuseResponse(buf: BufReply(data: []));
        }
        return _deliverOutput(session, req.size.toInt());

      case _Phase.complete:
        // EOF — signal end.
        return FuseResponse(buf: BufReply(data: []));
    }
  }

  FuseResponse _deliverOutput(_Session<C, S> session, int size) {
    final result = BytesBuilder(copy: false);
    var remaining = size;
    while (remaining > 0 && session.outputBuffer.isNotEmpty) {
      final chunk = session.outputBuffer.removeFirst();
      if (chunk.length <= remaining) {
        result.add(chunk);
        remaining -= chunk.length;
      } else {
        result.add(Uint8List.sublistView(chunk, 0, remaining));
        session.outputBuffer
            .addFirst(Uint8List.sublistView(chunk, remaining));
        remaining = 0;
      }
    }

    // If buffer drained and stream done, mark draining.
    if (session.outputBuffer.isEmpty && session.outputDone) {
      session.phase = _Phase.draining;
    }

    return FuseResponse(buf: BufReply(data: result.takeBytes()));
  }

  Future<FuseResponse> _onWrite(WriteReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    switch (session.phase) {
      case _Phase.open:
        // First write with default config — advance to CONFIGURED.
        session.phase = _Phase.configured;
        session.input.add(Uint8List.fromList(req.data));
        return FuseResponse(
          write: WriteReply(count: fixnum.Int64(req.data.length)),
        );

      case _Phase.configured:
        // More writes accumulate.
        session.input.add(Uint8List.fromList(req.data));
        return FuseResponse(
          write: WriteReply(count: fixnum.Int64(req.data.length)),
        );

      case _Phase.complete:
        // New write restarts the cycle.
        session.phase = _Phase.configured;
        session.streamError = null;
        session.streamErrorStack = null;
        session.input.add(Uint8List.fromList(req.data));
        return FuseResponse(
          write: WriteReply(count: fixnum.Int64(req.data.length)),
        );

      case _Phase.processing:
      case _Phase.streaming:
      case _Phase.draining:
        return FuseResponse(err: 16); // EBUSY
    }
  }

  Future<FuseResponse> _onFlush(FlushReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    if (session.phase == _Phase.configured) {
      await _submit(session);
    }
    return FuseResponse();
  }

  /// Submit accumulated input to process().
  Future<void> _submit(_Session<C, S> session) async {
    session.phase = _Phase.processing;
    final rawInput = session.input.takeBytes();

    if (ops.decodeInput == null) {
      session.phase = _Phase.configured;
      throw DriverError.notSupported(
          'decodeInput not provided — subsystem must supply a default');
    }

    I input;
    try {
      input = ops.decodeInput!(rawInput, config: session.config);
    } on DriverError {
      session.phase = _Phase.configured;
      rethrow;
    } catch (e, st) {
      _log.warning('decodeInput error', e, st);
      session.phase = _Phase.configured;
      throw DriverError.invalidArgument('Failed to decode input: $e');
    }

    final stream = ops.process(
      input,
      session.config,
      session: session.state as S,
    );

    if (ops.encodeOutput == null) {
      session.phase = _Phase.configured;
      throw DriverError.notSupported(
          'encodeOutput not provided — subsystem must supply a default');
    }

    session.outputDone = false;
    session.outputSub = stream
        .map((chunk) => ops.encodeOutput!(chunk, config: session.config))
        .listen(
      (encoded) {
        session.outputBuffer.add(encoded);
        if (session.phase == _Phase.processing) {
          session.phase = _Phase.streaming;
        }
      },
      onDone: () {
        session.outputDone = true;
        if (session.outputBuffer.isEmpty) {
          session.phase = _Phase.complete;
          if (ops.onDrain != null) {
            ops.onDrain!(session: session.state as S);
          }
        } else {
          session.phase = _Phase.draining;
          if (ops.onDrain != null) {
            ops.onDrain!(session: session.state as S);
          }
        }
      },
      onError: (Object e, StackTrace st) {
        _log.warning('Process stream error', e, st);
        session.streamError = e;
        session.streamErrorStack = st;
        session.outputDone = true;
        if (session.outputBuffer.isEmpty) {
          session.phase = _Phase.complete;
        } else {
          session.phase = _Phase.draining;
        }
      },
    );
  }

  Future<FuseResponse> _onIoctl(IoctlReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    final cmd = req.cmd;
    final typeB = _FwIoctl.typeOf(cmd);
    final num = _FwIoctl.numberOf(cmd);

    // Framework-level ioctls (type 0xBE).
    if (typeB == _FwIoctl.typeByte) {
      return _handleFwIoctl(session, num, req);
    }

    // Subsystem-level ioctl — try config codec (write-direction) first,
    // then fall through to onQuery (read-direction) if codec rejects.
    try {
      final newConfig = configCodec.apply(
        session.config,
        cmd,
        Uint8List.fromList(req.inBuf),
      );
      // Codec recognized this cmd — it's a config write.
      if (session.phase != _Phase.open && session.phase != _Phase.configured) {
        return FuseResponse(err: 16); // EBUSY — config only in OPEN/CONFIGURED
      }
      session.config = newConfig;
      if (session.phase == _Phase.open) {
        session.phase = _Phase.configured;
      }
      return FuseResponse(ioctl: IoctlReply(result: 0));
    } on DriverError {
      // Codec didn't handle it — fall through to onQuery.
    }

    // Read-direction query — available in any phase.
    if (ops.onQuery != null) {
      try {
        final result =
            await ops.onQuery!(cmd, session: session.state as S);
        return FuseResponse(ioctl: IoctlReply(buf: result, result: 0));
      } on DriverError catch (e) {
        return FuseResponse(err: e.errno);
      }
    }

    return FuseResponse(err: 22); // EINVAL — unrecognized ioctl
  }

  Future<FuseResponse> _handleFwIoctl(
      _Session<C, S> session, int num, IoctlReq req) async {
    switch (num) {
      case _FwIoctl.getState:
        return FuseResponse(
            ioctl: IoctlReply(result: session.phase.index));

      case _FwIoctl.drain:
        // DRAIN: no-op acknowledgement — stream completes naturally.
        // Valid in PROCESSING, STREAMING. Already done in DRAINING/COMPLETE.
        if (session.phase == _Phase.open ||
            session.phase == _Phase.configured) {
          return FuseResponse(err: 22); // EINVAL — nothing to drain
        }
        return FuseResponse(ioctl: IoctlReply(result: 0));

      case _FwIoctl.drop:
        return _handleDrop(session);

      case _FwIoctl.reset:
        return _handleReset(session);

      case _FwIoctl.getError:
        if (session.phase != _Phase.complete) {
          return FuseResponse(err: 22); // EINVAL
        }
        if (session.streamError == null) {
          return FuseResponse(ioctl: IoctlReply(result: 0));
        }
        final errno =
            session.streamError is DriverError
                ? (session.streamError! as DriverError).errno
                : 5; // EIO
        return FuseResponse(ioctl: IoctlReply(result: errno));

      default:
        return FuseResponse(err: 22); // EINVAL — unknown framework ioctl
    }
  }

  Future<FuseResponse> _handleDrop(_Session<C, S> session) async {
    switch (session.phase) {
      case _Phase.processing:
      case _Phase.streaming:
      case _Phase.draining:
        await session.outputSub?.cancel();
        session.outputSub = null;
        session.outputBuffer.clear();
        session.outputDone = false;
        session.streamError = null;
        session.streamErrorStack = null;
        session.phase = _Phase.configured;

        if (ops.onCancel != null) {
          await ops.onCancel!(session: session.state as S);
        }
        return FuseResponse(ioctl: IoctlReply(result: 0));

      default:
        return FuseResponse(err: 22); // EINVAL — not in active state
    }
  }

  Future<FuseResponse> _handleReset(_Session<C, S> session) async {
    // Cancel any in-flight processing.
    if (session.outputSub != null) {
      await session.outputSub!.cancel();
      session.outputSub = null;

      if (ops.onCancel != null &&
          (session.phase == _Phase.processing ||
              session.phase == _Phase.streaming ||
              session.phase == _Phase.draining)) {
        await ops.onCancel!(session: session.state as S);
      }
    }

    session.outputBuffer.clear();
    session.outputDone = false;
    session.streamError = null;
    session.streamErrorStack = null;
    session.input.clear();
    session.config = ops.defaultConfig();
    session.phase = _Phase.open;

    return FuseResponse(ioctl: IoctlReply(result: 0));
  }

  FuseResponse _onPoll(PollReq req, DriverContext ctx) {
    final fh = ctx.fh.toInt();
    final session = _sessions[fh];
    if (session == null) return FuseResponse(err: 5); // EIO

    var revents = 0;
    const pollin = 0x01;
    const pollout = 0x04;

    switch (session.phase) {
      case _Phase.open:
      case _Phase.configured:
        revents |= pollout;
      case _Phase.processing:
        // Neither — work in progress.
        break;
      case _Phase.streaming:
      case _Phase.draining:
        if (session.outputBuffer.isNotEmpty) {
          revents |= pollin;
        }
      case _Phase.complete:
        // Neither — EOF delivered.
        break;
    }

    return FuseResponse(poll: PollReply(revents: revents));
  }

  Future<FuseResponse> _onRelease(ReleaseReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    final session = _sessions.remove(fh);
    if (session == null) return FuseResponse();

    await session.outputSub?.cancel();

    if (ops.onSessionEnd != null) {
      await ops.onSessionEnd!(session: session.state as S);
    }

    return FuseResponse();
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
