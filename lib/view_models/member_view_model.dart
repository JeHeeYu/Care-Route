import 'dart:convert';

import 'package:care_route/models/member/type_model.dart';
import 'package:care_route/networks/api_url.dart';
import 'package:flutter/cupertino.dart';

import '../models/member/login_model.dart';
import '../networks/api_response.dart';
import '../networks/network_manager.dart';

class MemberViewModel with ChangeNotifier {
  ApiResponse<LoginModel> loginData = ApiResponse.loading();
  ApiResponse<TypeModel> typeData = ApiResponse.loading();

  void setLoginData(ApiResponse<LoginModel> response) {
    loginData = response;
    notifyListeners();
  }

  void setTypeData(ApiResponse<TypeModel> response) {
    typeData = response;
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

  Future<void> fetchTypeData(Map<String, dynamic> data) async {
    try {
      final response = await NetworkManager.instance.post(ApiUrl.login, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = TypeModel.fromJson(responseMap);
      
      setTypeData(ApiResponse.complete(json));
    } catch (e) {
      setTypeData(ApiResponse.error(e.toString()));
    }
  }
}
