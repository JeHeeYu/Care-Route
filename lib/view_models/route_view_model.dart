import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/route/delete_book_mark_model.dart';
import '../models/route/get_book_mark_model.dart';
import '../models/route/set_book_mark_model.dart';
import '../networks/api_response.dart';
import '../networks/api_url.dart';
import '../networks/network_manager.dart';

class RouteViewModel with ChangeNotifier {
  ApiResponse<GetBookMarkModel> getBookMarkData = ApiResponse.loading();

  void setGetBookMarkData(ApiResponse<GetBookMarkModel> response) {
    getBookMarkData = response;
    notifyListeners();
  }

  ApiResponse<SetBookMarkModel> setBookMarkData = ApiResponse.loading();

  void setSetBookMarkData(ApiResponse<SetBookMarkModel> response) {
    setBookMarkData = response;
    notifyListeners();
  }

  ApiResponse<DeleteBookMarkModel> deleteBookMarkData = ApiResponse.loading();

  void setDelteBookMarkData(ApiResponse<DeleteBookMarkModel> response) {
    deleteBookMarkData = response;
    notifyListeners();
  }

  Future<int> getBookMark() async {
    try {
      final response = await NetworkManager.instance.get(ApiUrl.bookmark);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = GetBookMarkModel.fromJson(responseMap);

      setGetBookMarkData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setGetBookMarkData(ApiResponse.error(e.toString()));
      throw Exception("");
    }
  }

  Future<int> setBookMark(Map<String, dynamic> data) async {
    try {
      final response =
          await NetworkManager.instance.post(ApiUrl.bookmark, data);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = SetBookMarkModel.fromJson(responseMap);

      setSetBookMarkData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setSetBookMarkData(ApiResponse.error(e.toString()));
      return 400;
    }
  }

  Future<int> deleteBookMark(String delete) async {
    try {
      final response =
          await NetworkManager.instance.bookMarkDelete(ApiUrl.bookmark, delete);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = DeleteBookMarkModel.fromJson(responseMap);

      setDelteBookMarkData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setDelteBookMarkData(ApiResponse.error(e.toString()));
      return 400;
    }
  }
}
