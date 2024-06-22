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
      print("Jehee 1");
      return json.statusCode;
    } catch (e) {
      print("Jehee 2 ${e}");
      setMypageData(ApiResponse.error(e.toString()));
      return 400;
    }
  }

    Future<int> updateNickname(Map<String, dynamic> data) async {
    try {
      final response = await NetworkManager.instance.put(ApiUrl.nickname, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = MypageModel.fromJson(responseMap);

      setMypageData(ApiResponse.complete(json));
      print("Jehee 1");
      return json.statusCode;
    } catch (e) {
      print("Jehee 2 ${e}");
      setMypageData(ApiResponse.error(e.toString()));
      return 400;
    }
  }
}
