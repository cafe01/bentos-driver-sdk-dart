/// Per-request context passed to driver callbacks.
///
/// Replaces the bare `Int64 fh` parameter. Holds the file handle and
/// a reference to the connection, enabling future poll routing.
library;

import 'package:fixnum/fixnum.dart' as fixnum;

import 'driver.dart';

/// Context for a single FUSE op invocation.
///
/// Every callback receives a [DriverContext] instead of a raw file handle.
/// This provides a stable extension point for poll notification, connection
/// metadata, and per-session state routing without breaking existing
/// callback signatures.
final class DriverContext {
  const DriverContext({required this.fh, required this.connection});

  /// The FUSE file handle identifying the open fd.
  final fixnum.Int64 fh;

  /// The connection this request arrived on.
  final DriverConnection connection;
}
