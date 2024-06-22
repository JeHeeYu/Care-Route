import 'dart:convert';

import 'package:care_route/models/mypage/mypage_model.dart';
import 'package:flutter/cupertino.dart';

import '../networks/api_response.dart';
import '../networks/api_url.dart';
import '../networks/network_manager.dart';

class MypageViewModel with ChangeNotifier {
  ApiResponse<MypageModel> getMypageData = ApiResponse.loading();

  void setMypageData(ApiResponse<MypageModel> response) {
    getMypageData = response;
    notifyListeners();
  }

  Future<int> getMypage() async {
    try {
      final response = await NetworkManager.instance.get(ApiUrl.mypage);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = MypageModel.fromJson(responseMap);

      setMypageData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setMypageData(ApiResponse.error(e.toString()));
      return 400;
    }
  }
}
