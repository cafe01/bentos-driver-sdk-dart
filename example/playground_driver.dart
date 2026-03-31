/// Playground driver — logs every CUSE op to stdout with full arguments.
///
/// An instrumented workbench for observing what the kernel sends for each
/// userspace syscall on `/dev/playground`. Every op is logged as it arrives,
/// then handled with configurable behavior.
///
/// Usage:
///   1. Start driver:  dart run example/playground_driver.dart
///   2. Start device:  sudo dart run example/playground_cuse.dart
///   3. Exercise:      cat, echo, dd, custom programs against /dev/playground
///   4. Watch stdout:  every CUSE op appears with args and timing
///
/// Default behaviors:
///   - open:    accepts, logs flags
///   - read:    returns per-fh write buffer (or empty for EOF)
///   - write:   stores data per-fh, echoes byte count
///   - flush:   logs (called on every close(fd))
///   - release: logs (called when last fd ref closes), clears fh state
///   - fsync:   logs datasync flag
///   - ioctl:   logs cmd + flags, returns ENOTTY
///   - poll:    logs events, returns 0 (nothing ready)
import 'dart:convert';
import 'dart:io';
import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:fixnum/fixnum.dart' as fixnum;

/// Per-file-handle state.
final class FhState {
  final List<int> buf = [];
  bool hasBeenRead = false;
  int openFlags = 0;
  final openedAt = DateTime.now();
  int readCount = 0;
  int writeCount = 0;
  int flushCount = 0;
}

final _fhState = <int, FhState>{};
var _opSeq = 0;
final _startTime = DateTime.now();

String _ts() {
  final elapsed = DateTime.now().difference(_startTime);
  final ms = elapsed.inMilliseconds;
  return '+${(ms / 1000).toStringAsFixed(3)}s';
}

String _hex(int v) => '0x${v.toRadixString(16)}';

String _openFlags(int flags) {
  final parts = <String>[];
  final access = flags & 0x3;
  switch (access) {
    case 0:
      parts.add('O_RDONLY');
    case 1:
      parts.add('O_WRONLY');
    case 2:
      parts.add('O_RDWR');
  }
  if (flags & 0x100 != 0) parts.add('O_CREAT');
  if (flags & 0x200 != 0) parts.add('O_EXCL');
  if (flags & 0x400 != 0) parts.add('O_NOCTTY');
  if (flags & 0x800 != 0) parts.add('O_TRUNC');
  if (flags & 0x2000 != 0) parts.add('O_APPEND');
  if (flags & 0x4000 != 0) parts.add('O_NONBLOCK');
  if (flags & 0x10000 != 0) parts.add('O_DSYNC');
  if (flags & 0x100000 != 0) parts.add('O_DIRECTORY');
  if (flags & 0x200000 != 0) parts.add('O_NOFOLLOW');
  if (flags & 0x2000000 != 0) parts.add('O_CLOEXEC');
  final extra = flags & ~0x2314F03;
  if (extra != 0) parts.add(_hex(extra));
  return parts.join('|');
}

String _printable(List<int> data, {int maxLen = 64}) {
  if (data.isEmpty) return '<empty>';
  final preview = data.length > maxLen ? data.sublist(0, maxLen) : data;
  // Try UTF-8 decode; fall back to hex.
  try {
    final s = utf8.decode(preview, allowMalformed: false);
    final escaped = s
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    final suffix = data.length > maxLen ? '...(${data.length}B)' : '';
    return '"$escaped"$suffix';
  } catch (_) {
    final hex = preview.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    final suffix = data.length > maxLen ? '...(${data.length}B)' : '';
    return '[$hex]$suffix';
  }
}

void _log(String op, int fh, String detail) {
  final seq = _opSeq++;
  print('[${_ts()}] #$seq $op fh=$fh $detail');
}

void main() async {
  final socketPath = '/tmp/bentos-playground.sock';

  final driver = BentosDriver(
    onOpen: (req, ctx) {
      final state = FhState()..openFlags = req.flags;
      _fhState[ctx.fh.toInt()] = state;
      _log('OPEN', ctx.fh.toInt(), 'flags=${_openFlags(req.flags)} (${_hex(req.flags)})');
      return FuseResponse(open: OpenReply());
    },

    onRead: (req, ctx) {
      final fhInt = ctx.fh.toInt();
      final state = _fhState[fhInt];
      final size = req.size.toInt();
      final offset = req.offset.toInt();

      if (state == null) {
        _log('READ', fhInt, 'size=$size offset=$offset -> ERROR: no fh state');
        return FuseResponse(err: 5); // EIO
      }

      state.readCount++;

      // Return buffered data once, then EOF.
      if (state.hasBeenRead || state.buf.isEmpty) {
        _log('READ', fhInt, 'size=$size offset=$offset -> EOF (read #${state.readCount})');
        return FuseResponse(buf: BufReply(data: []));
      }

      state.hasBeenRead = true;
      final end = size.clamp(0, state.buf.length);
      final data = state.buf.sublist(0, end);
      _log('READ', fhInt,
          'size=$size offset=$offset -> ${data.length}B ${_printable(data)} (read #${state.readCount})');
      return FuseResponse(buf: BufReply(data: data));
    },

    onWrite: (req, ctx) {
      final fhInt = ctx.fh.toInt();
      final state = _fhState[fhInt];
      final data = req.data;
      final offset = req.offset.toInt();

      if (state == null) {
        _log('WRITE', fhInt,
            '${data.length}B offset=$offset -> ERROR: no fh state');
        return FuseResponse(err: 5); // EIO
      }

      state.writeCount++;
      state.buf
        ..clear()
        ..addAll(data);
      state.hasBeenRead = false;

      _log('WRITE', fhInt,
          '${data.length}B offset=$offset ${_printable(data)} (write #${state.writeCount})');
      return FuseResponse(
        write: WriteReply(count: fixnum.Int64(data.length)),
      );
    },

    onFlush: (req, ctx) {
      final fhInt = ctx.fh.toInt();
      final state = _fhState[fhInt];
      if (state != null) state.flushCount++;
      _log('FLUSH', fhInt,
          'lock_owner=${req.lockOwner} (flush #${state?.flushCount ?? "?"})');
      return FuseResponse();
    },

    onRelease: (req, ctx) {
      final fhInt = ctx.fh.toInt();
      final state = _fhState.remove(fhInt);
      final lifetime = state != null
          ? DateTime.now().difference(state.openedAt).inMilliseconds
          : -1;
      _log('RELEASE', fhInt,
          'flags=${_openFlags(req.flags)} (${_hex(req.flags)}) '
          'reads=${state?.readCount ?? "?"} writes=${state?.writeCount ?? "?"} '
          'flushes=${state?.flushCount ?? "?"} lifetime=${lifetime}ms');
      return FuseResponse();
    },

    onFsync: (req, ctx) {
      _log('FSYNC', ctx.fh.toInt(),
          'datasync=${req.datasync}');
      return FuseResponse();
    },

    onIoctl: (req, ctx) {
      _log('IOCTL', ctx.fh.toInt(),
          'cmd=${_hex(req.cmd)} flags=${_hex(req.flags)} '
          'in=${req.inBuf.length}B out_max=${req.outBufsz}');
      return FuseResponse(err: 25); // ENOTTY — not a typewriter
    },

    onPoll: (req, ctx) {
      _log('POLL', ctx.fh.toInt(), 'events=${_hex(req.events)} kh=${req.kh}');
      return FuseResponse(poll: PollReply(revents: 0));
    },
  );

  await driver.serve(Uri.parse('unix://$socketPath'));

  print('=== BentOS Playground Driver ===');
  print('Socket: $socketPath');
  print('Waiting for CUSE device process...');
  print('');
  print('Once running, exercise with:');
  print('  sudo cat /dev/playground              # open + read + flush + release');
  print('  echo hi | sudo tee /dev/playground    # open + write + flush + release');
  print('  sudo dd if=/dev/zero of=/dev/playground bs=4k count=1');
  print('  sudo python3 -c "f=open(\'/dev/playground\',\'w\'); f.write(\'hello\'); f.flush(); f.close()"');
  print('');

  await ProcessSignal.sigint.watch().first;
  await driver.close();

  final f = File(socketPath);
  if (f.existsSync()) f.deleteSync();
  print('\nShutdown complete. Total ops: $_opSeq');
}
