import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkManager {
  Map<String, String> commonHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static final NetworkManager _instance = NetworkManager._internal();

  NetworkManager._internal();

  static NetworkManager get instance => _instance;


  Future<dynamic> post(String serverUrl, Map<String, dynamic> userData) async {
    try {
      dynamic responseJson;
      String jsonData = jsonEncode(userData);

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: commonHeaders,
        body: jsonData,
      );

      responseJson = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print("POST 성공: ${responseJson}");
      } else {
        print("POST 실패: ${response.statusCode},   ${responseJson} ${response}");
      }

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }
}