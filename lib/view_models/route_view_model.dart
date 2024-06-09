import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/route/get_book_mark_model.dart';
import '../networks/api_response.dart';
import '../networks/api_url.dart';
import '../networks/network_manager.dart';

class RouteViewModel with ChangeNotifier {
  ApiResponse<GetBookMarkModel> bookMarkData = ApiResponse.loading();

  void setBookMarkData(ApiResponse<GetBookMarkModel> response) {
    bookMarkData = response;
    notifyListeners();
  }

  Future<int> getBookMark() async {
    try {
      final response =
          await NetworkManager.instance.get(ApiUrl.bookmark);
      final responseMap = jsonDecode(response) as Map<String, dynamic>;
      final json = GetBookMarkModel.fromJson(responseMap);

      setBookMarkData(ApiResponse.complete(json));
      return json.statusCode;
    } catch (e) {
      setBookMarkData(ApiResponse.error(e.toString()));
      return 400;
    }
  }
}
