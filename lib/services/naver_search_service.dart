import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverSearchService {
  static const String _clientId = 'c1Ko6i4xB27VXIDHBuQ1';
  static const String _clientSecret = 'XYJtlANEsn';
  static const String _baseUrl =
      'https://openapi.naver.com/v1/search/local.json';
  static const String _geocodeBaseUrl =
      'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode';
  static const String _reverseGeocodeBaseUrl =
      'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc';

  static Future<List<dynamic>> searchPlaces(String query) async {
    List<dynamic> allResults = [];
    int start = 1;
    int display = 5;

    while (allResults.length < 6) {
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

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
        // latitude = 37.566295;
        // longitude = 126.977945;
    final response = await http.get(
      Uri.parse(
          '$_reverseGeocodeBaseUrl?coords=$longitude,$latitude&orders=roadaddr&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': 'b8fgmkfu11',
        'X-NCP-APIGW-API-KEY': 'KqipHAEw5M153cxV3VWCDbcrBzNRZ5JpakFygbJ9',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final result = data['results'][0];
        final areas = result['region'];
        final land = result['land'];

        // final areaNames = [
        //   areas['area1']['name'],
        //   areas['area2']['name'],
        //   areas['area3']['name'],
        //   areas['area4']['name']
        // ].where((name) => name != null && name.isNotEmpty).join(' ');

        final additionNames = [
          land['addition0'] != null && !_isNumeric(land['addition0']['value'])
              ? land['addition0']['value']
              : null,
          land['addition1'] != null && !_isNumeric(land['addition1']['value'])
              ? land['addition1']['value']
              : null,
          land['addition2'] != null && !_isNumeric(land['addition2']['value'])
              ? land['addition2']['value']
              : null,
          land['addition3'] != null && !_isNumeric(land['addition3']['value'])
              ? land['addition3']['value']
              : null,
          land['addition4'] != null && !_isNumeric(land['addition4']['value'])
              ? land['addition4']['value']
              : null,
        ].where((name) => name != null && name.isNotEmpty).join(' ');

        // final fullAddress = '$areaNames $additionNames ${land['name']} ${land['number1']}';

        final fullAddress = '$additionNames ${land['name']} ${land['number1']}';

        return fullAddress;
      } else {
        throw Exception('No address found for the given coordinates');
      }
    } else {
      throw Exception('Failed to load address');
    }
  }

  static bool _isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
