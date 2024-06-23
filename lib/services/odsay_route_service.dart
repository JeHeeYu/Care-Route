import 'dart:convert';
import 'package:http/http.dart' as http;

class OdsayRouteService {
  static final String _apiKey =
      '1NAlNUaJX3+UuP0N0Dz5iyw7FpDpnozIN7Dw1erONkY';

  static Future<Map<String, dynamic>> fetchRoute(
      double startX, double startY, double endX, double endY) async {
    final String url =
        'https://api.odsay.com/v1/api/searchPubTransPathT?SX=$startX&SY=$startY&EX=$endX&EY=$endY&apiKey=${Uri.encodeComponent(_apiKey)}';

    final response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("Jehee data ${data}");

      // print 로그 추가
      // print("subwayBusCount: ${data['result']['subwayBusCount']}");
      print("pathType: ${data['result']['path'][0]['pathType']}");
      print("totalTime: ${data['result']['path'][0]['info']['totalTime']}");
      print("trafficType: ${data['result']['path'][0]['subPath'][0]['trafficType']}");
      
      // Check if the first subPath is a bus
      if (data['result']['path'][0]['subPath'][0]['trafficType'] == 2) {
        print("busNo: ${data['result']['path'][0]['subPath'][0]['lane'][0]['busNo']}");
        print("type: ${data['result']['path'][0]['subPath'][0]['lane'][0]['type']}");
        print("busID: ${data['result']['path'][0]['subPath'][0]['lane'][0]['busID']}");
      }

      return data;
    } else {
      throw Exception('Failed to load route');
    }
  }
}
