/// /dev/synth — text transformation device. Reverses text, streamed char by char.
///
/// The P4 showcase: configure via ioctl (uppercase, delay), write text,
/// read reversed output streamed one character at a time.
///
/// Shell demo:
///   exec 3<>/dev/synth
///   echo "hello" >&3
///   cat <&3
///   # Output: o l l e h (streamed, one char per 100ms)
///   exec 3>&-
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:logging/logging.dart';

/// Subsystem config — defined by subsystem author.
final class SynthConfig {
  final bool uppercase;
  final int delayMs;
  const SynthConfig({this.uppercase = false, this.delayMs = 100});
  SynthConfig copyWith({bool? uppercase, int? delayMs}) =>
      SynthConfig(
          uppercase: uppercase ?? this.uppercase,
          delayMs: delayMs ?? this.delayMs);
}

/// Config codec — maps ioctl commands to config mutations.
final class SynthConfigCodec extends ConfigCodec<SynthConfig> {
  static const setUppercase = 0x01;
  static const setDelay = 0x02;

  @override
  SynthConfig apply(SynthConfig current, int command, Uint8List data) {
    return switch (command) {
      setUppercase => current.copyWith(uppercase: data[0] != 0),
      setDelay => current.copyWith(
          delayMs: ByteData.sublistView(data).getInt32(0, Endian.little)),
      _ => throw DriverError.invalidArgument('Unknown config $command'),
    };
  }

  @override
  Uint8List encode(SynthConfig config, int command) => Uint8List(0);
}

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (r) => print('${r.level.name}: ${r.loggerName}: ${r.message}'),
  );

  final socketPath = '/tmp/bentos-synth.sock';

  final driver = ConfiguredStreamDriver<SynthConfig, String, String, Object>(
    ConfiguredStreamOps(
      defaultConfig: SynthConfig.new,
      process: (input, config, {required session}) async* {
        final text = config.uppercase ? input.toUpperCase() : input;
        for (final char in text.trim().split('').reversed) {
          await Future<void>.delayed(Duration(milliseconds: config.delayMs));
          yield char;
        }
      },
      encodeOutput: (chunk, {required config}) =>
          Uint8List.fromList(utf8.encode(chunk)),
      decodeInput: (records, {required config}) =>
          utf8.decode(records.expand((r) => r).toList()),
      onSessionStart: Object.new,
    ),
    configCodec: SynthConfigCodec(),
  );

  await driver.serve(Uri.parse('unix://$socketPath'));

  print('Synth driver listening on $socketPath');
  print('Ctrl-C to stop.');

  await ProcessSignal.sigint.watch().first;
  await driver.close();

  final f = File(socketPath);
  if (f.existsSync()) f.deleteSync();
  print('Shutdown complete.');
}
