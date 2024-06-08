import 'dart:convert';

import 'package:care_route/networks/api_url.dart';
import 'package:flutter/cupertino.dart';

import '../models/login/login_model.dart';
import '../networks/api_response.dart';
import '../networks/network_manager.dart';

class LoginViewModel with ChangeNotifier {
  ApiResponse<LoginModel> loginData = ApiResponse.loading();

  void setLoginData(ApiResponse<LoginModel> response) {
    loginData = response;
  }

  Future<void> login(Map<String, dynamic> data) async {
    try {
      final response = await NetworkManager.instance.post(ApiUrl.login, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = LoginModel.fromJson(responseMap);
    } catch (e) {}
  }
}
