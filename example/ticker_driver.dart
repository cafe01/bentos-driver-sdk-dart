/// /dev/ticker — periodic event emitter. Emits a counter every second.
///
/// The simplest possible EventStreamDriver: activates a timer when the
/// first listener opens, deactivates when the last closes. ~10 LOC of
/// driver logic.
///
/// Shell demo:
///   cat /dev/ticker
///   # Ctrl-C to stop
import 'dart:async';
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

  final socketPath = '/tmp/bentos-ticker.sock';

  var counter = 0;
  Timer? timer;

  late final EventStreamDriver<int> driver;
  driver = EventStreamDriver<int>(EventStreamOps(
    encodeEvent: (n) => Uint8List.fromList(utf8.encode('tick $n\n')),
    onActivate: () {
      counter = 0;
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        driver.emit(++counter);
      });
    },
    onDeactivate: () {
      timer?.cancel();
      timer = null;
    },
  ));

  await driver.serve(Uri.parse('unix://$socketPath'));

  print('Ticker driver listening on $socketPath');
  print('Ctrl-C to stop.');

  await ProcessSignal.sigint.watch().first;
  timer?.cancel();
  await driver.close();

  final f = File(socketPath);
  if (f.existsSync()) f.deleteSync();
  print('Shutdown complete.');
}
