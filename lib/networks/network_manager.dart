import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../consts/strings.dart';

class NetworkManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> get commonHeaders async {
    String? idToken = await _storage.read(key: Strings.idTokenKey);
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
          "eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyMDA5NTEzZTg4MjY2YjA3YTE1YWQ0NTc4ZDJlYWNlZSIsInN1YiI6IjM1MTc0OTA1OTAiLCJhdXRoX3RpbWUiOjE3MTc5MTMzNzQsImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwibmlja25hbWUiOiLsnKDsoJztnawiLCJleHAiOjE3MTc5NTY1NzQsImlhdCI6MTcxNzkxMzM3NCwicGljdHVyZSI6Imh0dHA6Ly90MS5rYWthb2Nkbi5uZXQvYWNjb3VudF9pbWFnZXMvZGVmYXVsdF9wcm9maWxlLmpwZWcudHdnLnRodW1iLlIxMTB4MTEwIn0.mjOAXQTUs51VVD9Tn7EJQ7m3h4DB-rFJm5jpt17kT5e4QvHMWCkFn0glNAXfdgCpDaOWRv7wytyJlwFNuMKz6tcWl3_RGG8Y98PP_Q7gWsHc8U-fF_uz19UxYa1CjuhRk5al5wjydI-W6zBOslNtlBHsFA1Kxgs6Rf9CrVzQu0LaMFKig6Koi6Ci8r1I6i7Mu_qKDFonPSeUmUVKhCt9aHkYgdycDESd3OldvbI2GUBS22W5bFPSxVhvRK5dy8Me2NRUETf7JOpBM1eJV0Ki3pRJHWBtBRC-XPlyTHpwHisQJ1eq7Wrg7mrcf2mKq0kQu6U-Qk0LLtAPzUyxCP_I7w"
      //;"$idToken"
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
        print("POST 실패: ${response.statusCode},   ${responseJson} ${response}");
      }

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }
}
