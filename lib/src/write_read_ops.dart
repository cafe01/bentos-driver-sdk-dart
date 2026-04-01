/// Ops contract for Pattern 2: Write-then-Read (Request/Response).
///
/// Domain callbacks only — no FUSE vocabulary. The driver never sees
/// `FuseMessage`, `fh`, `OpenReq`, or any wire protocol types.
library;

import 'dart:async';
import 'dart:typed_data';

/// Callbacks for a write-then-read request/response device.
///
/// [S] is the per-session state type (opaque to the framework).
final class WriteReadOps<S> {
  const WriteReadOps({
    required this.onRequest,
    this.onSessionStart,
    this.onSessionEnd,
  });

  /// Process a complete request, return a complete response.
  ///
  /// Called when accumulated write data is submitted (via flush or read).
  /// The framework handles accumulation — [input] is the entire request.
  final Future<Uint8List> Function(Uint8List input, {required S session})
      onRequest;

  /// New session opened. Return per-session state.
  final FutureOr<S?> Function(int flags)? onSessionStart;

  /// Session ended. Clean up per-session state.
  final FutureOr<void> Function({required S session})? onSessionEnd;
}
