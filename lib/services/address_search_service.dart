import 'dart:convert';

import '../networks/network_manager.dart';

class AddressSearchService {
  static const String _apiUrl = 'https://business.juso.go.kr/addrlink/addrLinkApiJsonp.do';
  static const String _confmKey = 'devU01TX0FVVEgyMDI0MDYyMDIyMjk1NzExNDg1ODM=';

  static Future<Map<String, dynamic>> searchAddress(String keyword) async {
    String requestUrl = '$_apiUrl?confmKey=$_confmKey&currentPage=1&countPerPage=10&keyword=$keyword&resultType=json';

    try {
      final responseJson = await NetworkManager.instance.get(requestUrl);
      
      final jsonResponse = json.decode(responseJson.substring(responseJson.indexOf('(') + 1, responseJson.lastIndexOf(')')));
      return jsonResponse;
    } catch (error) {
      print("에러 발생: $error");
      throw Exception('Failed to load address');
    }
  }
}
