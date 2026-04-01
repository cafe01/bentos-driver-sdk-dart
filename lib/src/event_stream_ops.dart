/// Ops contract for Pattern 3: Event Stream (Read-Only).
///
/// Domain callbacks only — no FUSE vocabulary. The driver never sees
/// `FuseMessage`, `fh`, `OpenReq`, or any wire protocol types.
library;

import 'dart:async';
import 'dart:typed_data';

/// Callbacks for a read-only event stream device.
///
/// [E] is the event type emitted by the driver.
final class EventStreamOps<E> {
  const EventStreamOps({
    required this.encodeEvent,
    this.onActivate,
    this.onDeactivate,
  });

  /// Serialize one event to wire format.
  final Uint8List Function(E event) encodeEvent;

  /// First listener opened the device — start producing events.
  final FutureOr<void> Function()? onActivate;

  /// Last listener closed — stop producing events.
  final FutureOr<void> Function()? onDeactivate;
}
