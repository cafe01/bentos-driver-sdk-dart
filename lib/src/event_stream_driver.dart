/// P3 Event Stream framework — composes [BentosDriver] from [EventStreamOps].
///
/// Read-only device with first-open/last-close activation semantics.
/// Events emitted via [emit] are broadcast to all listeners' individual queues.
/// write() returns EACCES. read() delivers whole events, never partial.
library;

import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';

import 'driver.dart';
import 'driver_context.dart';
import 'event_stream_ops.dart';

final _log = Logger('EventStreamDriver');

/// Per-listener event queue managed by the framework.
final class _Listener {
  _Listener({required this.maxEvents});

  final Queue<Uint8List> eventQueue = Queue<Uint8List>();

  /// Max events per listener queue (drop-oldest overflow).
  final int maxEvents;
}

/// Pattern 3: Event Stream (Read-Only) framework.
///
/// Wraps [EventStreamOps] into a [BentosDriver] that manages per-device
/// activation, per-listener event queues, and FUSE op translation.
///
/// The driver pushes events via [emit]. The framework serializes, queues,
/// and delivers them to all open listeners.
///
/// ```dart
/// final driver = EventStreamDriver(EventStreamOps<int>(
///   encodeEvent: (n) => utf8.encode('$n\n') as Uint8List,
///   onActivate: () => startTicking(),
///   onDeactivate: () => stopTicking(),
/// ));
/// await driver.serve(Uri.parse('unix:///tmp/my.sock'));
/// // Later: driver.emit(42);
/// ```
final class EventStreamDriver<E> {
  EventStreamDriver(this.ops, {this.maxEventsPerListener = 256});

  final EventStreamOps<E> ops;

  /// Max queued events per listener before drop-oldest kicks in.
  final int maxEventsPerListener;

  late final BentosDriver _driver;
  final _listeners = <int, _Listener>{};

  /// Whether the device is active (at least one listener).
  bool get active => _listeners.isNotEmpty;

  /// Push an event to all open listeners.
  ///
  /// The framework serializes via [EventStreamOps.encodeEvent] and
  /// enqueues to each listener's individual queue.
  void emit(E event) {
    if (_listeners.isEmpty) return;

    final encoded = ops.encodeEvent(event);
    for (final listener in _listeners.values) {
      if (listener.eventQueue.length >= listener.maxEvents) {
        listener.eventQueue.removeFirst(); // drop oldest
      }
      listener.eventQueue.add(encoded);
    }
  }

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
    final wasEmpty = _listeners.isEmpty;

    _listeners[fh] = _Listener(maxEvents: maxEventsPerListener);

    // First listener — activate.
    if (wasEmpty && ops.onActivate != null) {
      try {
        await ops.onActivate!();
      } catch (e, st) {
        _log.warning('onActivate error', e, st);
        _listeners.remove(fh);
        return FuseResponse(err: 5); // EIO
      }
    }

    return FuseResponse(open: OpenReply());
  }

  FuseResponse _onRead(ReadReq req, DriverContext ctx) {
    final fh = ctx.fh.toInt();
    final listener = _listeners[fh];
    if (listener == null) return FuseResponse(err: 5); // EIO

    if (listener.eventQueue.isEmpty) {
      return FuseResponse(buf: BufReply(data: []));
    }

    final size = req.size.toInt();

    // Deliver whole events — never split an event across read() boundaries.
    final result = BytesBuilder(copy: false);
    var remaining = size;
    while (listener.eventQueue.isNotEmpty) {
      final next = listener.eventQueue.first;
      if (next.length > remaining && result.length > 0) {
        // Next event won't fit and we already have some — stop here.
        break;
      }
      if (next.length > size && result.isEmpty) {
        // Single event larger than read buffer — deliver it (caller must
        // handle; we never split events so we must deliver at least one).
        listener.eventQueue.removeFirst();
        result.add(next);
        break;
      }
      listener.eventQueue.removeFirst();
      result.add(next);
      remaining -= next.length;
    }

    return FuseResponse(buf: BufReply(data: result.takeBytes()));
  }

  FuseResponse _onWrite(WriteReq req, DriverContext ctx) {
    // P3 is read-only — write returns EACCES.
    return FuseResponse(err: 13); // EACCES
  }

  FuseResponse _onFlush(FlushReq req, DriverContext ctx) {
    return FuseResponse();
  }

  Future<FuseResponse> _onRelease(ReleaseReq req, DriverContext ctx) async {
    final fh = ctx.fh.toInt();
    _listeners.remove(fh);

    // Last listener left — deactivate.
    if (_listeners.isEmpty && ops.onDeactivate != null) {
      try {
        await ops.onDeactivate!();
      } catch (e, st) {
        _log.warning('onDeactivate error', e, st);
      }
    }

    return FuseResponse();
  }

  FuseResponse _onPoll(PollReq req, DriverContext ctx) {
    final fh = ctx.fh.toInt();
    final listener = _listeners[fh];
    if (listener == null) return FuseResponse(err: 5); // EIO

    var revents = 0;
    const pollin = 0x01;

    // POLLIN when event queue non-empty.
    if (listener.eventQueue.isNotEmpty) {
      revents |= pollin;
    }
    // POLLOUT not applicable for read-only device.

    return FuseResponse(poll: PollReply(revents: revents));
  }

  /// Stop serving and close all listeners.
  Future<void> close() async {
    _listeners.clear();
    await _driver.close();
  }
}
