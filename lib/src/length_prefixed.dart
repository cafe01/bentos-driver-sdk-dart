/// Length-prefixed framing for [StreamChannel<Uint8List>].
///
/// Frame format: [4B big-endian uint32 length][payload bytes]
///
/// Encoder: prepends length prefix to each outgoing message.
/// Decoder: accumulates incoming bytes, emits complete payloads.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:stream_channel/stream_channel.dart';

/// Transforms a raw byte [StreamChannel] into a message-framed channel.
///
/// Each logical message becomes `[4B length][payload]` on the wire.
/// Incoming bytes are buffered and split on frame boundaries.
StreamChannelTransformer<Uint8List, Uint8List> lengthPrefixedTransformer() {
  return StreamChannelTransformer<Uint8List, Uint8List>(
    _decoder(),
    _encoder(),
  );
}

/// Decodes a stream of raw bytes into discrete length-prefixed messages.
StreamTransformer<Uint8List, Uint8List> _decoder() {
  return StreamTransformer<Uint8List, Uint8List>.fromHandlers(
    handleData: _DecoderState().handleData,
  );
}

/// Encodes outgoing messages by prepending a 4-byte big-endian length.
StreamSinkTransformer<Uint8List, Uint8List> _encoder() {
  return StreamSinkTransformer<Uint8List, Uint8List>.fromStreamTransformer(
    StreamTransformer<Uint8List, Uint8List>.fromHandlers(
      handleData: (data, sink) {
        final frame = Uint8List(4 + data.length);
        final view = ByteData.sublistView(frame);
        view.setUint32(0, data.length, Endian.big);
        frame.setRange(4, frame.length, data);
        sink.add(frame);
      },
    ),
  );
}

final class _DecoderState {
  final _chunks = <Uint8List>[];
  int _buffered = 0;

  void handleData(Uint8List data, EventSink<Uint8List> sink) {
    _chunks.add(data);
    _buffered += data.length;
    _drain(sink);
  }

  void _drain(EventSink<Uint8List> sink) {
    while (true) {
      if (_buffered < 4) return;

      final header = _peek(4);
      final length = ByteData.sublistView(header).getUint32(0, Endian.big);
      final total = 4 + length;

      if (_buffered < total) return;

      // Skip the 4-byte header, then extract the payload.
      _consume(4);
      final payload = _consume(length);
      sink.add(payload);
    }
  }

  /// Peek at the first [n] bytes without consuming.
  Uint8List _peek(int n) {
    if (_chunks.first.length >= n) {
      return Uint8List.sublistView(_chunks.first, 0, n);
    }
    final buf = Uint8List(n);
    var offset = 0;
    for (final chunk in _chunks) {
      final take = (offset + chunk.length <= n) ? chunk.length : n - offset;
      buf.setRange(offset, offset + take, chunk);
      offset += take;
      if (offset >= n) break;
    }
    return buf;
  }

  /// Consume and return the first [n] bytes.
  Uint8List _consume(int n) {
    _buffered -= n;
    final buf = Uint8List(n);
    var offset = 0;
    while (offset < n) {
      final chunk = _chunks.first;
      final take =
          (offset + chunk.length <= n) ? chunk.length : n - offset;
      buf.setRange(offset, offset + take, chunk);
      offset += take;
      if (take == chunk.length) {
        _chunks.removeAt(0);
      } else {
        _chunks[0] = Uint8List.sublistView(chunk, take);
      }
    }
    return buf;
  }
}
