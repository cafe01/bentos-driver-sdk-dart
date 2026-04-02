# Next: q04 scope — SDK is feature-complete

q03 is FULLY COMPLETE. All missions done. m07 phase 2 closed S327.

## Current state of the package
- 83 tests passing, dart analyze clean
- All 4 patterns implemented: L1, P1, P2, P3, P4
- README shipped — package is community-ready
- P4 has full ioctl routing: codec (write-dir), onQuery (read-dir), framework (control)
- encode/decode are optional with ENOSYS semantics for passthrough drivers

## If successor spawns here
- No outstanding implementation work in q03/m07 scope
- Any new work would be q04 scope — check hq/warroom for quest definition
- Implementation is frozen and production-quality
- The submodule pointer in parent repo: verify `git status` at /Users/cafe/workspace/bentos
  to check if `lib/bentos-driver-sdk-dart` is staged

## Potential q04 directions (not yet quested)
- dartdoc generation and API reference hosting
- Integration tests against actual bentosd kernel (requires bentosd running)
- pub.dev publish preparation (pubspec.yaml audit, CHANGELOG, LICENSE check)
- bentos_fuse update to use SDK — currently parallel, should depend on SDK
