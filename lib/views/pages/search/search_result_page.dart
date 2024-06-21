import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../services/naver_map_service.dart';
import '../../widgets/user_text.dart';

class SearchResultPage extends StatefulWidget {
  final String result;
  final String address;
  final double latitude;
  final double longitude;

  const SearchResultPage({
    required this.result,
    required this.address,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  Uint8List? _staticMapImage;

  @override
  void initState() {
    super.initState();
    _fetchStaticMap();
  }

  Future<void> _fetchStaticMap() async {
    final staticMapImage = await NaverMapService.getStaticMapImage(
      widget.latitude,
      widget.longitude,
    );
    setState(() {
      _staticMapImage = staticMapImage;
    });
  }

  Widget _buildDestinationInputBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: TextEditingController(text: widget.address),
            focusNode: FocusNode(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Enter destination',
              hintStyle: const TextStyle(
                color: Color(UserColors.gray04),
                fontSize: 16.0,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                borderSide: const BorderSide(
                  color: Color(UserColors.gray03),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                borderSide: const BorderSide(
                  color: Color(UserColors.gray03),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                borderSide: const BorderSide(
                  color: Color(UserColors.gray03),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(16.0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(40.0)),
            _buildDestinationInputBox(),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
            if (_staticMapImage != null)
              Image.memory(_staticMapImage!)
            else
              CircularProgressIndicator(),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
          ],
        ),
      ),
    );
  }
}
