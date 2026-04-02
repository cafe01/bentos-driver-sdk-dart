/// Inference subsystem serialization helpers — default [encodeOutput] and
/// [decodeInput] implementations for all inference drivers.
///
/// These are subsystem-level concerns, not per-driver. Every inference driver
/// inherits the same format-aware serialization. Format (unstructured vs
/// structured) determines wire behavior; the driver yields domain types
/// ([InferenceChunk] / [InferenceMessage]) and never touches bytes.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'inference_types.dart';

/// Default `encodeOutput` for all inference drivers.
///
/// Unstructured (format=0): UTF-8 text bytes. Only [TextDelta] and
/// [ThinkingDelta] emit bytes — tool calls and redacted thinking are dropped
/// (they cannot be represented as plain text). [CompleteChunk] emits nothing.
///
/// Structured (format=1): JSON-encoded event frame bytes (payload only —
/// the framework handles length-prefix framing).
Uint8List inferenceEncodeOutput(
  InferenceChunk chunk, {
  required InferenceConfig config,
}) {
  return switch (config.outputFormat) {
    InferenceFormat.unstructured => _encodeUnstructuredOutput(chunk),
    InferenceFormat.structured => _encodeStructuredOutput(chunk),
  };
}

/// Default `decodeInput` for all inference drivers.
///
/// Unstructured (format=0): Raw UTF-8 bytes → single user message.
/// Structured (format=1): JSON bytes → `List<InferenceMessage>`.
List<InferenceMessage> inferenceDecodeInput(
  Uint8List data, {
  required InferenceConfig config,
}) {
  return switch (config.inputFormat) {
    InferenceFormat.unstructured => [
      InferenceMessage.user(utf8.decode(data)),
    ],
    InferenceFormat.structured => _decodeStructuredInput(data),
  };
}

// ---------------------------------------------------------------------------
// Unstructured output
// ---------------------------------------------------------------------------

Uint8List _encodeUnstructuredOutput(InferenceChunk chunk) => switch (chunk) {
  TextDelta(:final text) => Uint8List.fromList(utf8.encode(text)),
  ThinkingDelta(:final text) => Uint8List.fromList(utf8.encode(text)),
  // Tool calls, redacted thinking, and complete are not representable as
  // plain text — dropped per spec.
  ToolCallStart() => Uint8List(0),
  ToolCallDelta() => Uint8List(0),
  RedactedThinkingDelta() => Uint8List(0),
  CompleteChunk() => Uint8List(0),
};

// ---------------------------------------------------------------------------
// Structured output
// ---------------------------------------------------------------------------

Uint8List _encodeStructuredOutput(InferenceChunk chunk) =>
    Uint8List.fromList(utf8.encode(jsonEncode(chunk.toJson())));

// ---------------------------------------------------------------------------
// Structured input
// ---------------------------------------------------------------------------

List<InferenceMessage> _decodeStructuredInput(Uint8List data) {
  final decoded = jsonDecode(utf8.decode(data));
  if (decoded is List) {
    return decoded
        .map((e) => InferenceMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  throw FormatException(
    'Structured input must be a JSON array of messages, got: '
    '${decoded.runtimeType}',
  );
}
