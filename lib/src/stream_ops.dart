/// Ops contract for Pattern 1: Pure Stream.
///
/// Domain callbacks only — no FUSE vocabulary. The driver never sees
/// `FuseMessage`, `fh`, `OpenReq`, or any wire protocol types.
library;

import 'dart:async';
import 'dart:typed_data';

/// Callbacks for a pure bidirectional byte stream device.
///
/// [S] is the per-session state type (opaque to the framework).
final class StreamOps<S> {
  const StreamOps({
    required this.onData,
    this.outputStream,
    this.onSessionStart,
    this.onSessionEnd,
  });

  /// Bytes arrived from write(). Return bytes consumed.
  ///
  /// Called when the application writes to the device fd.
  final FutureOr<int> Function(Uint8List data, {required S? session}) onData;

  /// Pull-model output for read(). Return null if no read side.
  ///
  /// The framework reads from this stream to satisfy application read() calls.
  /// Each chunk emitted becomes available for the next read().
  final Stream<Uint8List> Function({required S? session})? outputStream;

  /// New session opened. Return per-session state.
  ///
  /// Called when a new fd is opened on the device. NOT `open` — domain
  /// lifecycle only.
  final FutureOr<S?> Function(int flags)? onSessionStart;

  /// Session ended. Clean up per-session state.
  ///
  /// Called when the last reference to the fd is closed. NOT `release`.
  final FutureOr<void> Function({required S? session})? onSessionEnd;
}
