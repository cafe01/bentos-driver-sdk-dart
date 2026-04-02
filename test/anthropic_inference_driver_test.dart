import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart' as anthropic;
import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// SSE helpers — build canned Anthropic streaming responses
// ---------------------------------------------------------------------------

String _sseEvent(Map<String, dynamic> event) =>
    'event: ${event['type']}\ndata: ${jsonEncode(event)}\n\n';

/// Minimal text streaming response: message_start, text deltas, message_delta, stop.
String _textStreamResponse({
  String model = 'claude-sonnet-4-20250514',
  List<String> textChunks = const ['Hello', ', ', 'world!'],
  String stopReason = 'end_turn',
  int inputTokens = 10,
  int outputTokens = 15,
}) {
  final buf = StringBuffer();
  buf.write(_sseEvent({
    'type': 'message_start',
    'message': {
      'id': 'msg_001',
      'type': 'message',
      'role': 'assistant',
      'model': model,
      'content': [],
      'stop_reason': null,
      'stop_sequence': null,
      'usage': {
        'input_tokens': inputTokens,
        'output_tokens': 0,
      },
    },
  }));
  buf.write(_sseEvent({
    'type': 'content_block_start',
    'index': 0,
    'content_block': {'type': 'text', 'text': ''},
  }));
  buf.write(_sseEvent({'type': 'ping'}));
  for (final chunk in textChunks) {
    buf.write(_sseEvent({
      'type': 'content_block_delta',
      'index': 0,
      'delta': {'type': 'text_delta', 'text': chunk},
    }));
  }
  buf.write(_sseEvent({
    'type': 'content_block_stop',
    'index': 0,
  }));
  buf.write(_sseEvent({
    'type': 'message_delta',
    'delta': {'stop_reason': stopReason, 'stop_sequence': null},
    'usage': {'output_tokens': outputTokens},
  }));
  buf.write(_sseEvent({'type': 'message_stop'}));
  return buf.toString();
}

String _toolUseStreamResponse() {
  final buf = StringBuffer();
  buf.write(_sseEvent({
    'type': 'message_start',
    'message': {
      'id': 'msg_002',
      'type': 'message',
      'role': 'assistant',
      'model': 'claude-sonnet-4-20250514',
      'content': [],
      'stop_reason': null,
      'stop_sequence': null,
      'usage': {'input_tokens': 20, 'output_tokens': 0},
    },
  }));
  // Tool use content block.
  buf.write(_sseEvent({
    'type': 'content_block_start',
    'index': 0,
    'content_block': {
      'type': 'tool_use',
      'id': 'toolu_01',
      'name': 'get_weather',
      'input': {},
    },
  }));
  buf.write(_sseEvent({
    'type': 'content_block_delta',
    'index': 0,
    'delta': {'type': 'input_json_delta', 'partial_json': '{"city":'},
  }));
  buf.write(_sseEvent({
    'type': 'content_block_delta',
    'index': 0,
    'delta': {'type': 'input_json_delta', 'partial_json': '"SF"}'},
  }));
  buf.write(_sseEvent({
    'type': 'content_block_stop',
    'index': 0,
  }));
  buf.write(_sseEvent({
    'type': 'message_delta',
    'delta': {'stop_reason': 'tool_use', 'stop_sequence': null},
    'usage': {'output_tokens': 30},
  }));
  buf.write(_sseEvent({'type': 'message_stop'}));
  return buf.toString();
}

String _thinkingStreamResponse() {
  final buf = StringBuffer();
  buf.write(_sseEvent({
    'type': 'message_start',
    'message': {
      'id': 'msg_003',
      'type': 'message',
      'role': 'assistant',
      'model': 'claude-sonnet-4-20250514',
      'content': [],
      'stop_reason': null,
      'stop_sequence': null,
      'usage': {'input_tokens': 5, 'output_tokens': 0},
    },
  }));
  // Thinking block.
  buf.write(_sseEvent({
    'type': 'content_block_start',
    'index': 0,
    'content_block': {'type': 'thinking', 'thinking': ''},
  }));
  buf.write(_sseEvent({
    'type': 'content_block_delta',
    'index': 0,
    'delta': {'type': 'thinking_delta', 'thinking': 'Let me think...'},
  }));
  buf.write(_sseEvent({
    'type': 'content_block_stop',
    'index': 0,
  }));
  // Then text block.
  buf.write(_sseEvent({
    'type': 'content_block_start',
    'index': 1,
    'content_block': {'type': 'text', 'text': ''},
  }));
  buf.write(_sseEvent({
    'type': 'content_block_delta',
    'index': 1,
    'delta': {'type': 'text_delta', 'text': 'The answer is 42.'},
  }));
  buf.write(_sseEvent({
    'type': 'content_block_stop',
    'index': 1,
  }));
  buf.write(_sseEvent({
    'type': 'message_delta',
    'delta': {'stop_reason': 'end_turn', 'stop_sequence': null},
    'usage': {'output_tokens': 50},
  }));
  buf.write(_sseEvent({'type': 'message_stop'}));
  return buf.toString();
}

String _errorResponse(int statusCode, String type, String message) =>
    jsonEncode({
      'type': 'error',
      'error': {'type': type, 'message': message},
    });

// ---------------------------------------------------------------------------
// Mock HTTP client that returns canned SSE
// ---------------------------------------------------------------------------

http.Client _mockClient(String sseBody, {int statusCode = 200}) {
  return http_testing.MockClient.streaming(
    (request, bodyStream) async {
      // Consume the request body.
      await bodyStream.drain<void>();
      final bytes = utf8.encode(sseBody);
      return http.StreamedResponse(
        Stream.value(bytes),
        statusCode,
        headers: {'content-type': 'text/event-stream'},
      );
    },
  );
}

http.Client _mockErrorClient(int statusCode, String body) {
  return http_testing.MockClient.streaming(
    (request, bodyStream) async {
      await bodyStream.drain<void>();
      return http.StreamedResponse(
        Stream.value(utf8.encode(body)),
        statusCode,
        headers: {'content-type': 'application/json'},
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Helper to create ops with mocked HTTP
// ---------------------------------------------------------------------------

InferenceOps _opsWithMock(String sseBody, {
  String model = 'claude-sonnet-4-20250514',
  int statusCode = 200,
}) {
  final httpClient = _mockClient(sseBody, statusCode: statusCode);
  final client = anthropic.AnthropicClient(
    apiKey: 'test-key',
    client: httpClient,
    retries: 0,
  );
  return anthropicInferenceOps(
    apiKey: 'test-key',
    model: model,
    client: client,
  );
}

InferenceOps _opsWithErrorMock(int statusCode, String body, {
  String model = 'claude-sonnet-4-20250514',
}) {
  final httpClient = _mockErrorClient(statusCode, body);
  final client = anthropic.AnthropicClient(
    apiKey: 'test-key',
    client: httpClient,
    retries: 0,
  );
  return anthropicInferenceOps(
    apiKey: 'test-key',
    model: model,
    client: client,
  );
}

void main() {
  group('anthropicInferenceOps', () {
    test('defaultConfig returns InferenceConfig with defaults', () {
      final ops = _opsWithMock('');
      final config = ops.defaultConfig();
      expect(config.inputFormat, InferenceFormat.unstructured);
      expect(config.outputFormat, InferenceFormat.unstructured);
      expect(config.maxTokens, isNull);
    });

    test('onSessionStart returns InferenceSession with model', () async {
      final ops = _opsWithMock('');
      final session = await ops.onSessionStart!();
      expect(session.model, 'claude-sonnet-4-20250514');
    });

    test('encodeOutput is the subsystem default', () {
      final ops = _opsWithMock('');
      final config = const InferenceConfig(
        outputFormat: InferenceFormat.unstructured,
      );
      final result = ops.encodeOutput!(
        const TextDelta(text: 'hi'),
        config: config,
      );
      expect(utf8.decode(result), 'hi');
    });

    test('decodeInput is the subsystem default', () {
      final ops = _opsWithMock('');
      final config = const InferenceConfig(
        inputFormat: InferenceFormat.unstructured,
      );
      final result = ops.decodeInput!(
        Uint8List.fromList(utf8.encode('hello')),
        config: config,
      );
      expect(result, hasLength(1));
      expect(result[0].role, InferenceRole.user);
    });
  });

  group('process — text streaming', () {
    test('yields TextDelta chunks followed by CompleteChunk', () async {
      final ops = _opsWithMock(_textStreamResponse());
      final session = await ops.onSessionStart!();
      final config = ops.defaultConfig();
      final messages = [InferenceMessage.user('Hello')];

      final chunks = await ops.process(messages, config, session: session)
          .toList();

      // Should get 3 TextDeltas + 1 CompleteChunk.
      expect(chunks.whereType<TextDelta>().map((d) => d.text).toList(),
          ['Hello', ', ', 'world!']);

      final complete = chunks.whereType<CompleteChunk>().single;
      expect(complete.metadata.model, 'claude-sonnet-4-20250514');
      expect(complete.metadata.stopReason, StopReason.endTurn);
      expect(complete.metadata.usage?.inputTokens, 10);
      expect(complete.metadata.usage?.outputTokens, 15);
    });

    test('session.lastMetadata is populated after stream completes', () async {
      final ops = _opsWithMock(_textStreamResponse());
      final session = await ops.onSessionStart!();
      final config = ops.defaultConfig();

      await ops.process(
        [InferenceMessage.user('Hi')],
        config,
        session: session,
      ).drain<void>();

      expect(session.lastMetadata, isNotNull);
      expect(session.lastMetadata!.model, 'claude-sonnet-4-20250514');
      expect(session.lastMetadata!.stopReason, StopReason.endTurn);
    });
  });

  group('process — tool use', () {
    test('yields ToolCallStart and ToolCallDelta chunks', () async {
      final ops = _opsWithMock(_toolUseStreamResponse());
      final session = await ops.onSessionStart!();
      final config = ops.defaultConfig();

      final chunks = await ops.process(
        [InferenceMessage.user('Weather?')],
        config,
        session: session,
      ).toList();

      final starts = chunks.whereType<ToolCallStart>().toList();
      expect(starts, hasLength(1));
      expect(starts[0].id, 'toolu_01');
      expect(starts[0].name, 'get_weather');

      final deltas = chunks.whereType<ToolCallDelta>().toList();
      expect(deltas, hasLength(2));
      expect(deltas[0].id, 'toolu_01');
      expect(deltas[0].argumentsDelta, '{"city":');
      expect(deltas[1].argumentsDelta, '"SF"}');

      final complete = chunks.whereType<CompleteChunk>().single;
      expect(complete.metadata.stopReason, StopReason.toolUse);
    });
  });

  group('process — thinking', () {
    test('yields ThinkingDelta then TextDelta chunks', () async {
      final ops = _opsWithMock(_thinkingStreamResponse());
      final session = await ops.onSessionStart!();
      final config = ops.defaultConfig();

      final chunks = await ops.process(
        [InferenceMessage.user('What is the meaning of life?')],
        config,
        session: session,
      ).toList();

      final thinking = chunks.whereType<ThinkingDelta>().toList();
      expect(thinking, hasLength(1));
      expect(thinking[0].text, 'Let me think...');

      final text = chunks.whereType<TextDelta>().toList();
      expect(text, hasLength(1));
      expect(text[0].text, 'The answer is 42.');
    });
  });

  group('process — errors', () {
    test('401 maps to authentication error', () async {
      final ops = _opsWithErrorMock(
        401,
        _errorResponse(401, 'authentication_error', 'Invalid API key'),
      );
      final session = await ops.onSessionStart!();
      final config = ops.defaultConfig();

      expect(
        () => ops.process(
          [InferenceMessage.user('Hi')],
          config,
          session: session,
        ).drain<void>(),
        throwsA(isA<DriverError>()),
      );
    });

    test('429 maps to rate limited error', () async {
      final ops = _opsWithErrorMock(
        429,
        _errorResponse(429, 'rate_limit_error', 'Rate limited'),
      );
      final session = await ops.onSessionStart!();

      try {
        await ops.process(
          [InferenceMessage.user('Hi')],
          ops.defaultConfig(),
          session: session,
        ).drain<void>();
        fail('Should have thrown');
      } on DriverError {
        // Expected.
        expect(session.lastError, isNotNull);
        expect(session.lastError!.kind, InferenceErrorKind.rateLimited);
        expect(session.lastError!.kind.isRetryable, isTrue);
      }
    });

    test('500 maps to server error', () async {
      final ops = _opsWithErrorMock(
        500,
        _errorResponse(500, 'api_error', 'Internal server error'),
      );
      final session = await ops.onSessionStart!();

      try {
        await ops.process(
          [InferenceMessage.user('Hi')],
          ops.defaultConfig(),
          session: session,
        ).drain<void>();
        fail('Should have thrown');
      } on DriverError {
        expect(session.lastError!.kind, InferenceErrorKind.serverError);
        expect(session.lastError!.kind.isRetryable, isTrue);
      }
    });

    test('529 maps to overloaded error', () async {
      final ops = _opsWithErrorMock(
        529,
        _errorResponse(529, 'overloaded_error', 'API is overloaded'),
      );
      final session = await ops.onSessionStart!();

      try {
        await ops.process(
          [InferenceMessage.user('Hi')],
          ops.defaultConfig(),
          session: session,
        ).drain<void>();
        fail('Should have thrown');
      } on DriverError {
        expect(session.lastError!.kind, InferenceErrorKind.overloaded);
        expect(session.lastError!.kind.isRetryable, isTrue);
      }
    });
  });

  group('process — config mapping', () {
    test('system prompt from config is sent', () async {
      // We verify by checking the response processes without error.
      // The mock doesn't validate the request body, but this exercises
      // the config-to-request mapping path.
      final ops = _opsWithMock(_textStreamResponse());
      final session = await ops.onSessionStart!();
      final config = const InferenceConfig(system: 'You are a pirate.');

      final chunks = await ops.process(
        [InferenceMessage.user('Ahoy')],
        config,
        session: session,
      ).toList();

      expect(chunks.whereType<TextDelta>(), isNotEmpty);
    });

    test('system from messages extracted when config.system is null', () async {
      final ops = _opsWithMock(_textStreamResponse());
      final session = await ops.onSessionStart!();
      final config = ops.defaultConfig();

      final chunks = await ops.process(
        [
          InferenceMessage.system('Be helpful.'),
          InferenceMessage.user('Hi'),
        ],
        config,
        session: session,
      ).toList();

      expect(chunks.whereType<CompleteChunk>(), hasLength(1));
    });

    test('stop reason max_tokens is mapped correctly', () async {
      final ops = _opsWithMock(_textStreamResponse(stopReason: 'max_tokens'));
      final session = await ops.onSessionStart!();

      final chunks = await ops.process(
        [InferenceMessage.user('Hi')],
        ops.defaultConfig(),
        session: session,
      ).toList();

      final complete = chunks.whereType<CompleteChunk>().single;
      expect(complete.metadata.stopReason, StopReason.maxTokens);
    });
  });

  group('onQuery', () {
    test('getMetadata returns session metadata as JSON', () async {
      final ops = _opsWithMock(_textStreamResponse());
      final session = await ops.onSessionStart!();

      // Process to populate lastMetadata.
      await ops.process(
        [InferenceMessage.user('Hi')],
        ops.defaultConfig(),
        session: session,
      ).drain<void>();

      final result = await ops.onQuery!(LlmIoctl.getMetadata, session: session);
      final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
      expect(json['model'], 'claude-sonnet-4-20250514');
      expect(json['stop_reason'], 'end_turn');
    });

    test('getError returns empty JSON when no error', () async {
      final ops = _opsWithMock(_textStreamResponse());
      final session = await ops.onSessionStart!();

      final result = await ops.onQuery!(LlmIoctl.getError, session: session);
      final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
      expect(json, isEmpty);
    });

    test('getInfo returns capabilities', () async {
      final ops = _opsWithMock('', model: 'claude-opus-4-20250514');
      final session = await ops.onSessionStart!();

      final result = await ops.onQuery!(LlmIoctl.getInfo, session: session);
      final json = jsonDecode(utf8.decode(result)) as Map<String, dynamic>;
      expect(json['model'], 'claude-opus-4-20250514');
      expect(json['provider'], 'anthropic');
      expect(json['supports_thinking'], isTrue);
      expect(json['supports_tools'], isTrue);
    });

    test('unknown query throws DriverError', () async {
      final ops = _opsWithMock('');
      final session = await ops.onSessionStart!();

      expect(
        () => ops.onQuery!(0xFF, session: session),
        throwsA(isA<DriverError>()),
      );
    });
  });
}
