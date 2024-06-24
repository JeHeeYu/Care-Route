import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  WebSocketChannel? _channel;

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  void connect(String url) {
    if (_channel != null) {
      print('WebSocket is already connected');
      return;
    } else {
      print("WebSocket Connected!");
    }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel?.stream.listen(
        (message) {
          print('Received message: $message');
        },
        onDone: () {
          print('WebSocket connection closed');
          _channel = null;
        },
        onError: (error) {
          print('WebSocket error: $error');
          _channel = null;
        },
      );
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  }

  void sendMessage(String path, String message) {
    if (_channel != null) {
      var formattedMessage = jsonEncode({'path': path, 'message': message});
      _channel?.sink.add(formattedMessage);
    } else {
      print('WebSocket is not connected');
    }
  }

  void close() {
    _channel?.sink.close();
    _channel = null;
  }
}