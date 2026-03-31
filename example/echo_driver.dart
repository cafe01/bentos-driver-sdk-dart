/// /dev/echo — bidirectional byte pipe. Write bytes, read them back.
///
/// The simplest possible StreamDriver: write pushes to a buffer,
/// read pulls from it. ~15 LOC of driver logic.
///
/// Shell demo:
///   exec 3<>/dev/echo
///   echo hello >&3
///   cat <&3
///   exec 3>&-
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (r) => print('${r.level.name}: ${r.loggerName}: ${r.message}'),
  );

  final socketPath = '/tmp/bentos-echo.sock';

  final driver = StreamDriver<StreamController<Uint8List>>(StreamOps(
    onSessionStart: (flags) => StreamController<Uint8List>(),
    onData: (data, {required session}) {
      session!.add(Uint8List.fromList(data));
      return data.length;
    },
    outputStream: ({required session}) => session!.stream,
    onSessionEnd: ({required session}) => session!.close(),
  ));

  await driver.serve(Uri.parse('unix://$socketPath'));

  print('Echo driver listening on $socketPath');
  print('Ctrl-C to stop.');

  await ProcessSignal.sigint.watch().first;
  await driver.close();

  final f = File(socketPath);
  if (f.existsSync()) f.deleteSync();
  print('Shutdown complete.');
}
