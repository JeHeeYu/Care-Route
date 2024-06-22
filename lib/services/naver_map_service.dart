import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class NaverMapService {
  static const String _mapBaseUrl =
      'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster';

  static const _clientId = 'b8fgmkfu11';
  static const _clientSecret = 'KqipHAEw5M153cxV3VWCDbcrBzNRZ5JpakFygbJ9';

  static Future<Uint8List?> getStaticMapImage(
      double lat, double lon, List<Map<String, double>> markers,
      {int level = 17,
      int width = 600,
      int height = 400,
      String format = 'png'}) async {
    final markerString = markers
        .map((marker) => 'type:d|size:mid|pos:${marker['longitude']}%20${marker['latitude']}')
        .join('|');

    final url =
        '$_mapBaseUrl?w=$width&h=$height&format=$format&markers=$markerString';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Failed to load static map: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, String>> getCoordinates(String address) async {
    final response = await http.get(
      Uri.parse(
          'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$address'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['addresses'].isNotEmpty) {
        final result = data['addresses'][0];
        return {
          'latitude': result['y'],
          'longitude': result['x'],
        };
      }
    }
    throw Exception('Failed to get coordinates');
  }
}
