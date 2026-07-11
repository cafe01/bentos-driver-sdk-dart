/// Sealed error hierarchy for driver callbacks.
///
/// Drivers throw [DriverError] subtypes from ops callbacks. The framework
/// catches them and translates to the appropriate POSIX errno in the
/// [FuseResponse].
library;

/// Base class for all driver errors. Maps to a POSIX errno.
sealed class DriverError implements Exception {
  const DriverError(this.message);

  final String message;

  /// The POSIX errno value for this error.
  int get errno;

  @override
  String toString() => '$runtimeType($errno): $message';

  /// Convenience factory constructors.
  factory DriverError.invalidArgument(String msg) =
      InvalidArgumentError._;
  factory DriverError.busy(String msg) = BusyError._;
  factory DriverError.notFound(String msg) = NotFoundError._;
  factory DriverError.notPermitted(String msg) = NotPermittedError._;
  factory DriverError.resourceExhausted(String msg) =
      ResourceExhaustedError._;
  factory DriverError.timedOut(String msg) = TimedOutError._;
  factory DriverError.ioError(String msg) = IoError._;
  factory DriverError.notSupported(String msg) = NotSupportedError._;
  factory DriverError.accessDenied(String msg) = AccessDeniedError._;
  factory DriverError.wouldBlock(String msg) = WouldBlockError._;
  factory DriverError.brokenPipe(String msg) = BrokenPipeError._;
  factory DriverError.notTty(String msg) = NotTtyError._;
}

/// EINVAL (22) — bad input, malformed data, unknown config command.
final class InvalidArgumentError extends DriverError {
  const InvalidArgumentError._(super.message);
  @override
  int get errno => 22;
}

/// EBUSY (16) — resource in use, write during PROCESSING.
final class BusyError extends DriverError {
  const BusyError._(super.message);
  @override
  int get errno => 16;
}

/// ENOENT (2) — key not found, model not available.
final class NotFoundError extends DriverError {
  const NotFoundError._(super.message);
  @override
  int get errno => 2;
}

/// EPERM (1) — auth failure, quota exceeded.
final class NotPermittedError extends DriverError {
  const NotPermittedError._(super.message);
  @override
  int get errno => 1;
}

/// ENOMEM (12) — token limit, memory limit.
final class ResourceExhaustedError extends DriverError {
  const ResourceExhaustedError._(super.message);
  @override
  int get errno => 12;
}

/// ETIMEDOUT (110) — provider timeout, inference timeout.
final class TimedOutError extends DriverError {
  const TimedOutError._(super.message);
  @override
  int get errno => 110;
}

/// EIO (5) — provider failure, network error, unhandled error.
final class IoError extends DriverError {
  const IoError._(super.message);
  @override
  int get errno => 5;
}

/// ENOSYS (38) — operation not implemented.
final class NotSupportedError extends DriverError {
  const NotSupportedError._(super.message);
  @override
  int get errno => 38;
}

/// EACCES (13) — write to read-only device (P3).
final class AccessDeniedError extends DriverError {
  const AccessDeniedError._(super.message);
  @override
  int get errno => 13;
}

/// EAGAIN (11) — non-blocking read when no data ready.
final class WouldBlockError extends DriverError {
  const WouldBlockError._(super.message);
  @override
  int get errno => 11;
}

/// EPIPE (32) — write after the input direction closed (`*_INPUT_END`).
final class BrokenPipeError extends DriverError {
  const BrokenPipeError._(super.message);
  @override
  int get errno => 32;
}

/// ENOTTY (25) — an ioctl the device class doesn't carry.
final class NotTtyError extends DriverError {
  const NotTtyError._(super.message);
  @override
  int get errno => 25;
}
