import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TMapExample(),
    );
  }
}

class TMapExample extends StatefulWidget {
  @override
  _TMapExampleState createState() => _TMapExampleState();
}

class _TMapExampleState extends State<TMapExample> {
  String _result = '';

  final String _apiKey = 'w8qRXuuGFx3XB1ELc5Y278RPC3TkSnMO5G9ovdtN';
  final String _startX = '126.9779692'; // 서울 시청 경도
  final String _startY = '37.566535';   // 서울 시청 위도
  final String _endX = '126.978275';    // 목적지 경도
  final String _endY = '37.565834';     // 목적지 위도

  @override
  void initState() {
    super.initState();
    _fetchTMapData();
  }

  Future<void> _fetchTMapData() async {
    final url = Uri.parse('https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&callback=function');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'appKey': _apiKey,
      },
      body: json.encode({
        'startX': _startX,
        'startY': _startY,
        'endX': _endX,
        'endY': _endY,
        'reqCoordType': 'WGS84GEO',
        'resCoordType': 'EPSG3857',
        'startName': 'Seoul City Hall',
        'endName': 'Destination',
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _result = response.body;
      });
      print(_result);  // 로그에 출력
    } else {
      setState(() {
        _result = 'Failed to fetch data: ${response.statusCode}';
      });
      print(_result);  // 오류 로그에 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TMap Pedestrian Route Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(_result),
          ),
        ),
      ),
    );
  }
}
