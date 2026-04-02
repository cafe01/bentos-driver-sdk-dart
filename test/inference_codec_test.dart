import 'dart:convert';
import 'dart:typed_data';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('inferenceEncodeOutput', () {
    group('unstructured format', () {
      final config = const InferenceConfig(
        outputFormat: InferenceFormat.unstructured,
      );

      test('TextDelta emits UTF-8 bytes', () {
        final result = inferenceEncodeOutput(
          const TextDelta(text: 'hello'),
          config: config,
        );
        expect(utf8.decode(result), 'hello');
      });

      test('ThinkingDelta emits UTF-8 bytes', () {
        final result = inferenceEncodeOutput(
          const ThinkingDelta(text: 'thinking...'),
          config: config,
        );
        expect(utf8.decode(result), 'thinking...');
      });

      test('ToolCallStart emits empty bytes', () {
        final result = inferenceEncodeOutput(
          const ToolCallStart(id: 'tc1', name: 'search'),
          config: config,
        );
        expect(result, isEmpty);
      });

      test('ToolCallDelta emits empty bytes', () {
        final result = inferenceEncodeOutput(
          const ToolCallDelta(id: 'tc1', argumentsDelta: '{"q":'),
          config: config,
        );
        expect(result, isEmpty);
      });

      test('RedactedThinkingDelta emits empty bytes', () {
        final result = inferenceEncodeOutput(
          const RedactedThinkingDelta(data: 'redacted'),
          config: config,
        );
        expect(result, isEmpty);
      });

      test('CompleteChunk emits empty bytes', () {
        final result = inferenceEncodeOutput(
          const CompleteChunk(
            metadata: InferenceMetadata(
              model: 'test',
              stopReason: StopReason.endTurn,
            ),
          ),
          config: config,
        );
        expect(result, isEmpty);
      });

      test('handles unicode text', () {
        final result = inferenceEncodeOutput(
          const TextDelta(text: 'cafe\u0301 \u{1F600}'),
          config: config,
        );
        expect(utf8.decode(result), 'cafe\u0301 \u{1F600}');
      });
    });

    group('structured format', () {
      final config = const InferenceConfig(
        outputFormat: InferenceFormat.structured,
      );

      test('TextDelta produces valid JSON with type and version', () {
        final result = inferenceEncodeOutput(
          const TextDelta(text: 'hello'),
          config: config,
        );
        final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
        expect(json['type'], 'text_delta');
        expect(json['text'], 'hello');
        expect(json['v'], InferenceChunk.frameVersion);
      });

      test('ToolCallStart produces valid JSON', () {
        final result = inferenceEncodeOutput(
          const ToolCallStart(id: 'tc1', name: 'search'),
          config: config,
        );
        final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
        expect(json['type'], 'tool_call_start');
        expect(json['id'], 'tc1');
        expect(json['name'], 'search');
      });

      test('ToolCallDelta produces valid JSON', () {
        final result = inferenceEncodeOutput(
          const ToolCallDelta(id: 'tc1', argumentsDelta: '{"q":"test"}'),
          config: config,
        );
        final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
        expect(json['type'], 'tool_call_delta');
        expect(json['id'], 'tc1');
        expect(json['arguments_delta'], '{"q":"test"}');
      });

      test('ThinkingDelta produces valid JSON', () {
        final result = inferenceEncodeOutput(
          const ThinkingDelta(text: 'thinking...'),
          config: config,
        );
        final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
        expect(json['type'], 'thinking_delta');
        expect(json['text'], 'thinking...');
      });

      test('RedactedThinkingDelta produces valid JSON', () {
        final result = inferenceEncodeOutput(
          const RedactedThinkingDelta(data: 'redacted'),
          config: config,
        );
        final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
        expect(json['type'], 'redacted_thinking_delta');
        expect(json['data'], 'redacted');
      });

      test('CompleteChunk produces valid JSON with metadata', () {
        final result = inferenceEncodeOutput(
          const CompleteChunk(
            metadata: InferenceMetadata(
              model: 'claude-sonnet-4-20250514',
              stopReason: StopReason.endTurn,
              usage: TokenUsage(inputTokens: 10, outputTokens: 20),
            ),
          ),
          config: config,
        );
        final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
        expect(json['type'], 'complete');
        final meta = json['metadata'] as Map<String, dynamic>;
        expect(meta['model'], 'claude-sonnet-4-20250514');
        expect(meta['stop_reason'], 'end_turn');
        expect(meta['usage']['input_tokens'], 10);
        expect(meta['usage']['output_tokens'], 20);
      });

      test('round-trip: encode then decode all chunk types', () {
        final chunks = <InferenceChunk>[
          const TextDelta(text: 'hello'),
          const ToolCallStart(id: 'tc1', name: 'search'),
          const ToolCallDelta(id: 'tc1', argumentsDelta: '{"q":"x"}'),
          const ThinkingDelta(text: 'hmm'),
          const RedactedThinkingDelta(data: 'hidden'),
          const CompleteChunk(
            metadata: InferenceMetadata(
              model: 'test',
              stopReason: StopReason.toolUse,
            ),
          ),
        ];

        for (final chunk in chunks) {
          final encoded = inferenceEncodeOutput(chunk, config: config);
          final json =
              jsonDecode(utf8.decode(encoded)) as Map<String, dynamic>;
          final decoded = InferenceChunk.fromJson(json);
          expect(decoded, equals(chunk),
              reason: 'Round-trip failed for ${chunk.runtimeType}');
        }
      });
    });
  });

  group('inferenceDecodeInput', () {
    group('unstructured format', () {
      final config = const InferenceConfig(
        inputFormat: InferenceFormat.unstructured,
      );

      test('raw text becomes single user message', () {
        final data = Uint8List.fromList(utf8.encode('hello world'));
        final result = inferenceDecodeInput(data, config: config);
        expect(result, hasLength(1));
        expect(result[0].role, InferenceRole.user);
        expect(result[0].content, hasLength(1));
        final text = result[0].content[0] as TextContent;
        expect(text.text, 'hello world');
      });

      test('handles empty input', () {
        final data = Uint8List(0);
        final result = inferenceDecodeInput(data, config: config);
        expect(result, hasLength(1));
        final text = result[0].content[0] as TextContent;
        expect(text.text, '');
      });

      test('handles unicode input', () {
        final data = Uint8List.fromList(utf8.encode('cafe\u0301'));
        final result = inferenceDecodeInput(data, config: config);
        final text = result[0].content[0] as TextContent;
        expect(text.text, 'cafe\u0301');
      });
    });

    group('structured format', () {
      final config = const InferenceConfig(
        inputFormat: InferenceFormat.structured,
      );

      test('JSON array of messages decoded correctly', () {
        final messages = [
          {'role': 'system', 'content': [{'mime_type': 'text/plain', 'text': 'You are helpful.'}]},
          {'role': 'user', 'content': [{'mime_type': 'text/plain', 'text': 'Hello'}]},
        ];
        final data = Uint8List.fromList(utf8.encode(jsonEncode(messages)));
        final result = inferenceDecodeInput(data, config: config);

        expect(result, hasLength(2));
        expect(result[0].role, InferenceRole.system);
        expect((result[0].content[0] as TextContent).text, 'You are helpful.');
        expect(result[1].role, InferenceRole.user);
        expect((result[1].content[0] as TextContent).text, 'Hello');
      });

      test('round-trip: messages survive encode/decode', () {
        final original = [
          InferenceMessage.system('Be helpful.'),
          InferenceMessage.user('What is 2+2?'),
        ];
        final json = original.map((m) => m.toJson()).toList();
        final data = Uint8List.fromList(utf8.encode(jsonEncode(json)));
        final decoded = inferenceDecodeInput(data, config: config);

        expect(decoded, hasLength(2));
        expect(decoded[0], equals(original[0]));
        expect(decoded[1], equals(original[1]));
      });

      test('function result message survives round-trip', () {
        final original = [
          InferenceMessage.functionResult(
            'call_123',
            [const TextContent(text: '42')],
          ),
        ];
        final json = original.map((m) => m.toJson()).toList();
        final data = Uint8List.fromList(utf8.encode(jsonEncode(json)));
        final decoded = inferenceDecodeInput(data, config: config);

        expect(decoded[0].role, InferenceRole.functionResult);
        expect(decoded[0].functionCallId, 'call_123');
      });

      test('throws on non-array JSON', () {
        final data = Uint8List.fromList(utf8.encode('{"role":"user"}'));
        expect(
          () => inferenceDecodeInput(data, config: config),
          throwsFormatException,
        );
      });
    });
  });
}
