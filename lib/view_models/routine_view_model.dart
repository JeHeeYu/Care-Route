import 'dart:convert';

import 'package:care_route/models/routine/target_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/routine/schedule_list_model.dart';
import '../networks/api_response.dart';
import '../networks/api_url.dart';
import '../networks/network_manager.dart';

class RoutineViewModel with ChangeNotifier {
  ApiResponse<TargetListModel> targetList = ApiResponse.loading();
  ApiResponse<ScheduleListModel> scheduleList = ApiResponse.loading();

  void setTargetList(ApiResponse<TargetListModel> response) {
    targetList = response;
    notifyListeners();
  }

    void setScheduleList(ApiResponse<ScheduleListModel> response) {
    scheduleList = response;
    notifyListeners();
  }

  Future<int> getTargetList() async {
    try {
      final response = await NetworkManager.instance.get(ApiUrl.targetList);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = TargetListModel.fromJson(responseMap);

      setTargetList(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setTargetList(ApiResponse.error(e.toString()));
      throw Exception("");
    }
  }

  Future<int> getScheduleList() async {
    try {
      final response = await NetworkManager.instance.get(ApiUrl.scheduleList);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = ScheduleListModel.fromJson(responseMap);

      setScheduleList(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setScheduleList(ApiResponse.error(e.toString()));
      throw Exception("");
    }
  }
}
