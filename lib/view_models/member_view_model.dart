import 'dart:convert';

import 'package:care_route/models/member/auth_model.dart';
import 'package:care_route/models/member/type_model.dart';
import 'package:care_route/networks/api_url.dart';
import 'package:flutter/cupertino.dart';

import '../models/member/login_model.dart';
import '../networks/api_response.dart';
import '../networks/network_manager.dart';

class MemberViewModel with ChangeNotifier {
  ApiResponse<LoginModel> loginData = ApiResponse.loading();
  ApiResponse<TypeModel> typeData = ApiResponse.loading();
  ApiResponse<AuthModel> authData = ApiResponse.loading();

  void setLoginData(ApiResponse<LoginModel> response) {
    loginData = response;
    notifyListeners();
  }

  void setTypeData(ApiResponse<TypeModel> response) {
    typeData = response;
    notifyListeners();
  }

  void setAuthData(ApiResponse<AuthModel> response) {
    authData = response;
    notifyListeners();
  }

  Future<int> login(Map<String, dynamic> data) async {
    try {
      final response = await NetworkManager.instance.post(ApiUrl.login, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = LoginModel.fromJson(responseMap);

      setLoginData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setLoginData(ApiResponse.error(e.toString()));
      return 400;
    }
  }

  Future<int> type(Map<String, dynamic> data) async {
    try {
      final response = await NetworkManager.instance.post(ApiUrl.type, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = TypeModel.fromJson(responseMap);

      setTypeData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setTypeData(ApiResponse.error(e.toString()));
      return 400;
    }
  }

  Future<int> auth(Map<String, dynamic> data) async {
    try {
      final response = await NetworkManager.instance.post(ApiUrl.auth, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = AuthModel.fromJson(responseMap);

      setAuthData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setAuthData(ApiResponse.error(e.toString()));
      return 400;
    }
  }
}
