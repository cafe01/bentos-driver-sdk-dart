/// Ops contract for Pattern 4: Configured Stream.
///
/// Domain callbacks only — no FUSE vocabulary. The driver never sees
/// `FuseMessage`, `fh`, `OpenReq`, or any wire protocol types.
library;

import 'dart:async';
import 'dart:typed_data';

/// Callbacks for a configured streaming device.
///
/// [C] is the config type, [I] input domain type, [O] output chunk type,
/// [S] per-session state type.
final class ConfiguredStreamOps<C, I, O, S> {
  const ConfiguredStreamOps({
    required this.defaultConfig,
    required this.process,
    required this.encodeOutput,
    required this.decodeInput,
    this.onSessionStart,
    this.onSessionEnd,
    this.onCancel,
    this.onDrain,
  });

  /// Return default configuration for new sessions.
  final C Function() defaultConfig;

  /// THE core operation. Take input + config + session, return output stream.
  final Stream<O> Function(I input, C config, {required S session}) process;

  /// Serialize one output chunk for the read() path.
  final Uint8List Function(O chunk, {required C config}) encodeOutput;

  /// Deserialize accumulated write() bytes into domain input type.
  final I Function(Uint8List data, {required C config}) decodeInput;

  /// Allocate per-session domain state.
  final FutureOr<S> Function()? onSessionStart;

  /// Release per-session domain state.
  final FutureOr<void> Function({required S session})? onSessionEnd;

  /// Abort in-flight processing (called on DROP).
  final FutureOr<void> Function({required S session})? onCancel;

  /// Graceful completion hook (called when output stream ends).
  final FutureOr<void> Function({required S session})? onDrain;
}

/// Maps raw ioctl (cmd, data) to typed config mutations.
///
/// Defined per subsystem (e.g. InferenceConfigCodec), not per driver.
abstract class ConfigCodec<C> {
  /// Apply an ioctl command to [current] config, returning the new config.
  C apply(C current, int command, Uint8List data);

  /// Encode config for query responses.
  Uint8List encode(C config, int command);
}
