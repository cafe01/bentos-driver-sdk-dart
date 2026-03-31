/// Hello driver — returns a greeting on read. Companion to hello_cuse.dart.
///
/// Usage:
///   dart run example/hello_driver.dart
import 'dart:convert';
import 'dart:io';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (r) => print('${r.level.name}: ${r.loggerName}: ${r.message}'),
  );

  final socketPath = '/tmp/bentos-hello.sock';
  final greeting = utf8.encode('Hello from BentOS!\n');

  // Track which file handles have already been read.
  // Character devices always send offset=0, so we use per-fh state
  // to return the greeting once, then EOF on subsequent reads.
  final read = <int>{};

  final driver = BentosDriver(
    onRead: (req, ctx) {
      if (!read.add(ctx.fh.toInt())) {
        return FuseResponse(buf: BufReply(data: [])); // EOF
      }
      final size = req.size.toInt();
      final end = size.clamp(0, greeting.length);
      return FuseResponse(buf: BufReply(data: greeting.sublist(0, end)));
    },
    onRelease: (req, ctx) {
      read.remove(ctx.fh.toInt());
      return FuseResponse();
    },
  );

  await driver.serve(Uri.parse('unix://$socketPath'));

  print('Hello driver listening on $socketPath');
  print('Ctrl-C to stop.');

  await ProcessSignal.sigint.watch().first;
  await driver.close();

  final f = File(socketPath);
  if (f.existsSync()) f.deleteSync();
  print('Shutdown complete.');
}
