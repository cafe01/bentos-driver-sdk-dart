## 0.1.0

- Initial release.
- `BentosDriver` — raw FUSE op callbacks over the BentOS wire protocol (length-prefixed protobuf over Unix domain sockets).
- Four I/O pattern frameworks: `StreamDriver` (P1), `WriteReadDriver` (P2), `EventStreamDriver` (P3), `ConfiguredStreamDriver` (P4).
- `DriverError` hierarchy mapped to POSIX errno.
