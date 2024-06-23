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
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load route');
    }
  }
}
