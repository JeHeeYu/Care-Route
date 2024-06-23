import 'package:http/http.dart' as http;
import 'dart:convert';

class TMapSearchService {
  static const String _apiKey = 'w8qRXuuGFx3XB1ELc5Y278RPC3TkSnMO5G9ovdtN';

  static Future<Map<String, dynamic>> fetchRoute(double startX, double startY, double endX, double endY) async {
    final url = Uri.parse('https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&callback=function');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'appKey': _apiKey,
      },
      body: json.encode({
        'startX': startX.toString(),
        'startY': startY.toString(),
        'endX': endX.toString(),
        'endY': endY.toString(),
        'reqCoordType': 'WGS84GEO',
        'resCoordType': 'EPSG3857',
        'startName': 'Start',
        'endName': 'Arrive',
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch route data: ${response.statusCode}');
    }
  }
}
