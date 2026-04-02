# S327 — P4 gaps delivered

## What happened
Three P4 (ConfiguredStreamOps) gaps closed in a single session — m07 phase 2 complete.

### Gap 1: onQuery callback
- `ConfiguredStreamOps.onQuery`: optional `Future<Uint8List> Function(int cmd, ConfiguredStreamSession<S> session)?`
- Provides a read-direction ioctl escape hatch distinct from the write-direction config codec
- Fallthrough logic: codec handles config ioctls, onQuery handles query ioctls (GET_METADATA etc.), unknown = EINVAL
- Available in all states including STREAMING — important for in-flight progress queries
- 3 new tests: routing, STREAMING availability, EINVAL-without-handler

### Gap 2: Optional encode/decode
- `ConfiguredStreamOps.encodeOutput` and `decodeInput` made nullable
- Null `decodeInput` on flush -> ENOSYS (not a crash) — subsystem layer can intercept
- Null `encodeOutput` on read -> ENOSYS — same pattern
- Design: makes the ops type usable for byte-passthrough drivers without dummy codecs
- 4 new tests covering null encode, null decode, ENOSYS semantics, and full provided path

### Gap 3: Multi-turn write semantics doc
- Added doc comment to `decodeInput` clarifying per-cycle buffer scope
- Each call to `decodeInput` receives only the bytes written in that single write(2) call
- Clarifies that multi-turn accumulation is the ops layer's job (via session state), not the framework
- No code change — pure documentation

## Session commits
- `764f133` feat(driver-sdk): P4 gaps — onQuery, optional codecs, multi-turn docs
- `3fad6fa` chore(sdk): update incremental kernel cache
- `c839770` docs(driver-sdk): README (previous session, already in state)

## Final state
- 83 tests passing (was 76 at end of q03, +7 this session)
- dart analyze: 0 warnings, 0 errors
- m07 phase 2: COMPLETE
- Package is feature-complete for q03 + q04 scope

## Design insight: ioctl routing layer
The P4 ioctl routing has a clean two-axis separation:
- Write-direction ioctls (configure the job): handled by ConfigCodec (subsystem-defined)
- Read-direction ioctls (query job state): handled by onQuery (subsystem-defined)
- Framework ioctls (DROP=0xBE00, RESET=0xBE01, GET_ERROR=0xBE02): handled by framework
- Unknown after all three: EINVAL

This separation means subsystem authors never see framework plumbing — they implement
ConfigCodec for configuration and onQuery for queries. Clean ownership.
