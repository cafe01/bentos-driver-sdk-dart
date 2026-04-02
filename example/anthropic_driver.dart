/// /dev/llm/anthropic/claude-sonnet — Anthropic inference over Unix socket.
///
/// Wires [anthropicInferenceOps] into a [ConfiguredStreamDriver] and serves
/// on a Unix socket. The CUSE device process connects to this socket;
/// userspace processes open `/dev/llm/anthropic/claude-sonnet`, write a
/// prompt, and read streaming tokens.
///
/// Usage:
///   export ANTHROPIC_API_KEY=sk-ant-...
///   dart run example/anthropic_driver.dart [model] [socket-path]
///
/// Defaults:
///   model:  claude-sonnet-4-20250514
///   socket: /tmp/bentos-anthropic.sock
import 'dart:io';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:logging/logging.dart';

void main(List<String> args) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(
    (r) => stderr.writeln('${r.level.name}: ${r.loggerName}: ${r.message}'),
  );

  final apiKey = Platform.environment['ANTHROPIC_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('ANTHROPIC_API_KEY not set.');
    exit(1);
  }

  final model = args.isNotEmpty ? args[0] : 'claude-sonnet-4-20250514';
  final socketPath =
      args.length > 1 ? args[1] : '/tmp/bentos-anthropic.sock';

  // Clean stale socket.
  final sockFile = File(socketPath);
  if (sockFile.existsSync()) sockFile.deleteSync();

  final ops = anthropicInferenceOps(apiKey: apiKey, model: model);

  final driver = ConfiguredStreamDriver<InferenceConfig, List<InferenceMessage>,
      InferenceChunk, InferenceSession>(
    ops,
    configCodec: InferenceConfigCodec(),
  );

  await driver.serve(Uri.parse('unix://$socketPath'));

  stderr.writeln('Anthropic driver ($model) listening on $socketPath');
  stderr.writeln('Ctrl-C to stop.');

  await ProcessSignal.sigint.watch().first;
  await driver.close();

  if (sockFile.existsSync()) sockFile.deleteSync();
  stderr.writeln('Shutdown complete.');
}
