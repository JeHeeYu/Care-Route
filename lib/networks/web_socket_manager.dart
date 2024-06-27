import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  IO.Socket? _socket;
  String _url = 'http://localhost:4000'; // 프로토콜 추가

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  void setUrl(String url) {
    _url = url;
  }

  void connect(String userId) {
    if (_socket != null) {
      print('Socket.IO is already connected');
      return;
    }

    try {
      _socket = IO.io(_url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false, // autoConnect를 false로 설정하고 수동으로 connect를 호출합니다.
      });

      _socket!.on('connect', (_) {
        print('Socket.IO Connected!');
        // 서버에 사용자 ID를 등록합니다.
        _socket!.emit('register', userId);
      });

      _socket!.on('disconnect', (_) {
        print('Socket.IO Disconnected');
        _socket = null;
      });

      _socket!.on('error', (error) {
        print('Socket.IO error: $error');
        _socket = null;
      });

      _socket!.on('receive_message', (data) {
        print('Received message: ${data['message']}');
      });

      _socket!.connect(); // 소켓 연결을 수동으로 시작합니다.
    } catch (e) {
      print('Socket.IO connection error: $e');
    }
  }

  void sendMessage(String to, String message) {
    if (_socket != null) {
      var messageData = {'to': to, 'message': message};
      print('Sending message:');
      _socket!.emit('send_message', messageData);
    } else {
      print('Socket.IO is not connected');
    }
  }

  void close() {
    _socket?.disconnect();
    _socket = null;
  }
}
