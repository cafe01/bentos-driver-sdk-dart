/// Anthropic inference driver — `/dev/llm/anthropic/*`.
///
/// Translates between BentOS inference protocol and Anthropic Messages API
/// via `anthropic_sdk_dart`. Yields [InferenceChunk] stream from SSE events.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;

import 'configured_stream_driver.dart';
import 'driver_error.dart';
import 'inference_codec.dart';
import 'inference_types.dart';

/// Build [InferenceOps] for the Anthropic Messages API.
///
/// Returns a fully wired P4 ops struct. Plug into [ConfiguredStreamDriver]
/// with [InferenceConfigCodec] and serve.
///
/// ```dart
/// final ops = anthropicInferenceOps(
///   apiKey: 'sk-ant-...',
///   model: 'claude-sonnet-4-20250514',
/// );
/// final driver = ConfiguredStreamDriver(ops, configCodec: InferenceConfigCodec());
/// await driver.serve(Uri.parse('unix:///run/bentos/drivers/anthropic.sock'));
/// ```
InferenceOps anthropicInferenceOps({
  required String apiKey,
  required String model,
  String baseUrl = 'https://api.anthropic.com',
  anthropic.AnthropicClient? client,
}) {
  final cli = client ??
      anthropic.AnthropicClient(apiKey: apiKey, baseUrl: '$baseUrl/v1');

  return InferenceOps(
    defaultConfig: () => const InferenceConfig(),

    process: (messages, config, {required session}) =>
        _process(cli, model, messages, config, session),

    encodeOutput: inferenceEncodeOutput,
    decodeInput: inferenceDecodeInput,

    onSessionStart: () => InferenceSession(model: model),
    onSessionEnd: ({required session}) {},
    onDrain: ({required session}) {},

    onQuery: (cmd, {required session}) => _handleQuery(cmd, session, model),
  );
}

// ---------------------------------------------------------------------------
// process — core streaming operation
// ---------------------------------------------------------------------------

Stream<InferenceChunk> _process(
  anthropic.AnthropicClient client,
  String model,
  List<InferenceMessage> messages,
  InferenceConfig config,
  InferenceSession session,
) async* {
  final request = _buildRequest(model, messages, config);

  // Track tool call IDs by content block index.
  final toolCallIds = <int, String>{};

  String? responseModel;
  StopReason? stopReason;
  TokenUsage? usage;

  try {
    await for (final event in client.createMessageStream(request: request)) {
      switch (event) {
        case anthropic.MessageStartEvent(:final message):
          responseModel = message.model;
          final u = message.usage;
          if (u != null) {
            usage = TokenUsage(
              inputTokens: u.inputTokens,
              outputTokens: u.outputTokens,
              cacheReadTokens: u.cacheReadInputTokens,
              cacheWriteTokens: u.cacheCreationInputTokens,
            );
          }

        case anthropic.ContentBlockStartEvent(
            :final contentBlock,
            :final index,
          ):
          switch (contentBlock) {
            case anthropic.ToolUseBlock(:final id, :final name):
              toolCallIds[index] = id;
              yield ToolCallStart(id: id, name: name);
            case anthropic.RedactedThinkingBlock(:final data):
              yield RedactedThinkingDelta(data: data);
            default:
              break;
          }

        case anthropic.ContentBlockDeltaEvent(:final delta, :final index):
          switch (delta) {
            case anthropic.TextBlockDelta(:final text):
              yield TextDelta(text: text);
            case anthropic.InputJsonBlockDelta(:final partialJson):
              if (partialJson != null) {
                final id = toolCallIds[index] ?? '';
                yield ToolCallDelta(id: id, argumentsDelta: partialJson);
              }
            case anthropic.ThinkingBlockDelta(:final thinking):
              yield ThinkingDelta(text: thinking);
            default:
              break;
          }

        case anthropic.MessageDeltaEvent(
            :final delta,
            usage: final deltaUsage,
          ):
          stopReason = _mapStopReason(delta.stopReason);
          final outTokens = deltaUsage.outputTokens;
          usage = TokenUsage(
            inputTokens: usage?.inputTokens ?? 0,
            outputTokens: outTokens,
            cacheReadTokens: usage?.cacheReadTokens,
            cacheWriteTokens: usage?.cacheWriteTokens,
          );

        case anthropic.ContentBlockStopEvent():
        case anthropic.MessageStopEvent():
        case anthropic.PingEvent():
        case anthropic.ErrorEvent():
          break;
      }
    }
  } on anthropic.AnthropicClientException catch (e) {
    final err = _mapSdkError(e);
    session.lastError = err;
    throw DriverError.ioError('${err.kind.toJson()}: ${err.message}');
  }

  final meta = InferenceMetadata(
    model: responseModel ?? session.model,
    stopReason: stopReason ?? StopReason.endTurn,
    usage: usage,
  );
  session.lastMetadata = meta;
  yield CompleteChunk(metadata: meta);
}

// ---------------------------------------------------------------------------
// Request building
// ---------------------------------------------------------------------------

anthropic.CreateMessageRequest _buildRequest(
  String model,
  List<InferenceMessage> messages,
  InferenceConfig config,
) {
  // Extract system messages — Anthropic uses top-level system parameter.
  final systemParts = <String>[];
  final apiMessages = <anthropic.Message>[];

  for (final msg in messages) {
    if (msg.role == InferenceRole.system) {
      for (final c in msg.content) {
        if (c is TextContent) systemParts.add(c.text);
      }
      continue;
    }
    apiMessages.add(_toApiMessage(msg));
  }

  final systemText =
      config.system ?? (systemParts.isNotEmpty ? systemParts.join('\n\n') : null);

  // Tools.
  final tools = config.tools
      ?.map((t) => anthropic.Tool.custom(
            name: t.name,
            description: t.description,
            inputSchema: t.inputSchema,
          ))
      .toList();

  // Tool choice — use toJson() to inspect sealed type without private access.
  anthropic.ToolChoice? toolChoice;
  if (config.toolChoice != null) {
    final tc = config.toolChoice!.toJson();
    final type = tc['type'] as String;
    toolChoice = switch (type) {
      'auto' => const anthropic.ToolChoice(
        type: anthropic.ToolChoiceType.auto,
      ),
      'any' => const anthropic.ToolChoice(
        type: anthropic.ToolChoiceType.any,
      ),
      'tool' => anthropic.ToolChoice(
        type: anthropic.ToolChoiceType.tool,
        name: tc['name'] as String?,
      ),
      _ => null,
    };
  }

  return anthropic.CreateMessageRequest(
    model: anthropic.Model.modelId(model),
    messages: apiMessages,
    maxTokens: config.maxTokens ?? 4096,
    system: systemText != null
        ? anthropic.CreateMessageRequestSystem.text(systemText)
        : null,
    temperature: config.temperature,
    topP: config.topP,
    stopSequences: config.stop,
    tools: tools,
    toolChoice: toolChoice,
    stream: true,
  );
}

anthropic.Message _toApiMessage(InferenceMessage msg) {
  final role = switch (msg.role) {
    InferenceRole.user ||
    InferenceRole.functionResult => anthropic.MessageRole.user,
    InferenceRole.assistant => anthropic.MessageRole.assistant,
    InferenceRole.system => anthropic.MessageRole.user, // shouldn't reach
  };

  final blocks = <anthropic.Block>[];

  // Function result -> tool_result block.
  if (msg.role == InferenceRole.functionResult && msg.functionCallId != null) {
    final textParts =
        msg.content.whereType<TextContent>().map((c) => c.text).join();
    blocks.add(anthropic.Block.toolResult(
      toolUseId: msg.functionCallId!,
      content: anthropic.ToolResultBlockContent.text(textParts),
    ));
    return anthropic.Message(
      role: role,
      content: anthropic.MessageContent.blocks(blocks),
    );
  }

  for (final c in msg.content) {
    switch (c) {
      case TextContent(:final text):
        blocks.add(anthropic.Block.text(text: text));
      case ImageContent(:final mimeType, :final data, :final source):
        if (source == ImageSource.base64) {
          blocks.add(anthropic.Block.image(
            source: anthropic.ImageBlockSource.base64ImageSource(
              type: 'base64',
              mediaType: _parseMediaType(mimeType),
              data: data,
            ),
          ));
        }
      case ThinkingContent(:final text, :final signature):
        blocks.add(anthropic.Block.thinking(
          type: anthropic.ThinkingBlockType.thinking,
          thinking: text,
          signature: signature ?? '',
        ));
      case RedactedThinkingContent():
        break; // Can't serialize back.
    }
  }

  // Assistant function calls -> tool_use blocks.
  if (msg.functionCalls != null) {
    for (final fc in msg.functionCalls!) {
      blocks.add(anthropic.Block.toolUse(
        id: fc.id,
        name: fc.name,
        input: fc.arguments,
      ));
    }
  }

  if (blocks.isEmpty) {
    blocks.add(const anthropic.Block.text(text: ''));
  }

  return anthropic.Message(
    role: role,
    content: anthropic.MessageContent.blocks(blocks),
  );
}

anthropic.Base64ImageSourceMediaType _parseMediaType(String mime) =>
    switch (mime) {
      'image/jpeg' => anthropic.Base64ImageSourceMediaType.imageJpeg,
      'image/png' => anthropic.Base64ImageSourceMediaType.imagePng,
      'image/gif' => anthropic.Base64ImageSourceMediaType.imageGif,
      'image/webp' => anthropic.Base64ImageSourceMediaType.imageWebp,
      _ => anthropic.Base64ImageSourceMediaType.imageJpeg,
    };

// ---------------------------------------------------------------------------
// Stop reason mapping
// ---------------------------------------------------------------------------

StopReason? _mapStopReason(anthropic.StopReason? reason) {
  if (reason == null) return null;
  return switch (reason) {
    anthropic.StopReason.endTurn => StopReason.endTurn,
    anthropic.StopReason.maxTokens => StopReason.maxTokens,
    anthropic.StopReason.stopSequence => StopReason.stopSequence,
    anthropic.StopReason.toolUse => StopReason.toolUse,
    _ => StopReason.endTurn,
  };
}

// ---------------------------------------------------------------------------
// Error mapping
// ---------------------------------------------------------------------------

InferenceError _mapSdkError(anthropic.AnthropicClientException e) {
  String? providerCode;
  var message = e.message;

  final body = e.body;
  if (body is String) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final err = json['error'] as Map<String, dynamic>?;
      if (err != null) {
        providerCode = err['type'] as String?;
        message = err['message'] as String? ?? message;
      }
    } catch (_) {}
  }

  final kind = switch (e.code) {
    401 => InferenceErrorKind.authentication,
    403 => InferenceErrorKind.permission,
    429 => InferenceErrorKind.rateLimited,
    400 => InferenceErrorKind.invalidRequest,
    413 => InferenceErrorKind.contextExceeded,
    500 => InferenceErrorKind.serverError,
    529 => InferenceErrorKind.overloaded,
    502 || 503 || 504 => InferenceErrorKind.serverError,
    _ => InferenceErrorKind.unknown,
  };

  return InferenceError(
    kind: kind,
    message: message,
    providerCode: providerCode,
  );
}

// ---------------------------------------------------------------------------
// Query handler
// ---------------------------------------------------------------------------

Uint8List _handleQuery(int cmd, InferenceSession session, String model) =>
    switch (cmd) {
      LlmIoctl.getMetadata => _encJson(
        session.lastMetadata?.toJson() ?? <String, dynamic>{},
      ),
      LlmIoctl.getError => _encJson(
        session.lastError?.toJson() ?? <String, dynamic>{},
      ),
      LlmIoctl.getInfo => _encJson(
        InferenceCapabilities(
          model: model,
          provider: 'anthropic',
          maxContextTokens: 200000,
          maxOutputTokens: 128000,
          supportsThinking: true,
          supportsTools: true,
          supportsImages: true,
          supportsStreaming: true,
          supportedInputFormats: ['unstructured', 'structured'],
          supportedOutputFormats: ['unstructured', 'structured'],
          supportedStopReasons: [
            'end_turn', 'max_tokens', 'stop_sequence', 'tool_use',
          ],
        ).toJson(),
      ),
      _ => throw DriverError.invalidArgument(
        'Unknown query ioctl: 0x${cmd.toRadixString(16)}',
      ),
    };

Uint8List _encJson(Object value) =>
    Uint8List.fromList(utf8.encode(jsonEncode(value)));
