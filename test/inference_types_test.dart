import 'dart:convert';
import 'dart:typed_data';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:test/test.dart';

void main() {
  // -----------------------------------------------------------------------
  // InferenceRole
  // -----------------------------------------------------------------------
  group('InferenceRole', () {
    test('round-trips all values through JSON', () {
      for (final role in InferenceRole.values) {
        final json = role.toJson();
        final restored = InferenceRole.fromJson(json);
        expect(restored, role, reason: 'round-trip for $role');
      }
    });

    test('uses snake_case wire format', () {
      expect(InferenceRole.functionResult.toJson(), 'function_result');
    });

    test('rejects unknown value', () {
      expect(
        () => InferenceRole.fromJson('moderator'),
        throwsFormatException,
      );
    });
  });

  // -----------------------------------------------------------------------
  // InferenceContent — sealed by MIME
  // -----------------------------------------------------------------------
  group('InferenceContent', () {
    test('TextContent round-trip', () {
      final tc = TextContent(text: 'hello');
      final json = tc.toJson();
      expect(json['mime_type'], 'text/plain');
      final restored = InferenceContent.fromJson(json) as TextContent;
      expect(restored, tc);
    });

    test('TextContent with custom MIME subtype', () {
      final tc = TextContent(mimeType: 'text/markdown', text: '# Title');
      final restored = InferenceContent.fromJson(tc.toJson()) as TextContent;
      expect(restored.mimeType, 'text/markdown');
      expect(restored.text, '# Title');
    });

    test('ImageContent round-trip (base64)', () {
      final ic = ImageContent(
        mimeType: 'image/png',
        data: 'iVBORw0KGgo=',
        source: ImageSource.base64,
      );
      final restored = InferenceContent.fromJson(ic.toJson()) as ImageContent;
      expect(restored, ic);
    });

    test('ImageContent round-trip (url)', () {
      final ic = ImageContent(
        mimeType: 'image/jpeg',
        data: 'https://example.com/img.jpg',
        source: ImageSource.url,
      );
      final restored = InferenceContent.fromJson(ic.toJson()) as ImageContent;
      expect(restored, ic);
    });

    test('ThinkingContent round-trip with signature', () {
      final tc = ThinkingContent(
        text: 'Let me reason...',
        signature: 'sig123',
      );
      final json = tc.toJson();
      expect(json['mime_type'], 'text/x-thinking');
      final restored =
          InferenceContent.fromJson(json) as ThinkingContent;
      expect(restored, tc);
    });

    test('ThinkingContent round-trip without signature', () {
      final tc = ThinkingContent(text: 'thinking');
      final json = tc.toJson();
      expect(json.containsKey('signature'), isFalse);
      final restored =
          InferenceContent.fromJson(json) as ThinkingContent;
      expect(restored.signature, isNull);
    });

    test('RedactedThinkingContent round-trip', () {
      final rtc = RedactedThinkingContent(data: 'opaque-base64-data');
      final json = rtc.toJson();
      expect(json['mime_type'], 'application/x-redacted-thinking');
      final restored =
          InferenceContent.fromJson(json) as RedactedThinkingContent;
      expect(restored, rtc);
    });

    test('MIME discriminator routes correctly', () {
      // text/x-thinking must not be routed to TextContent
      final thinking = InferenceContent.fromJson({
        'mime_type': 'text/x-thinking',
        'text': 'reason',
      });
      expect(thinking, isA<ThinkingContent>());

      // text/plain routes to TextContent
      final text = InferenceContent.fromJson({
        'mime_type': 'text/plain',
        'text': 'hello',
      });
      expect(text, isA<TextContent>());
    });

    test('unknown MIME type throws', () {
      expect(
        () => InferenceContent.fromJson({
          'mime_type': 'audio/mp3',
          'data': 'abc',
        }),
        throwsFormatException,
      );
    });
  });

  // -----------------------------------------------------------------------
  // FunctionCall
  // -----------------------------------------------------------------------
  group('FunctionCall', () {
    test('round-trip', () {
      final fc = FunctionCall(
        id: 'call_123',
        name: 'get_weather',
        arguments: {'location': 'SF', 'unit': 'celsius'},
      );
      final json = fc.toJson();
      final restored = FunctionCall.fromJson(json);
      expect(restored, fc);
    });
  });

  // -----------------------------------------------------------------------
  // InferenceMessage
  // -----------------------------------------------------------------------
  group('InferenceMessage', () {
    test('system convenience constructor', () {
      final msg = InferenceMessage.system('Be helpful');
      expect(msg.role, InferenceRole.system);
      expect(msg.content, hasLength(1));
      expect((msg.content.first as TextContent).text, 'Be helpful');
    });

    test('user convenience constructor', () {
      final msg = InferenceMessage.user('Hello');
      expect(msg.role, InferenceRole.user);
    });

    test('userMulti constructor', () {
      final msg = InferenceMessage.userMulti([
        TextContent(text: 'Describe this:'),
        ImageContent(
          mimeType: 'image/png',
          data: 'abc',
          source: ImageSource.base64,
        ),
      ]);
      expect(msg.role, InferenceRole.user);
      expect(msg.content, hasLength(2));
    });

    test('functionResult constructor', () {
      final msg = InferenceMessage.functionResult(
        'call_123',
        [TextContent(text: '72F')],
      );
      expect(msg.role, InferenceRole.functionResult);
      expect(msg.functionCallId, 'call_123');
    });

    test('round-trip with function calls', () {
      final msg = InferenceMessage(
        role: InferenceRole.assistant,
        content: [TextContent(text: 'Let me check the weather.')],
        functionCalls: [
          FunctionCall(
            id: 'call_1',
            name: 'get_weather',
            arguments: {'city': 'NYC'},
          ),
        ],
      );
      final json = msg.toJson();
      final restored = InferenceMessage.fromJson(json);
      expect(restored, msg);
    });

    test('round-trip with mixed content', () {
      final msg = InferenceMessage(
        role: InferenceRole.assistant,
        content: [
          ThinkingContent(text: 'reasoning', signature: 'sig'),
          TextContent(text: 'The answer is 42.'),
          RedactedThinkingContent(data: 'opaque'),
        ],
      );
      final json = msg.toJson();
      final restored = InferenceMessage.fromJson(json);
      expect(restored, msg);
    });

    test('empty content list round-trips', () {
      final msg = InferenceMessage(role: InferenceRole.user);
      final restored = InferenceMessage.fromJson(msg.toJson());
      expect(restored.content, isEmpty);
    });
  });

  // -----------------------------------------------------------------------
  // StopReason
  // -----------------------------------------------------------------------
  group('StopReason', () {
    test('round-trips all values', () {
      for (final sr in StopReason.values) {
        expect(StopReason.fromJson(sr.toJson()), sr);
      }
    });

    test('uses snake_case wire format', () {
      expect(StopReason.endTurn.toJson(), 'end_turn');
      expect(StopReason.maxTokens.toJson(), 'max_tokens');
      expect(StopReason.contentFilter.toJson(), 'content_filter');
    });
  });

  // -----------------------------------------------------------------------
  // TokenUsage
  // -----------------------------------------------------------------------
  group('TokenUsage', () {
    test('round-trip with all fields', () {
      final tu = TokenUsage(
        inputTokens: 150,
        outputTokens: 42,
        cacheReadTokens: 100,
        cacheWriteTokens: 50,
        reasoningTokens: 30,
      );
      final restored = TokenUsage.fromJson(tu.toJson());
      expect(restored, tu);
    });

    test('round-trip with null optional fields', () {
      final tu = TokenUsage(inputTokens: 10, outputTokens: 5);
      final json = tu.toJson();
      expect(json['cache_read_tokens'], isNull);
      final restored = TokenUsage.fromJson(json);
      expect(restored, tu);
    });
  });

  // -----------------------------------------------------------------------
  // InferenceMetadata
  // -----------------------------------------------------------------------
  group('InferenceMetadata', () {
    test('round-trip', () {
      final meta = InferenceMetadata(
        model: 'claude-sonnet-4-20250514',
        stopReason: StopReason.endTurn,
        usage: TokenUsage(inputTokens: 150, outputTokens: 42),
      );
      final restored = InferenceMetadata.fromJson(meta.toJson());
      expect(restored, meta);
    });

    test('round-trip without usage', () {
      final meta = InferenceMetadata(
        model: 'gpt-4o',
        stopReason: StopReason.maxTokens,
      );
      final json = meta.toJson();
      expect(json.containsKey('usage'), isFalse);
      final restored = InferenceMetadata.fromJson(json);
      expect(restored, meta);
    });
  });

  // -----------------------------------------------------------------------
  // InferenceError
  // -----------------------------------------------------------------------
  group('InferenceError', () {
    test('round-trip', () {
      final err = InferenceError(
        kind: InferenceErrorKind.rateLimited,
        message: 'Rate limit exceeded',
        providerCode: '429',
      );
      final restored = InferenceError.fromJson(err.toJson());
      expect(restored, err);
    });

    test('retryable classification', () {
      expect(InferenceErrorKind.rateLimited.isRetryable, isTrue);
      expect(InferenceErrorKind.overloaded.isRetryable, isTrue);
      expect(InferenceErrorKind.networkError.isRetryable, isTrue);
      expect(InferenceErrorKind.serverError.isRetryable, isTrue);
      expect(InferenceErrorKind.authentication.isRetryable, isFalse);
      expect(InferenceErrorKind.invalidRequest.isRetryable, isFalse);
    });

    test('all error kinds round-trip', () {
      for (final kind in InferenceErrorKind.values) {
        expect(InferenceErrorKind.fromJson(kind.toJson()), kind);
      }
    });
  });

  // -----------------------------------------------------------------------
  // InferenceChunk — sealed event frames
  // -----------------------------------------------------------------------
  group('InferenceChunk', () {
    test('TextDelta round-trip', () {
      final chunk = TextDelta(text: 'Hello');
      final json = chunk.toJson();
      expect(json['v'], 1);
      expect(json['type'], 'text_delta');
      final restored = InferenceChunk.fromJson(json);
      expect(restored, chunk);
    });

    test('ToolCallStart round-trip', () {
      final chunk = ToolCallStart(id: 'call_abc', name: 'get_weather');
      final restored = InferenceChunk.fromJson(chunk.toJson());
      expect(restored, chunk);
    });

    test('ToolCallDelta round-trip', () {
      final chunk = ToolCallDelta(id: 'call_abc', argumentsDelta: '{"loc');
      final restored = InferenceChunk.fromJson(chunk.toJson());
      expect(restored, chunk);
    });

    test('ThinkingDelta round-trip', () {
      final chunk = ThinkingDelta(text: 'Let me reason...');
      final json = chunk.toJson();
      expect(json['type'], 'thinking_delta');
      final restored = InferenceChunk.fromJson(json);
      expect(restored, chunk);
    });

    test('RedactedThinkingDelta round-trip', () {
      final chunk = RedactedThinkingDelta(data: 'base64opaque');
      final json = chunk.toJson();
      expect(json['type'], 'redacted_thinking_delta');
      final restored = InferenceChunk.fromJson(json);
      expect(restored, chunk);
    });

    test('CompleteChunk round-trip', () {
      final chunk = CompleteChunk(
        metadata: InferenceMetadata(
          model: 'claude-sonnet-4-20250514',
          stopReason: StopReason.endTurn,
          usage: TokenUsage(inputTokens: 150, outputTokens: 42),
        ),
      );
      final restored = InferenceChunk.fromJson(chunk.toJson());
      expect(restored, chunk);
    });

    test('unknown chunk type throws', () {
      expect(
        () => InferenceChunk.fromJson({'v': 1, 'type': 'audio_delta'}),
        throwsFormatException,
      );
    });

    test('all frame versions are 1', () {
      final chunks = <InferenceChunk>[
        TextDelta(text: 'x'),
        ToolCallStart(id: 'a', name: 'b'),
        ToolCallDelta(id: 'a', argumentsDelta: 'c'),
        ThinkingDelta(text: 'y'),
        RedactedThinkingDelta(data: 'z'),
        CompleteChunk(
          metadata: InferenceMetadata(
            model: 'm',
            stopReason: StopReason.endTurn,
          ),
        ),
      ];
      for (final c in chunks) {
        expect(c.toJson()['v'], 1,
            reason: '${c.runtimeType} frame version');
      }
    });
  });

  // -----------------------------------------------------------------------
  // ToolChoice — sealed
  // -----------------------------------------------------------------------
  group('ToolChoice', () {
    test('auto round-trip', () {
      final json = ToolChoice.auto.toJson();
      expect(json['type'], 'auto');
      expect(ToolChoice.fromJson(json), ToolChoice.auto);
    });

    test('any round-trip', () {
      expect(ToolChoice.fromJson(ToolChoice.any.toJson()), ToolChoice.any);
    });

    test('none round-trip', () {
      expect(ToolChoice.fromJson(ToolChoice.none.toJson()), ToolChoice.none);
    });

    test('named tool round-trip', () {
      final tc = ToolChoice.tool('get_weather');
      final json = tc.toJson();
      expect(json['type'], 'tool');
      expect(json['name'], 'get_weather');
      final restored = ToolChoice.fromJson(json);
      expect(restored, tc);
    });

    test('fromJson accepts string shorthand', () {
      expect(ToolChoice.fromJson('auto'), ToolChoice.auto);
      expect(ToolChoice.fromJson('any'), ToolChoice.any);
      expect(ToolChoice.fromJson('none'), ToolChoice.none);
    });
  });

  // -----------------------------------------------------------------------
  // ToolDefinition
  // -----------------------------------------------------------------------
  group('ToolDefinition', () {
    test('round-trip', () {
      final td = ToolDefinition(
        name: 'get_weather',
        description: 'Get current weather',
        inputSchema: {
          'type': 'object',
          'properties': {
            'city': {'type': 'string'},
          },
          'required': ['city'],
        },
      );
      final restored = ToolDefinition.fromJson(td.toJson());
      expect(restored, td);
    });
  });

  // -----------------------------------------------------------------------
  // InferenceCapabilities
  // -----------------------------------------------------------------------
  group('InferenceCapabilities', () {
    test('round-trip', () {
      final caps = InferenceCapabilities(
        model: 'claude-sonnet-4-20250514',
        provider: 'anthropic',
        maxContextTokens: 200000,
        maxOutputTokens: 8192,
        supportsThinking: true,
        supportsTools: true,
        supportsImages: true,
        supportsStreaming: true,
        supportedInputFormats: ['unstructured', 'structured'],
        supportedOutputFormats: ['unstructured', 'structured'],
        supportedStopReasons: ['end_turn', 'max_tokens', 'stop_sequence', 'tool_use'],
      );
      final json = caps.toJson();
      expect(json['max_context_tokens'], 200000);
      expect(json['supports_thinking'], isTrue);
      final restored = InferenceCapabilities.fromJson(json);
      expect(restored, caps);
    });
  });

  // -----------------------------------------------------------------------
  // InferenceFormat
  // -----------------------------------------------------------------------
  group('InferenceFormat', () {
    test('codes are correct', () {
      expect(InferenceFormat.unstructured.code, 0);
      expect(InferenceFormat.structured.code, 1);
    });

    test('fromCode round-trip', () {
      expect(InferenceFormat.fromCode(0), InferenceFormat.unstructured);
      expect(InferenceFormat.fromCode(1), InferenceFormat.structured);
    });

    test('invalid code throws DriverError', () {
      expect(
        () => InferenceFormat.fromCode(99),
        throwsA(isA<DriverError>()),
      );
    });
  });

  // -----------------------------------------------------------------------
  // InferenceConfig + InferenceConfigCodec
  // -----------------------------------------------------------------------
  group('InferenceConfigCodec', () {
    final codec = InferenceConfigCodec();
    final defaultCfg = InferenceConfig();

    test('SET_MAX_TOKENS', () {
      final data = _int32Bytes(4096);
      final cfg = codec.apply(defaultCfg, LlmIoctl.setMaxTokens, data);
      expect(cfg.maxTokens, 4096);
    });

    test('SET_TEMPERATURE', () {
      final data = _float64Bytes(0.7);
      final cfg = codec.apply(defaultCfg, LlmIoctl.setTemperature, data);
      expect(cfg.temperature, closeTo(0.7, 0.001));
    });

    test('SET_TOP_P', () {
      final data = _float64Bytes(0.9);
      final cfg = codec.apply(defaultCfg, LlmIoctl.setTopP, data);
      expect(cfg.topP, closeTo(0.9, 0.001));
    });

    test('SET_STOP', () {
      final data = _jsonBytes(['STOP', 'END']);
      final cfg = codec.apply(defaultCfg, LlmIoctl.setStop, data);
      expect(cfg.stop, ['STOP', 'END']);
    });

    test('SET_THINKING_BUDGET', () {
      final data = _int32Bytes(10000);
      final cfg =
          codec.apply(defaultCfg, LlmIoctl.setThinkingBudget, data);
      expect(cfg.thinkingBudget, 10000);
    });

    test('SET_INPUT_FORMAT', () {
      final data = Uint8List.fromList([1]);
      final cfg =
          codec.apply(defaultCfg, LlmIoctl.setInputFormat, data);
      expect(cfg.inputFormat, InferenceFormat.structured);
    });

    test('SET_OUTPUT_FORMAT', () {
      final data = Uint8List.fromList([1]);
      final cfg =
          codec.apply(defaultCfg, LlmIoctl.setOutputFormat, data);
      expect(cfg.outputFormat, InferenceFormat.structured);
    });

    test('SET_TOOLS', () {
      final tools = [
        {
          'name': 'get_weather',
          'description': 'Get weather',
          'input_schema': {
            'type': 'object',
            'properties': {'city': {'type': 'string'}},
          },
        }
      ];
      final data = _jsonBytes(tools);
      final cfg = codec.apply(defaultCfg, LlmIoctl.setTools, data);
      expect(cfg.tools, hasLength(1));
      expect(cfg.tools!.first.name, 'get_weather');
    });

    test('SET_TOOL_CHOICE', () {
      final data = _jsonBytes({'type': 'tool', 'name': 'search'});
      final cfg =
          codec.apply(defaultCfg, LlmIoctl.setToolChoice, data);
      expect(cfg.toolChoice, ToolChoice.tool('search'));
    });

    test('SET_EXTRA', () {
      final data = _jsonBytes({'top_k': 40, 'metadata': {'user': 'test'}});
      final cfg = codec.apply(defaultCfg, LlmIoctl.setExtra, data);
      expect(cfg.extra!['top_k'], 40);
    });

    test('SET_SYSTEM', () {
      final data = Uint8List.fromList(utf8.encode('Be helpful'));
      final cfg = codec.apply(defaultCfg, LlmIoctl.setSystem, data);
      expect(cfg.system, 'Be helpful');
    });

    test('unknown command throws DriverError', () {
      expect(
        () => codec.apply(defaultCfg, 0xFF, Uint8List(0)),
        throwsA(isA<DriverError>()),
      );
    });

    test('encode round-trips with apply', () {
      // SETUP: config with specific values
      var cfg = defaultCfg;
      cfg = codec.apply(cfg, LlmIoctl.setMaxTokens, _int32Bytes(2048));
      cfg = codec.apply(cfg, LlmIoctl.setTemperature, _float64Bytes(0.5));
      cfg = codec.apply(
          cfg, LlmIoctl.setInputFormat, Uint8List.fromList([1]));

      // VERIFY: encode -> apply produces same values
      final maxTokensBytes = codec.encode(cfg, LlmIoctl.setMaxTokens);
      final tempBytes = codec.encode(cfg, LlmIoctl.setTemperature);
      final fmtBytes = codec.encode(cfg, LlmIoctl.setInputFormat);

      final fresh = InferenceConfig();
      var restored = codec.apply(fresh, LlmIoctl.setMaxTokens, maxTokensBytes);
      restored =
          codec.apply(restored, LlmIoctl.setTemperature, tempBytes);
      restored =
          codec.apply(restored, LlmIoctl.setInputFormat, fmtBytes);

      expect(restored.maxTokens, 2048);
      expect(restored.temperature, closeTo(0.5, 0.001));
      expect(restored.inputFormat, InferenceFormat.structured);
    });
  });

  // -----------------------------------------------------------------------
  // InferenceConfig.copyWith
  // -----------------------------------------------------------------------
  group('InferenceConfig.copyWith', () {
    test('preserves unchanged fields', () {
      final cfg = InferenceConfig(maxTokens: 1024, temperature: 0.7);
      final updated = cfg.copyWith(maxTokens: () => 2048);
      expect(updated.maxTokens, 2048);
      expect(updated.temperature, 0.7,
          reason: 'temperature unchanged');
    });

    test('nullable fields can be set to null', () {
      final cfg = InferenceConfig(maxTokens: 1024);
      final updated = cfg.copyWith(maxTokens: () => null);
      expect(updated.maxTokens, isNull);
    });

    test('defaults remain when copyWith not called', () {
      final cfg = InferenceConfig();
      expect(cfg.inputFormat, InferenceFormat.unstructured);
      expect(cfg.outputFormat, InferenceFormat.unstructured);
      expect(cfg.maxTokens, isNull);
    });
  });

  // -----------------------------------------------------------------------
  // Full JSON serialization round-trip (multi-turn conversation)
  // -----------------------------------------------------------------------
  group('Full conversation round-trip', () {
    test('multi-turn with tool use serializes faithfully', () {
      final messages = [
        InferenceMessage.system('You are a weather assistant.'),
        InferenceMessage.user('What is the weather in NYC?'),
        InferenceMessage(
          role: InferenceRole.assistant,
          content: [
            ThinkingContent(text: 'I should use the weather tool'),
            TextContent(text: 'Let me check that for you.'),
          ],
          functionCalls: [
            FunctionCall(
              id: 'call_1',
              name: 'get_weather',
              arguments: {'city': 'NYC'},
            ),
          ],
        ),
        InferenceMessage.functionResult(
          'call_1',
          [TextContent(text: '72F, sunny')],
        ),
        InferenceMessage(
          role: InferenceRole.assistant,
          content: [TextContent(text: 'It is 72F and sunny in NYC.')],
        ),
      ];

      // BEHAVIOR: serialize to JSON and back
      final jsonList = messages.map((m) => m.toJson()).toList();
      final jsonStr = jsonEncode(jsonList);
      final decoded = (jsonDecode(jsonStr) as List<dynamic>)
          .map((e) => InferenceMessage.fromJson(e as Map<String, dynamic>))
          .toList();

      // VERIFY: round-trip preserves everything
      expect(decoded.length, messages.length);
      for (var i = 0; i < messages.length; i++) {
        expect(decoded[i], messages[i],
            reason: 'message $i round-trip');
      }
    });
  });

  // -----------------------------------------------------------------------
  // InferenceOps type alias
  // -----------------------------------------------------------------------
  group('InferenceOps', () {
    test('type alias compiles with correct type parameters', () {
      // VERIFY: InferenceOps is usable as a type (compile-time check)
      InferenceOps? ops;
      expect(ops, isNull, reason: 'type alias exists and compiles');
    });
  });
}

// -- Test helpers --

Uint8List _int32Bytes(int value) {
  final bd = ByteData(4)..setInt32(0, value, Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List _float64Bytes(double value) {
  final bd = ByteData(8)..setFloat64(0, value, Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List _jsonBytes(Object value) =>
    Uint8List.fromList(utf8.encode(jsonEncode(value)));
