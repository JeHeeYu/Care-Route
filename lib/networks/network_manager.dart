import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../consts/strings.dart';

class NetworkManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> get commonHeaders async {
    String? idToken = await _storage.read(key: Strings.idTokenKey);
    print("Jehee idToken $idToken} ");
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "$idToken"
    };
  }

  static final NetworkManager _instance = NetworkManager._internal();

  NetworkManager._internal();

  static NetworkManager get instance => _instance;

  Future<dynamic> get(String serverUrl) async {
    dynamic responseJson;

    try {
      final response = await http.get(
        Uri.parse(serverUrl),
        headers: await commonHeaders,
      );

      responseJson = utf8.decode(response.bodyBytes);

      print("GET 성공: ${responseJson}");

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<dynamic> post(String serverUrl, Map<String, dynamic> userData) async {
    try {
      dynamic responseJson;
      String jsonData = jsonEncode(userData);

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: await commonHeaders,
        body: jsonData,
      );

      responseJson = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print("POST 성공: ${responseJson}");
      } else {
        print(
            "POST 실패: ${response.statusCode},   ${responseJson} ${response.body}");
      }

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<dynamic> put(String serverUrl, Map<String, dynamic> data) async {
    try {
      dynamic responseJson;
      String jsonData = jsonEncode(data);

      final response = await http.put(
        Uri.parse(serverUrl),
        headers: await commonHeaders,
        body: jsonData,
      );

      responseJson = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print("PUT 성공: ${responseJson}");
      } else {
        print(
            "PUT 실패: ${response.statusCode},   ${responseJson} ${response.body}");
      }

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<dynamic> bookMarkDelete(String serverUrl, String postId) async {
    dynamic responseJson;

    try {
      final uri = Uri.parse('$serverUrl/$postId');

      final response = await http.delete(
        uri,
        headers: await commonHeaders,
      );

      responseJson = utf8.decode(response.bodyBytes);

      print("DELETE 성공: ${responseJson}");

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }
}
