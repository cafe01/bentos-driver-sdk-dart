# SDK Architecture Decisions

## Package split
- SDK owns: BentosDriver, DriverConnection, DriverContext, DriverError, protobuf generated types, length_prefixed, socket_sink, StreamDriver, StreamOps, WriteReadDriver, WriteReadOps, EventStreamDriver, EventStreamOps, ConfiguredStreamDriver, ConfiguredStreamOps, ConfigCodec
- bentos_fuse keeps: BentosFuse, BentosSession, CUSE device creation, fuse_session_loop FFI, libfuse3 bindings
- bentos_fuse depends on SDK and re-exports driver types via thin wrappers

## P4 ioctl routing (two-axis separation)
- Write-direction ioctls (configure): handled by ConfigCodec (subsystem-defined)
- Read-direction ioctls (query): handled by onQuery callback (subsystem-defined, optional)
- Framework ioctls: DROP=0xBE00, RESET=0xBE01, GET_ERROR=0xBE02 (always handled by framework)
- Unknown after all three: EINVAL
- encodeOutput/decodeInput are nullable — null = ENOSYS, enables byte-passthrough drivers

## Key design choices
- DriverContext is minimal (fh + connection) — extensible for poll routing later
- StreamDriver uses Queue<Uint8List> for output buffering (not List) — efficient addFirst/removeFirst for partial chunk handling
- Empty read on chardev returns empty BufReply (EOF semantics)
- DriverError caught in _dispatchOp -> errno in FuseResponse; unhandled exceptions caught in DriverConnection._listen -> EIO
- cafe01 org for GitHub (bentos-sh doesn't exist)
- EventStreamDriver: per-listener queues (not shared buffer) — each listener gets independent event queue
- EventStreamDriver: drop-oldest overflow (configurable maxEventsPerListener)
- ConfiguredStreamDriver: ioctl cmd encoding uses bits 15-8 for type byte, 7-0 for number. 0xBE reserved for framework.
- ConfiguredStreamDriver: ConfigCodec is abstract class, not function — subsystem author's job
- ConfiguredStreamDriver: stream errors captured and queryable via GET_ERROR ioctl in COMPLETE state

## Pattern summary
| Pattern | Ops type | Framework | Example | Tests |
|---------|----------|-----------|---------|-------|
| L1 | BentosDriver (raw) | — | /dev/hello, /dev/playground | 13 |
| P1 | StreamOps<S> | StreamDriver<S> | /dev/echo | 11 |
| P2 | WriteReadOps<S> | WriteReadDriver<S> | /dev/kv | 15 |
| P3 | EventStreamOps<E> | EventStreamDriver<E> | /dev/ticker | 17 |
| P4 | ConfiguredStreamOps<C,I,O,S> | ConfiguredStreamDriver<C,I,O,S> | /dev/synth | 20 |

## File layout
```
lib/bentos-driver-sdk-dart/
  lib/
    bentos_driver_sdk.dart          # barrel
    src/
      driver.dart                   # BentosDriver + DriverConnection (L1)
      driver_channel.dart           # connectDriver utility
      driver_context.dart           # DriverContext
      driver_error.dart             # DriverError sealed hierarchy
      stream_driver.dart            # StreamDriver<S> (P1)
      stream_ops.dart               # StreamOps<S> (P1 ops)
      write_read_driver.dart        # WriteReadDriver<S> (P2)
      write_read_ops.dart           # WriteReadOps<S> (P2 ops)
      event_stream_driver.dart      # EventStreamDriver<E> (P3)
      event_stream_ops.dart         # EventStreamOps<E> (P3 ops)
      configured_stream_driver.dart # ConfiguredStreamDriver<C,I,O,S> (P4)
      configured_stream_ops.dart    # ConfiguredStreamOps<C,I,O,S> + ConfigCodec<C> (P4)
      length_prefixed.dart          # wire framing
      socket_sink.dart              # Socket adapter
      generated/
        fuse_wire.pb.dart           # protobuf (canonical copy)
        fuse_wire.pbenum.dart
        fuse_wire.pbjson.dart
  example/
    echo_driver.dart                # /dev/echo (P1)
    hello_driver.dart               # /dev/hello (L1)
    kv_driver.dart                  # /dev/kv (P2)
    playground_driver.dart          # /dev/playground (L1)
    ticker_driver.dart              # /dev/ticker (P3)
    synth_driver.dart               # /dev/synth (P4)
  test/
    driver_test.dart                # 8 L1 tests
    driver_error_test.dart          # 5 error tests
    stream_driver_test.dart         # 11 P1 tests
    write_read_driver_test.dart     # 15 P2 tests
    event_stream_driver_test.dart   # 17 P3 tests
    configured_stream_driver_test.dart # 20 P4 tests
```
