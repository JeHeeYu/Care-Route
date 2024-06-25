import 'dart:convert';

import 'package:care_route/models/routine/target_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/routine/add_schedule_model.dart';
import '../models/routine/delete_target_model.dart';
import '../models/routine/schedule_list_model.dart';
import '../networks/api_response.dart';
import '../networks/api_url.dart';
import '../networks/network_manager.dart';

class RoutineViewModel with ChangeNotifier {
  ApiResponse<TargetListModel> targetList = ApiResponse.loading();
  ApiResponse<ScheduleListModel> scheduleList = ApiResponse.loading();
  ApiResponse<AddScheduleModel> addScheduleData = ApiResponse.loading();
  ApiResponse<DeleteTargetModel> deleteTarget = ApiResponse.loading();

  void setTargetList(ApiResponse<TargetListModel> response) {
    targetList = response;
    notifyListeners();
  }

  void setScheduleList(ApiResponse<ScheduleListModel> response) {
    scheduleList = response;
    notifyListeners();
  }

  void addScheduleList(ApiResponse<AddScheduleModel> response) {
    addScheduleData = response;
    notifyListeners();
  }

    void setDeleteTarget(ApiResponse<DeleteTargetModel> response) {
    deleteTarget = response;
    notifyListeners();
  }

  Future<int> getTargetList() async {
    try {
      final response = await NetworkManager.instance.get(ApiUrl.targetList);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = TargetListModel.fromJson(responseMap);
      notifyListeners();
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
      notifyListeners();
      setScheduleList(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setScheduleList(ApiResponse.error(e.toString()));
      throw Exception("");
    }
  }

  Future<int> registSchedule(Map<String, dynamic> data) async {
    try {
      final response =
          await NetworkManager.instance.post(ApiUrl.scheduleRegist, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = AddScheduleModel.fromJson(responseMap);
      notifyListeners();
      addScheduleList(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      addScheduleList(ApiResponse.error(e.toString()));
      throw Exception("");
    }
  }

  Future<int> targetDelete(Map<String, dynamic> data) async {
    try {
      final response =
          await NetworkManager.instance.post(ApiUrl.deleteTarget, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = DeleteTargetModel.fromJson(responseMap);
      notifyListeners();
      setDeleteTarget(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setDeleteTarget(ApiResponse.error(e.toString()));
      throw Exception("");
    }
  }
}
