/// Driver socket as a [StreamChannel<Uint8List>] with length-prefixed framing.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:stream_channel/stream_channel.dart';

import 'length_prefixed.dart';
import 'socket_sink.dart';

/// Connect to a driver endpoint and return a framed [StreamChannel].
///
/// Supports `unix://` (Unix domain socket) and `tcp://host:port` schemes.
/// The returned channel speaks length-prefixed protobuf messages.
Future<StreamChannel<Uint8List>> connectDriver(Uri endpoint) async {
  final Socket socket;
  switch (endpoint.scheme) {
    case 'unix':
      socket = await Socket.connect(
        InternetAddress(endpoint.path, type: InternetAddressType.unix),
        0,
      );
    case 'tcp':
      socket = await Socket.connect(endpoint.host, endpoint.port);
    default:
      throw ArgumentError.value(
        endpoint,
        'endpoint',
        'Unsupported scheme: ${endpoint.scheme}',
      );
  }

  final raw = StreamChannel<Uint8List>(
    socket.cast<Uint8List>(),
    SocketSink(socket),
  );
  return raw.transform(lengthPrefixedTransformer());
}
