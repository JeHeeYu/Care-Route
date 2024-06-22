import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../../services/naver_map_service.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/button_image.dart';
import '../../widgets/user_text.dart';

class SearchResultPage extends StatefulWidget {
  final String result;
  final String address;
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> markers;

  const SearchResultPage({
    required this.result,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.markers,
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
    final List<Map<String, double>> markerCoordinates =
        widget.markers.map((marker) {
      return {
        'latitude': marker['latitude'] as double,
        'longitude': marker['longitude'] as double,
      };
    }).toList();

    final staticMapImage = await NaverMapService.getStaticMapImage(
      widget.latitude,
      widget.longitude,
      markerCoordinates,
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

  Widget _buildSearchList(int index, String title, String address) {
    final numberList = [
      '⓪',
      '①',
      '②',
      '③',
      '④',
      '⑤',
      '⑥',
      '⑦',
      '⑧',
      '⑨',
      '⑩',
      '⑪',
      '⑫',
      '⑬',
      '⑭',
      '⑮',
      '⑯',
      '⑰',
      '⑱',
      '⑲',
      '⑳',
    ];

    final extendedNumberList = List<String>.from(numberList);
    while (extendedNumberList.length < title.length + 10) {
      extendedNumberList.addAll(numberList);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16.0),
          vertical: ScreenUtil().setHeight(8.0)),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(130.0),
        decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${extendedNumberList[index]}',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(26.0),
                      color: const Color(UserColors.pointGreen),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(8.0)),
                  Expanded(
                    child: UserText(
                      text: title,
                      color: const Color(UserColors.gray07),
                      weight: FontWeight.w400,
                      size: ScreenUtil().setSp(16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  UserText(
                    text: '00분',
                    color: const Color(UserColors.gray05),
                    weight: FontWeight.w400,
                    size: ScreenUtil().setSp(16.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
              UserText(
                text: address,
                color: const Color(UserColors.gray06),
                weight: FontWeight.w400,
                size: ScreenUtil().setSp(12.0),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonImage(imagePath: Images.favoriteButtonDisable),
                  _buildStartandArriveWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartandArriveWidget() {
    return Row(
      children: [
        Container(
          width: ScreenUtil().setWidth(68.0),
          height: ScreenUtil().setHeight(48.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(28.0)),
            border: Border.all(
              color: const Color(UserColors.gray05),
              width: 1.0,
            ),
          ),
          child: Center(
            child: UserText(
                text: Strings.start,
                color: const Color(UserColors.gray05),
                weight: FontWeight.w700,
                size: ScreenUtil().setSp(16.0)),
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(8.0)),
        Container(
          width: ScreenUtil().setWidth(68.0),
          height: ScreenUtil().setHeight(48.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(28.0)),
            border: Border.all(
              color: const Color(UserColors.pointGreen),
              width: 1.0,
            ),
          ),
          child: Center(
            child: UserText(
                text: Strings.arrive,
                color: const Color(UserColors.pointGreen),
                weight: FontWeight.w700,
                size: ScreenUtil().setSp(16.0)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
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
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: widget.markers.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> marker = entry.value;
                      return _buildSearchList(
                        index,
                        marker['title'] ?? '',
                        marker['address'] ?? '',
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
