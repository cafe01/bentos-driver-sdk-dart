/// Inference subsystem types — `/dev/llm/*` data model.
///
/// Canonical definitions per the R4 spec. Format/encoding/mode tripartite
/// distinction: format = logical structure, encoding = wire bytes,
/// mode = protocol behavior.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'configured_stream_ops.dart';
import 'driver_error.dart';

// ---------------------------------------------------------------------------
// Format
// ---------------------------------------------------------------------------

/// Logical structure of an I/O channel.
enum InferenceFormat {
  /// Raw UTF-8 bytes — shell, pipes, `cat`.
  unstructured(0),

  /// Typed messages — programmatic clients, multi-turn.
  structured(1);

  const InferenceFormat(this.code);
  final int code;

  static InferenceFormat fromCode(int code) => switch (code) {
    0 => unstructured,
    1 => structured,
    _ => throw DriverError.invalidArgument('Unknown format code: $code'),
  };
}

// ---------------------------------------------------------------------------
// InferenceRole
// ---------------------------------------------------------------------------

enum InferenceRole {
  system,
  user,
  assistant,
  functionResult;

  static InferenceRole fromJson(String value) => switch (value) {
    'system' => system,
    'user' => user,
    'assistant' => assistant,
    'function_result' => functionResult,
    _ => throw FormatException('Unknown role: $value'),
  };

  String toJson() => switch (this) {
    system => 'system',
    user => 'user',
    assistant => 'assistant',
    functionResult => 'function_result',
  };
}

// ---------------------------------------------------------------------------
// InferenceContent — sealed by MIME type
// ---------------------------------------------------------------------------

sealed class InferenceContent {
  const InferenceContent();

  String get mimeType;

  Map<String, dynamic> toJson();

  static InferenceContent fromJson(Map<String, dynamic> json) {
    final mime = json['mime_type'] as String;
    if (mime == 'text/x-thinking') return ThinkingContent.fromJson(json);
    if (mime == 'application/x-redacted-thinking') {
      return RedactedThinkingContent.fromJson(json);
    }
    if (mime.startsWith('text/')) return TextContent.fromJson(json);
    if (mime.startsWith('image/')) return ImageContent.fromJson(json);
    throw FormatException('Unknown content MIME type: $mime');
  }
}

final class TextContent extends InferenceContent {
  const TextContent({this.mimeType = 'text/plain', required this.text});

  @override
  final String mimeType;
  final String text;

  factory TextContent.fromJson(Map<String, dynamic> json) => TextContent(
    mimeType: json['mime_type'] as String? ?? 'text/plain',
    text: json['text'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {
    'mime_type': mimeType,
    'text': text,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextContent && mimeType == other.mimeType && text == other.text;

  @override
  int get hashCode => Object.hash(mimeType, text);
}

enum ImageSource {
  base64,
  url;

  static ImageSource fromJson(String value) => switch (value) {
    'base64' => base64,
    'url' => url,
    _ => throw FormatException('Unknown image source: $value'),
  };

  String toJson() => name;
}

final class ImageContent extends InferenceContent {
  const ImageContent({
    required this.mimeType,
    required this.data,
    required this.source,
  });

  @override
  final String mimeType;
  final String data;
  final ImageSource source;

  factory ImageContent.fromJson(Map<String, dynamic> json) => ImageContent(
    mimeType: json['mime_type'] as String,
    data: json['data'] as String,
    source: ImageSource.fromJson(json['source'] as String),
  );

  @override
  Map<String, dynamic> toJson() => {
    'mime_type': mimeType,
    'data': data,
    'source': source.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageContent &&
          mimeType == other.mimeType &&
          data == other.data &&
          source == other.source;

  @override
  int get hashCode => Object.hash(mimeType, data, source);
}

final class ThinkingContent extends InferenceContent {
  const ThinkingContent({required this.text, this.signature});

  @override
  String get mimeType => 'text/x-thinking';
  final String text;
  final String? signature;

  factory ThinkingContent.fromJson(Map<String, dynamic> json) =>
      ThinkingContent(
        text: json['text'] as String,
        signature: json['signature'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
    'mime_type': mimeType,
    'text': text,
    if (signature != null) 'signature': signature,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThinkingContent &&
          text == other.text &&
          signature == other.signature;

  @override
  int get hashCode => Object.hash(mimeType, text, signature);
}

final class RedactedThinkingContent extends InferenceContent {
  const RedactedThinkingContent({required this.data});

  @override
  String get mimeType => 'application/x-redacted-thinking';
  final String data;

  factory RedactedThinkingContent.fromJson(Map<String, dynamic> json) =>
      RedactedThinkingContent(data: json['data'] as String);

  @override
  Map<String, dynamic> toJson() => {
    'mime_type': mimeType,
    'data': data,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RedactedThinkingContent && data == other.data;

  @override
  int get hashCode => Object.hash(mimeType, data);
}

// ---------------------------------------------------------------------------
// FunctionCall
// ---------------------------------------------------------------------------

final class FunctionCall {
  const FunctionCall({
    required this.id,
    required this.name,
    required this.arguments,
  });

  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  factory FunctionCall.fromJson(Map<String, dynamic> json) => FunctionCall(
    id: json['id'] as String,
    name: json['name'] as String,
    arguments: json['arguments'] as Map<String, dynamic>,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arguments': arguments,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FunctionCall &&
          id == other.id &&
          name == other.name &&
          _mapEquals(arguments, other.arguments);

  @override
  int get hashCode => Object.hash(id, name, Object.hashAll(arguments.entries));
}

// ---------------------------------------------------------------------------
// InferenceMessage
// ---------------------------------------------------------------------------

final class InferenceMessage {
  const InferenceMessage({
    required this.role,
    this.content = const [],
    this.functionCalls,
    this.functionCallId,
  });

  final InferenceRole role;
  final List<InferenceContent> content;
  final List<FunctionCall>? functionCalls;
  final String? functionCallId;

  /// System-role message with single text block.
  factory InferenceMessage.system(String text) => InferenceMessage(
    role: InferenceRole.system,
    content: [TextContent(text: text)],
  );

  /// User-role message with single text block.
  factory InferenceMessage.user(String text) => InferenceMessage(
    role: InferenceRole.user,
    content: [TextContent(text: text)],
  );

  /// User-role message with multiple content blocks.
  factory InferenceMessage.userMulti(List<InferenceContent> parts) =>
      InferenceMessage(role: InferenceRole.user, content: parts);

  /// Function result message keyed by call ID.
  factory InferenceMessage.functionResult(
    String functionCallId,
    List<InferenceContent> content,
  ) => InferenceMessage(
    role: InferenceRole.functionResult,
    content: content,
    functionCallId: functionCallId,
  );

  factory InferenceMessage.fromJson(Map<String, dynamic> json) {
    return InferenceMessage(
      role: InferenceRole.fromJson(json['role'] as String),
      content: (json['content'] as List<dynamic>?)
              ?.map((e) =>
                  InferenceContent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      functionCalls: (json['function_calls'] as List<dynamic>?)
          ?.map((e) => FunctionCall.fromJson(e as Map<String, dynamic>))
          .toList(),
      functionCallId: json['function_call_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role.toJson(),
    'content': content.map((c) => c.toJson()).toList(),
    if (functionCalls != null)
      'function_calls': functionCalls!.map((fc) => fc.toJson()).toList(),
    if (functionCallId != null) 'function_call_id': functionCallId,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InferenceMessage &&
          role == other.role &&
          _listEquals(content, other.content) &&
          _listEquals(functionCalls, other.functionCalls) &&
          functionCallId == other.functionCallId;

  @override
  int get hashCode => Object.hash(
    role,
    Object.hashAll(content),
    functionCalls == null ? null : Object.hashAll(functionCalls!),
    functionCallId,
  );
}

// ---------------------------------------------------------------------------
// StopReason
// ---------------------------------------------------------------------------

enum StopReason {
  endTurn,
  maxTokens,
  stopSequence,
  toolUse,
  contentFilter;

  static StopReason fromJson(String value) => switch (value) {
    'end_turn' => endTurn,
    'max_tokens' => maxTokens,
    'stop_sequence' => stopSequence,
    'tool_use' => toolUse,
    'content_filter' => contentFilter,
    _ => throw FormatException('Unknown stop reason: $value'),
  };

  String toJson() => switch (this) {
    endTurn => 'end_turn',
    maxTokens => 'max_tokens',
    stopSequence => 'stop_sequence',
    toolUse => 'tool_use',
    contentFilter => 'content_filter',
  };
}

// ---------------------------------------------------------------------------
// TokenUsage
// ---------------------------------------------------------------------------

final class TokenUsage {
  const TokenUsage({
    required this.inputTokens,
    required this.outputTokens,
    this.cacheReadTokens,
    this.cacheWriteTokens,
    this.reasoningTokens,
  });

  final int inputTokens;
  final int outputTokens;
  final int? cacheReadTokens;
  final int? cacheWriteTokens;
  final int? reasoningTokens;

  factory TokenUsage.fromJson(Map<String, dynamic> json) => TokenUsage(
    inputTokens: json['input_tokens'] as int,
    outputTokens: json['output_tokens'] as int,
    cacheReadTokens: json['cache_read_tokens'] as int?,
    cacheWriteTokens: json['cache_write_tokens'] as int?,
    reasoningTokens: json['reasoning_tokens'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'input_tokens': inputTokens,
    'output_tokens': outputTokens,
    'cache_read_tokens': cacheReadTokens,
    'cache_write_tokens': cacheWriteTokens,
    'reasoning_tokens': reasoningTokens,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenUsage &&
          inputTokens == other.inputTokens &&
          outputTokens == other.outputTokens &&
          cacheReadTokens == other.cacheReadTokens &&
          cacheWriteTokens == other.cacheWriteTokens &&
          reasoningTokens == other.reasoningTokens;

  @override
  int get hashCode => Object.hash(
    inputTokens, outputTokens, cacheReadTokens,
    cacheWriteTokens, reasoningTokens,
  );
}

// ---------------------------------------------------------------------------
// InferenceMetadata
// ---------------------------------------------------------------------------

final class InferenceMetadata {
  const InferenceMetadata({
    required this.model,
    required this.stopReason,
    this.usage,
  });

  final String model;
  final StopReason stopReason;
  final TokenUsage? usage;

  factory InferenceMetadata.fromJson(Map<String, dynamic> json) =>
      InferenceMetadata(
        model: json['model'] as String,
        stopReason: StopReason.fromJson(json['stop_reason'] as String),
        usage: json['usage'] == null
            ? null
            : TokenUsage.fromJson(json['usage'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    'model': model,
    'stop_reason': stopReason.toJson(),
    if (usage != null) 'usage': usage!.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InferenceMetadata &&
          model == other.model &&
          stopReason == other.stopReason &&
          usage == other.usage;

  @override
  int get hashCode => Object.hash(model, stopReason, usage);
}

// ---------------------------------------------------------------------------
// InferenceErrorKind
// ---------------------------------------------------------------------------

enum InferenceErrorKind {
  authentication,
  permission,
  rateLimited,
  invalidRequest,
  contextExceeded,
  serverError,
  overloaded,
  networkError,
  contentPolicy,
  insufficientQuota,
  unknown;

  static InferenceErrorKind fromJson(String value) => switch (value) {
    'authentication' => authentication,
    'permission' => permission,
    'rate_limited' => rateLimited,
    'invalid_request' => invalidRequest,
    'context_exceeded' => contextExceeded,
    'server_error' => serverError,
    'overloaded' => overloaded,
    'network_error' => networkError,
    'content_policy' => contentPolicy,
    'insufficient_quota' => insufficientQuota,
    'unknown' => unknown,
    _ => throw FormatException('Unknown error kind: $value'),
  };

  String toJson() => switch (this) {
    authentication => 'authentication',
    permission => 'permission',
    rateLimited => 'rate_limited',
    invalidRequest => 'invalid_request',
    contextExceeded => 'context_exceeded',
    serverError => 'server_error',
    overloaded => 'overloaded',
    networkError => 'network_error',
    contentPolicy => 'content_policy',
    insufficientQuota => 'insufficient_quota',
    unknown => 'unknown',
  };

  /// Whether this error kind is retryable.
  bool get isRetryable => switch (this) {
    rateLimited || overloaded || networkError || serverError => true,
    _ => false,
  };
}

// ---------------------------------------------------------------------------
// InferenceError
// ---------------------------------------------------------------------------

final class InferenceError {
  const InferenceError({
    required this.kind,
    required this.message,
    this.providerCode,
  });

  final InferenceErrorKind kind;
  final String message;
  final String? providerCode;

  factory InferenceError.fromJson(Map<String, dynamic> json) => InferenceError(
    kind: InferenceErrorKind.fromJson(json['kind'] as String),
    message: json['message'] as String,
    providerCode: json['provider_code'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'kind': kind.toJson(),
    'message': message,
    if (providerCode != null) 'provider_code': providerCode,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InferenceError &&
          kind == other.kind &&
          message == other.message &&
          providerCode == other.providerCode;

  @override
  int get hashCode => Object.hash(kind, message, providerCode);
}

// ---------------------------------------------------------------------------
// InferenceChunk — sealed output event type
// ---------------------------------------------------------------------------

sealed class InferenceChunk {
  const InferenceChunk();

  /// JSON event frame version.
  static const int frameVersion = 1;

  Map<String, dynamic> toJson();

  static InferenceChunk fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'text_delta' => TextDelta.fromJson(json),
      'tool_call_start' => ToolCallStart.fromJson(json),
      'tool_call_delta' => ToolCallDelta.fromJson(json),
      'thinking_delta' => ThinkingDelta.fromJson(json),
      'redacted_thinking_delta' => RedactedThinkingDelta.fromJson(json),
      'complete' => CompleteChunk.fromJson(json),
      _ => throw FormatException('Unknown chunk type: $type'),
    };
  }
}

final class TextDelta extends InferenceChunk {
  const TextDelta({required this.text});
  final String text;

  factory TextDelta.fromJson(Map<String, dynamic> json) =>
      TextDelta(text: json['text'] as String);

  @override
  Map<String, dynamic> toJson() => {
    'v': InferenceChunk.frameVersion,
    'type': 'text_delta',
    'text': text,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TextDelta && text == other.text;
  @override
  int get hashCode => text.hashCode;
}

final class ToolCallStart extends InferenceChunk {
  const ToolCallStart({required this.id, required this.name});
  final String id;
  final String name;

  factory ToolCallStart.fromJson(Map<String, dynamic> json) => ToolCallStart(
    id: json['id'] as String,
    name: json['name'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {
    'v': InferenceChunk.frameVersion,
    'type': 'tool_call_start',
    'id': id,
    'name': name,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolCallStart && id == other.id && name == other.name;
  @override
  int get hashCode => Object.hash(id, name);
}

final class ToolCallDelta extends InferenceChunk {
  const ToolCallDelta({required this.id, required this.argumentsDelta});
  final String id;
  final String argumentsDelta;

  factory ToolCallDelta.fromJson(Map<String, dynamic> json) => ToolCallDelta(
    id: json['id'] as String,
    argumentsDelta: json['arguments_delta'] as String,
  );

  @override
  Map<String, dynamic> toJson() => {
    'v': InferenceChunk.frameVersion,
    'type': 'tool_call_delta',
    'id': id,
    'arguments_delta': argumentsDelta,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolCallDelta &&
          id == other.id &&
          argumentsDelta == other.argumentsDelta;
  @override
  int get hashCode => Object.hash(id, argumentsDelta);
}

final class ThinkingDelta extends InferenceChunk {
  const ThinkingDelta({required this.text});
  final String text;

  factory ThinkingDelta.fromJson(Map<String, dynamic> json) =>
      ThinkingDelta(text: json['text'] as String);

  @override
  Map<String, dynamic> toJson() => {
    'v': InferenceChunk.frameVersion,
    'type': 'thinking_delta',
    'text': text,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ThinkingDelta && text == other.text;
  @override
  int get hashCode => text.hashCode;
}

final class RedactedThinkingDelta extends InferenceChunk {
  const RedactedThinkingDelta({required this.data});
  final String data;

  factory RedactedThinkingDelta.fromJson(Map<String, dynamic> json) =>
      RedactedThinkingDelta(data: json['data'] as String);

  @override
  Map<String, dynamic> toJson() => {
    'v': InferenceChunk.frameVersion,
    'type': 'redacted_thinking_delta',
    'data': data,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RedactedThinkingDelta && data == other.data;
  @override
  int get hashCode => data.hashCode;
}

final class CompleteChunk extends InferenceChunk {
  const CompleteChunk({required this.metadata});
  final InferenceMetadata metadata;

  factory CompleteChunk.fromJson(Map<String, dynamic> json) => CompleteChunk(
    metadata:
        InferenceMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  );

  @override
  Map<String, dynamic> toJson() => {
    'v': InferenceChunk.frameVersion,
    'type': 'complete',
    'metadata': metadata.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompleteChunk && metadata == other.metadata;
  @override
  int get hashCode => metadata.hashCode;
}

// ---------------------------------------------------------------------------
// ToolChoice — sealed
// ---------------------------------------------------------------------------

sealed class ToolChoice {
  const ToolChoice();

  static const ToolChoice auto = _AutoToolChoice();
  static const ToolChoice any = _AnyToolChoice();
  static const ToolChoice none = _NoneToolChoice();
  factory ToolChoice.tool(String name) = _NamedToolChoice;

  Map<String, dynamic> toJson();

  static ToolChoice fromJson(dynamic json) {
    if (json is String) {
      return switch (json) {
        'auto' => auto,
        'any' => any,
        'none' => none,
        _ => throw FormatException('Unknown tool choice: $json'),
      };
    }
    final map = json as Map<String, dynamic>;
    final type = map['type'] as String;
    return switch (type) {
      'auto' => auto,
      'any' => any,
      'none' => none,
      'tool' => ToolChoice.tool(map['name'] as String),
      _ => throw FormatException('Unknown tool choice type: $type'),
    };
  }
}

final class _AutoToolChoice extends ToolChoice {
  const _AutoToolChoice();
  @override
  Map<String, dynamic> toJson() => {'type': 'auto'};
  @override
  bool operator ==(Object other) => other is _AutoToolChoice;
  @override
  int get hashCode => 'auto'.hashCode;
}

final class _AnyToolChoice extends ToolChoice {
  const _AnyToolChoice();
  @override
  Map<String, dynamic> toJson() => {'type': 'any'};
  @override
  bool operator ==(Object other) => other is _AnyToolChoice;
  @override
  int get hashCode => 'any'.hashCode;
}

final class _NoneToolChoice extends ToolChoice {
  const _NoneToolChoice();
  @override
  Map<String, dynamic> toJson() => {'type': 'none'};
  @override
  bool operator ==(Object other) => other is _NoneToolChoice;
  @override
  int get hashCode => 'none'.hashCode;
}

final class _NamedToolChoice extends ToolChoice {
  const _NamedToolChoice(this.name);
  final String name;
  @override
  Map<String, dynamic> toJson() => {'type': 'tool', 'name': name};
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _NamedToolChoice && name == other.name;
  @override
  int get hashCode => Object.hash('tool', name);
}

// ---------------------------------------------------------------------------
// ToolDefinition
// ---------------------------------------------------------------------------

final class ToolDefinition {
  const ToolDefinition({
    required this.name,
    required this.description,
    required this.inputSchema,
  });

  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;

  factory ToolDefinition.fromJson(Map<String, dynamic> json) => ToolDefinition(
    name: json['name'] as String,
    description: json['description'] as String,
    inputSchema: json['input_schema'] as Map<String, dynamic>,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'input_schema': inputSchema,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolDefinition &&
          name == other.name &&
          description == other.description &&
          _mapEquals(inputSchema, other.inputSchema);

  @override
  int get hashCode =>
      Object.hash(name, description, Object.hashAll(inputSchema.entries));
}

// ---------------------------------------------------------------------------
// InferenceCapabilities
// ---------------------------------------------------------------------------

final class InferenceCapabilities {
  const InferenceCapabilities({
    required this.model,
    required this.provider,
    required this.maxContextTokens,
    required this.maxOutputTokens,
    required this.supportsThinking,
    required this.supportsTools,
    required this.supportsImages,
    required this.supportsStreaming,
    required this.supportedInputFormats,
    required this.supportedOutputFormats,
    required this.supportedStopReasons,
  });

  final String model;
  final String provider;
  final int maxContextTokens;
  final int maxOutputTokens;
  final bool supportsThinking;
  final bool supportsTools;
  final bool supportsImages;
  final bool supportsStreaming;
  final List<String> supportedInputFormats;
  final List<String> supportedOutputFormats;
  final List<String> supportedStopReasons;

  factory InferenceCapabilities.fromJson(Map<String, dynamic> json) =>
      InferenceCapabilities(
        model: json['model'] as String,
        provider: json['provider'] as String,
        maxContextTokens: json['max_context_tokens'] as int,
        maxOutputTokens: json['max_output_tokens'] as int,
        supportsThinking: json['supports_thinking'] as bool,
        supportsTools: json['supports_tools'] as bool,
        supportsImages: json['supports_images'] as bool,
        supportsStreaming: json['supports_streaming'] as bool,
        supportedInputFormats:
            (json['supported_input_formats'] as List<dynamic>).cast<String>(),
        supportedOutputFormats:
            (json['supported_output_formats'] as List<dynamic>).cast<String>(),
        supportedStopReasons:
            (json['supported_stop_reasons'] as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toJson() => {
    'model': model,
    'provider': provider,
    'max_context_tokens': maxContextTokens,
    'max_output_tokens': maxOutputTokens,
    'supports_thinking': supportsThinking,
    'supports_tools': supportsTools,
    'supports_images': supportsImages,
    'supports_streaming': supportsStreaming,
    'supported_input_formats': supportedInputFormats,
    'supported_output_formats': supportedOutputFormats,
    'supported_stop_reasons': supportedStopReasons,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InferenceCapabilities &&
          model == other.model &&
          provider == other.provider &&
          maxContextTokens == other.maxContextTokens &&
          maxOutputTokens == other.maxOutputTokens &&
          supportsThinking == other.supportsThinking &&
          supportsTools == other.supportsTools &&
          supportsImages == other.supportsImages &&
          supportsStreaming == other.supportsStreaming;

  @override
  int get hashCode => Object.hash(
    model, provider, maxContextTokens, maxOutputTokens,
    supportsThinking, supportsTools, supportsImages, supportsStreaming,
  );
}

// ---------------------------------------------------------------------------
// InferenceConfig
// ---------------------------------------------------------------------------

final class InferenceConfig {
  const InferenceConfig({
    this.inputFormat = InferenceFormat.unstructured,
    this.outputFormat = InferenceFormat.unstructured,
    this.maxTokens,
    this.temperature,
    this.topP,
    this.stop,
    this.thinkingBudget,
    this.tools,
    this.toolChoice,
    this.system,
    this.extra,
  });

  final InferenceFormat inputFormat;
  final InferenceFormat outputFormat;
  final int? maxTokens;
  final double? temperature;
  final double? topP;
  final List<String>? stop;
  final int? thinkingBudget;
  final List<ToolDefinition>? tools;
  final ToolChoice? toolChoice;
  final String? system;
  final Map<String, dynamic>? extra;

  /// Return a copy with the given fields replaced.
  InferenceConfig copyWith({
    InferenceFormat? inputFormat,
    InferenceFormat? outputFormat,
    int? Function()? maxTokens,
    double? Function()? temperature,
    double? Function()? topP,
    List<String>? Function()? stop,
    int? Function()? thinkingBudget,
    List<ToolDefinition>? Function()? tools,
    ToolChoice? Function()? toolChoice,
    String? Function()? system,
    Map<String, dynamic>? Function()? extra,
  }) => InferenceConfig(
    inputFormat: inputFormat ?? this.inputFormat,
    outputFormat: outputFormat ?? this.outputFormat,
    maxTokens: maxTokens != null ? maxTokens() : this.maxTokens,
    temperature: temperature != null ? temperature() : this.temperature,
    topP: topP != null ? topP() : this.topP,
    stop: stop != null ? stop() : this.stop,
    thinkingBudget:
        thinkingBudget != null ? thinkingBudget() : this.thinkingBudget,
    tools: tools != null ? tools() : this.tools,
    toolChoice: toolChoice != null ? toolChoice() : this.toolChoice,
    system: system != null ? system() : this.system,
    extra: extra != null ? extra() : this.extra,
  );
}

// ---------------------------------------------------------------------------
// InferenceSession
// ---------------------------------------------------------------------------

/// Per-fd session state for inference drivers.
final class InferenceSession {
  InferenceSession({required this.model});

  final String model;
  InferenceMetadata? lastMetadata;
  InferenceError? lastError;
}

// ---------------------------------------------------------------------------
// Ioctl Constants
// ---------------------------------------------------------------------------

/// LLM subsystem ioctl command codes.
abstract final class LlmIoctl {
  // Config set commands (write-direction).
  static const int setMaxTokens = 0x01;
  static const int setTemperature = 0x02;
  static const int setTopP = 0x03;
  static const int setStop = 0x04;
  static const int setThinkingBudget = 0x05;
  static const int setInputFormat = 0x06;
  static const int setOutputFormat = 0x07;
  static const int setTools = 0x08;
  static const int setToolChoice = 0x09;
  static const int setExtra = 0x0A;
  static const int setSystem = 0x0B;

  // Query commands (read-direction).
  static const int getMetadata = 0x80;
  static const int getError = 0x81;
  static const int getInfo = 0x82;
}

// ---------------------------------------------------------------------------
// InferenceConfigCodec
// ---------------------------------------------------------------------------

/// Maps raw ioctl (cmd, data) to [InferenceConfig] mutations.
///
/// Subsystem-level artifact — defined once for all inference drivers.
/// Validates types but does not interpret parameter values.
final class InferenceConfigCodec extends ConfigCodec<InferenceConfig> {
  InferenceConfigCodec();

  @override
  InferenceConfig apply(
      InferenceConfig current, int command, Uint8List data) {
    return switch (command) {
      LlmIoctl.setMaxTokens => current.copyWith(
          maxTokens: () => _int32(data)),
      LlmIoctl.setTemperature => current.copyWith(
          temperature: () => _float64(data)),
      LlmIoctl.setTopP => current.copyWith(
          topP: () => _float64(data)),
      LlmIoctl.setStop => current.copyWith(
          stop: () => _jsonStringList(data)),
      LlmIoctl.setThinkingBudget => current.copyWith(
          thinkingBudget: () => _int32(data)),
      LlmIoctl.setInputFormat => current.copyWith(
          inputFormat: InferenceFormat.fromCode(data[0])),
      LlmIoctl.setOutputFormat => current.copyWith(
          outputFormat: InferenceFormat.fromCode(data[0])),
      LlmIoctl.setTools => current.copyWith(
          tools: () => _jsonList(data)
              .map((e) =>
                  ToolDefinition.fromJson(e as Map<String, dynamic>))
              .toList()),
      LlmIoctl.setToolChoice => current.copyWith(
          toolChoice: () => ToolChoice.fromJson(_jsonDecode(data))),
      LlmIoctl.setExtra => current.copyWith(
          extra: () => _jsonMap(data)),
      LlmIoctl.setSystem => current.copyWith(
          system: () => utf8.decode(data)),
      _ => throw DriverError.invalidArgument(
          'Unknown ioctl command: 0x${command.toRadixString(16)}'),
    };
  }

  @override
  Uint8List encode(InferenceConfig config, int command) {
    return switch (command) {
      LlmIoctl.setMaxTokens => _encodeInt32(config.maxTokens ?? 0),
      LlmIoctl.setTemperature => _encodeFloat64(config.temperature ?? 0.0),
      LlmIoctl.setTopP => _encodeFloat64(config.topP ?? 0.0),
      LlmIoctl.setStop => _encodeJson(config.stop ?? const []),
      LlmIoctl.setThinkingBudget =>
          _encodeInt32(config.thinkingBudget ?? 0),
      LlmIoctl.setInputFormat => Uint8List.fromList([config.inputFormat.code]),
      LlmIoctl.setOutputFormat =>
          Uint8List.fromList([config.outputFormat.code]),
      LlmIoctl.setTools => _encodeJson(
          config.tools?.map((t) => t.toJson()).toList() ?? const []),
      LlmIoctl.setToolChoice =>
          _encodeJson(config.toolChoice?.toJson() ?? {'type': 'auto'}),
      LlmIoctl.setExtra => _encodeJson(config.extra ?? const {}),
      LlmIoctl.setSystem =>
          Uint8List.fromList(utf8.encode(config.system ?? '')),
      _ => throw DriverError.invalidArgument(
          'Unknown ioctl command: 0x${command.toRadixString(16)}'),
    };
  }

  // -- Decoding helpers --

  static int _int32(Uint8List data) =>
      ByteData.sublistView(data).getInt32(0, Endian.little);

  static double _float64(Uint8List data) =>
      ByteData.sublistView(data).getFloat64(0, Endian.little);

  static dynamic _jsonDecode(Uint8List data) =>
      jsonDecode(utf8.decode(data));

  static List<dynamic> _jsonList(Uint8List data) =>
      _jsonDecode(data) as List<dynamic>;

  static List<String> _jsonStringList(Uint8List data) =>
      _jsonList(data).cast<String>();

  static Map<String, dynamic> _jsonMap(Uint8List data) =>
      _jsonDecode(data) as Map<String, dynamic>;

  // -- Encoding helpers --

  static Uint8List _encodeInt32(int value) {
    final bd = ByteData(4)..setInt32(0, value, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List _encodeFloat64(double value) {
    final bd = ByteData(8)..setFloat64(0, value, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List _encodeJson(Object value) =>
      Uint8List.fromList(utf8.encode(jsonEncode(value)));
}

// ---------------------------------------------------------------------------
// InferenceState (pre-CUSE streaming envelope)
// ---------------------------------------------------------------------------

enum InferenceState { building, done, error }

/// Pre-CUSE streaming envelope — wraps an [InferenceMessage] with delivery
/// state. In the P4 driver model, the equivalent is the [InferenceChunk]
/// stream + state machine transitions.
final class InferenceSnapshot {
  const InferenceSnapshot({
    required this.state,
    required this.message,
    this.metadata,
    this.error,
  });

  final InferenceState state;
  final InferenceMessage message;
  final InferenceMetadata? metadata;
  final InferenceError? error;
}

// ---------------------------------------------------------------------------
// Type alias for P4 ops projection
// ---------------------------------------------------------------------------

/// Concrete P4 ops type for inference drivers.
typedef InferenceOps
    = ConfiguredStreamOps<InferenceConfig, List<InferenceMessage>,
        InferenceChunk, InferenceSession>;

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

bool _mapEquals(Map<dynamic, dynamic>? a, Map<dynamic, dynamic>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
