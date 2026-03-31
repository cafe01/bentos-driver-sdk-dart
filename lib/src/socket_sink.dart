/// Adapts a [Socket] to a [StreamSink<Uint8List>].
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

final class SocketSink implements StreamSink<Uint8List> {
  SocketSink(this._socket);
  final Socket _socket;

  @override
  void add(Uint8List data) => _socket.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _socket.addError(error, stackTrace);

  @override
  Future<void> addStream(Stream<Uint8List> stream) async {
    await for (final chunk in stream) {
      _socket.add(chunk);
    }
  }

  @override
  Future<void> close() => _socket.close();

  @override
  Future<void> get done => _socket.done;
}
