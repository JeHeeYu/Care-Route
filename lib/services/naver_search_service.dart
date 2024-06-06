import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverSearchService {
  static const String _clientId = 'c1Ko6i4xB27VXIDHBuQ1';
  static const String _clientSecret = 'XYJtlANEsn';
  static const String _baseUrl = 'https://openapi.naver.com/v1/search/local.json';

  static Future<List<dynamic>> searchPlaces(String query) async {
    List<dynamic> allResults = [];
    int start = 1;
    int display = 5;

    while (allResults.length < 30) {
      final response = await http.get(
        Uri.parse('$_baseUrl?query=$query&display=$display&start=$start&sort=random'),
        headers: {
          'X-Naver-Client-Id': _clientId,
          'X-Naver-Client-Secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        allResults.addAll(data['items']);
        start += display;
        
        if (data['items'].length < display) {
          break;
        }
      } else {
        throw Exception('Failed to load search results');
      }
    }

    return allResults;
  }
}