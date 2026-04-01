/// /dev/kv — key-value store. Write "key=value" to store, write "key" to read.
///
/// The simplest possible WriteReadDriver: write accumulates a request,
/// flush/read submits it to onRequest which returns the response.
///
/// Shell demo:
///   exec 3<>/dev/kv
///   echo "name=bentos" >&3
///   echo "name" >&3
///   cat <&3
///   exec 3>&-
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (r) => print('${r.level.name}: ${r.loggerName}: ${r.message}'),
  );

  final socketPath = '/tmp/bentos-kv.sock';
  final store = <String, String>{};

  final driver = WriteReadDriver<Object>(WriteReadOps(
    onSessionStart: (flags) => Object(),
    onRequest: (input, {required session}) async {
      final text = utf8.decode(input).trim();
      if (text.contains('=')) {
        final parts = text.split('=');
        store[parts[0]] = parts.sublist(1).join('=');
        return Uint8List.fromList(utf8.encode('OK\n'));
      } else {
        return Uint8List.fromList(utf8.encode('${store[text] ?? "(not found)"}\n'));
      }
    },
  ));

  await driver.serve(Uri.parse('unix://$socketPath'));

  print('KV driver listening on $socketPath');
  print('Ctrl-C to stop.');

  await ProcessSignal.sigint.watch().first;
  await driver.close();

  final f = File(socketPath);
  if (f.existsSync()) f.deleteSync();
  print('Shutdown complete.');
}
