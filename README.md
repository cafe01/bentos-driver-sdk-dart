# BentOS Driver SDK for Dart

Build CUSE/FUSE character device drivers in pure Dart. No libfuse dependency.

The SDK speaks the BentOS wire protocol (length-prefixed protobuf over Unix domain sockets) and provides four I/O pattern frameworks so driver authors write **domain logic only** -- no FUSE vocabulary, no file handles, no protobuf.

## Architecture

Three layers, from raw to refined:

```
Layer 1: BentosDriver          raw FUSE ops over socket (framework authors)
Layer 2: Pattern Frameworks     per-pattern state machine (subsystem authors)
Layer 3: Ops Contracts          domain callbacks only (driver developers)
```

Most drivers target **Layer 3** -- you implement an ops contract and the pattern framework handles everything else: session management, buffering, state machines, poll readiness, error translation.

## Quick Start

```dart
import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';

// A read-only device that returns "Hello!"
final driver = BentosDriver(
  onRead: (req, ctx) => FuseResponse(
    buf: BufReply(data: utf8.encode('Hello!\n')),
  ),
);
await driver.serve(Uri.parse('unix:///run/bentos/drivers/hello.sock'));
```

That's L1 -- raw FUSE callbacks. For most drivers, use a pattern framework instead:

```dart
// P1: Echo device -- write bytes, read them back
final driver = StreamDriver<StreamController<Uint8List>>(StreamOps(
  onSessionStart: (flags) => StreamController<Uint8List>(),
  onData: (data, {required session}) {
    session!.add(Uint8List.fromList(data));
    return data.length;
  },
  outputStream: ({required session}) => session!.stream,
  onSessionEnd: ({required session}) => session!.close(),
));
await driver.serve(Uri.parse('unix:///tmp/echo.sock'));
```

No `FuseMessage`, no `fh`, no protobuf. Just domain logic.

## I/O Patterns

The SDK provides four pattern frameworks covering the BentOS device space. Each pattern defines a state machine, an ops contract, poll semantics, and error behavior.

### Pattern 1: Pure Stream (`StreamDriver` / `StreamOps`)

Bidirectional byte pipe. Read and write are independent, concurrent streams.

**Linux precedent**: Serial ports (`/dev/ttyS*`), PTY

| Callback | Required | Description |
|---|---|---|
| `onData` | yes | Bytes arrived from write(). Return bytes consumed. |
| `outputStream` | no | Pull-model output for read(). |
| `onSessionStart` | no | Allocate per-session state. |
| `onSessionEnd` | no | Clean up per-session state. |

**Example**: `/dev/echo` -- see [`example/echo_driver.dart`](example/echo_driver.dart)

```
Shell:
  exec 3<>/dev/echo
  echo hello >&3
  cat <&3              # prints "hello"
  exec 3>&-
```

### Pattern 2: Write-then-Read (`WriteReadDriver` / `WriteReadOps`)

Request/response with a 4-phase state machine. Write accumulates input, flush/read triggers processing, read delivers the response.

**Linux precedent**: Custom protocol devices, PPP

```
IDLE --write()--> ACCUMULATING --flush/read()--> PROCESSING --done--> RESPONSE_READY --read()--> IDLE
```

| Callback | Required | Description |
|---|---|---|
| `onRequest` | yes | Process complete request, return complete response. |
| `onSessionStart` | no | Allocate per-session state. |
| `onSessionEnd` | no | Clean up per-session state. |

One callback. The framework handles accumulation, state enforcement, and buffering.

POLLIN and POLLOUT are **mutually exclusive** -- the causal link between write and read manifests in poll readiness.

**Example**: `/dev/kv` -- see [`example/kv_driver.dart`](example/kv_driver.dart)

```
Shell:
  exec 3<>/dev/kv
  echo "name=bentos" >&3    # store
  echo "name" >&3           # query
  cat <&3                   # prints "bentos"
  exec 3>&-
```

### Pattern 3: Event Stream (`EventStreamDriver` / `EventStreamOps`)

Read-only event broadcast with first-open/last-close activation.

**Linux precedent**: Input subsystem (`/dev/input/event*`)

| Callback | Required | Description |
|---|---|---|
| `encodeEvent` | yes | Serialize one event to bytes. |
| `onActivate` | no | First listener opened -- start producing events. |
| `onDeactivate` | no | Last listener closed -- stop producing. |

Events are pushed via `driver.emit(event)` and broadcast to per-listener queues. write() returns EACCES. read() delivers whole events, never partial.

**Example**: `/dev/ticker` -- see [`example/ticker_driver.dart`](example/ticker_driver.dart)

```
Shell:
  cat /dev/ticker
  # tick 1
  # tick 2
  # tick 3
  # ^C
```

### Pattern 4: Configured Stream (`ConfiguredStreamDriver` / `ConfiguredStreamOps`)

Heavy upfront configuration via ioctl, then streaming output. 6-state machine.

**Linux precedent**: ALSA (`/dev/snd/pcm*`). **This is the pattern inference consumes.**

```
OPEN --ioctl/write()--> CONFIGURED --flush/read()--> PROCESSING --> STREAMING --> DRAINING --> COMPLETE
  ^                                                                                              |
  └──────────────────── RESET / new write() ─────────────────────────────────────────────────────┘
```

| Callback | Required | Description |
|---|---|---|
| `defaultConfig` | yes | Return default config for new sessions. |
| `process` | yes | Take input + config + session, return output stream. |
| `encodeOutput` | yes | Serialize one output chunk for read(). |
| `decodeInput` | yes | Deserialize write() bytes into domain input. |
| `onCancel` | no | Abort in-flight processing (called on DROP). |
| `onDrain` | no | Graceful completion hook. |
| `onSessionStart` | no | Allocate per-session state. |
| `onSessionEnd` | no | Release per-session state. |

Requires a `ConfigCodec<C>` that maps raw ioctl commands to typed config mutations. The driver never sees raw ioctl bytes.

**Framework ioctls** (type byte `0xBE`):
| Command | Description |
|---|---|
| `GET_STATE` | Query current state machine phase. |
| `DRAIN` | Acknowledge stream completion. |
| `DROP` | Cancel in-flight -> back to CONFIGURED. |
| `RESET` | Clear everything -> back to OPEN. |
| `GET_ERROR` | Query stream error (in COMPLETE state). |

**Example**: `/dev/synth` -- see [`example/synth_driver.dart`](example/synth_driver.dart)

```
Shell:
  exec 3<>/dev/synth
  echo "hello" >&3
  cat <&3              # prints "olleh" (reversed, streamed)
  exec 3>&-
```

## Layer 1: Raw Driver (`BentosDriver`)

For framework authors and diagnostic tools. Direct FUSE op callbacks with full control.

```dart
final driver = BentosDriver(
  onOpen:    (req, ctx) => ...,
  onRead:    (req, ctx) => ...,
  onWrite:   (req, ctx) => ...,
  onFlush:   (req, ctx) => ...,
  onRelease: (req, ctx) => ...,
  onFsync:   (req, ctx) => ...,
  onIoctl:   (req, ctx) => ...,
  onPoll:    (req, ctx) => ...,
);
```

Each callback receives the request-specific protobuf message and a `DriverContext` (file handle + connection). Return `FuseResponse`. Return null (by not setting a callback) to reply with ENOSYS.

**Example**: `/dev/playground` -- see [`example/playground_driver.dart`](example/playground_driver.dart). An instrumented workbench that logs every FUSE op with full arguments.

## Error Handling

Drivers throw `DriverError` subtypes from ops callbacks. The framework translates to POSIX errno:

| Error | errno | Value | When |
|---|---|---|---|
| `InvalidArgumentError` | EINVAL | 22 | Bad input, malformed data |
| `BusyError` | EBUSY | 16 | Resource in use |
| `NotFoundError` | ENOENT | 2 | Key/model not found |
| `NotPermittedError` | EPERM | 1 | Auth failure, quota exceeded |
| `ResourceExhaustedError` | ENOMEM | 12 | Token/memory limit |
| `TimedOutError` | ETIMEDOUT | 110 | Provider/inference timeout |
| `IoError` | EIO | 5 | Provider failure, network error |
| `NotSupportedError` | ENOSYS | 38 | Op not implemented |
| `AccessDeniedError` | EACCES | 13 | Write to read-only device |
| `WouldBlockError` | EAGAIN | 11 | No data ready |

```dart
// In an ops callback:
throw DriverError.notFound('key "$key" does not exist');
// Framework returns FuseResponse(err: 2) -- ENOENT
```

Unhandled exceptions are caught by the framework and returned as EIO (5).

## Choosing a Pattern

| You need... | Pattern | Framework |
|---|---|---|
| Bidirectional byte pipe | P1 | `StreamDriver` |
| Request in, response out | P2 | `WriteReadDriver` |
| Push events to readers | P3 | `EventStreamDriver` |
| Config phase + streaming output | P4 | `ConfiguredStreamDriver` |
| Full FUSE control / diagnostics | L1 | `BentosDriver` |

## Examples

| File | Device | Pattern | LOC |
|---|---|---|---|
| [`hello_driver.dart`](example/hello_driver.dart) | `/dev/hello` | L1 | ~30 |
| [`playground_driver.dart`](example/playground_driver.dart) | `/dev/playground` | L1 | ~120 |
| [`echo_driver.dart`](example/echo_driver.dart) | `/dev/echo` | P1 | ~15 |
| [`kv_driver.dart`](example/kv_driver.dart) | `/dev/kv` | P2 | ~20 |
| [`ticker_driver.dart`](example/ticker_driver.dart) | `/dev/ticker` | P3 | ~15 |
| [`synth_driver.dart`](example/synth_driver.dart) | `/dev/synth` | P4 | ~45 |

## Wire Protocol

Transport: length-prefixed protobuf over Unix domain socket (or TCP for testing).

```
[4 bytes: payload length, big-endian uint32][payload: FuseMessage protobuf]
```

Every message is a `FuseMessage` envelope with `id` (correlation), `fh` (session multiplexing), and a `FuseRequest` or `FuseResponse` payload. The protobuf schema is in `lib/src/generated/fuse_wire.pb.dart`.

Connection lifecycle:
1. Driver listens on a socket
2. `bentosd` connects when mounting the device
3. Requests processed sequentially per `fh`, concurrently across `fh` values
4. Every request gets exactly one response with the same `id`
