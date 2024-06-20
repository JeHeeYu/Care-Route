import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverSearchService {
  static const String _clientId = 'c1Ko6i4xB27VXIDHBuQ1';
  static const String _clientSecret = 'XYJtlANEsn';
  static const String _baseUrl = 'https://openapi.naver.com/v1/search/local.json';
  static const String _geocodeBaseUrl = 'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode';

  static Future<List<dynamic>> searchPlaces(String query) async {
    List<dynamic> allResults = [];
    int start = 1;
    int display = 10;

    while (allResults.length < 30) {
      final response = await http.get(
        Uri.parse('$_baseUrl?query=$query&display=$display&start=$start'),
        headers: {
          'X-Naver-Client-Id': _clientId,
          'X-Naver-Client-Secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        allResults.addAll(data['items']);
        start += display;

        print("Jehee OItem : ${data}");

        if (data['items'].length < display) {
          break;
        }
      } else {
        throw Exception('Failed to load search results');
      }
    }

    return allResults.take(30).toList();
  }

  static Future<Map<String, dynamic>> getCoordinates(String address) async {
    final response = await http.get(
      Uri.parse('$_geocodeBaseUrl?query=$address'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': 'b8fgmkfu11',
        'X-NCP-APIGW-API-KEY': 'KqipHAEw5M153cxV3VWCDbcrBzNRZ5JpakFygbJ9',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['addresses'] != null && data['addresses'].isNotEmpty) {
        final Map<String, dynamic> addressInfo = data['addresses'][0];
        return {
          'latitude': addressInfo['y'],
          'longitude': addressInfo['x'],
        };
      } else {
        throw Exception('No coordinates found for the given address');
      }
    } else {
      throw Exception('Failed to load coordinates');
    }
  }
}
