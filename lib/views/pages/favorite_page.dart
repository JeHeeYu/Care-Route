import 'package:care_route/views/pages/route_guide/destination_dialog.dart';
import 'package:care_route/views/pages/widgets/button_icon.dart';
import 'package:care_route/views/pages/widgets/button_image.dart';
import 'package:care_route/views/pages/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../consts/strings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/naver_search_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _destinationDialogOpen = false;
  final List<String> _favoriteTexts = ["우리집", "회사", "학교", "마트", "공원"];
  String _searchText = "";
  List<dynamic> _searchResults = [];

  void _showDestinationDialog() {
    setState(() {
      _destinationDialogOpen = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DestinationDialog();
      },
    ).then((_) {
      setState(() {
        _destinationDialogOpen = false;
      });
    });
  }

  Future<void> _searchPlaces(String query) async {
    final results = await NaverSearchService.searchPlaces(query);
    setState(() {
      _searchResults = results;
    });
  }

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Widget _buildSearchInputBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _searchController,
            onChanged: (text) {
              setState(() {
                _searchText = text;
              });
              if (text.isNotEmpty) {
                _searchPlaces(text);
              } else {
                setState(() {
                  _searchResults = [];
                });
              }
            },
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: Strings.favoriteHint,
              hintStyle: const TextStyle(
                  color: Color(UserColors.gray04),
                  fontSize: 16.0,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600),
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
              prefixIcon: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(12.0)),
                child: ButtonIcon(
                    icon: Icons.arrow_back_ios,
                    iconColor: const Color(UserColors.gray05),
                    callback: _destinationDialogOpen
                        ? () {}
                        : () => Navigator.of(context).pop()),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(12.0)),
                child: ButtonImage(
                  imagePath: Images.mic,
                  callback: _destinationDialogOpen
                      ? () {}
                      : () => _showDestinationDialog(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteList(String text) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(8.0),
          left: ScreenUtil().setWidth(16.0),
          right: ScreenUtil().setWidth(16.0)),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(56.0),
        decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const ButtonImage(imagePath: Images.favoriteWhite),
                  SizedBox(width: ScreenUtil().setWidth(8.0)),
                  UserText(
                      text: text,
                      color: const Color(UserColors.gray07),
                      weight: FontWeight.w400,
                      size: ScreenUtil().setSp(16.0)),
                ],
              ),
              ButtonIcon(
                  icon: Icons.close,
                  iconColor: Colors.red,
                  callback: () => {}), //Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchList(String result, String address) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(8.0),
          left: ScreenUtil().setWidth(16.0),
          right: ScreenUtil().setWidth(16.0)),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(74.0),
        decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: _buildHighlightedText(
                              result,
                              _searchController.text,
                              const Color(UserColors.gray07),
                              const Color(UserColors.pointGreen),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(8.0)),
                          UserText(
                              text: address,
                              color: const Color(UserColors.gray06),
                              weight: FontWeight.w400,
                              size: ScreenUtil().setSp(12.0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const ButtonImage(imagePath: Images.favoriteButtonEnable),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _buildHighlightedText(String fullText, String searchText,
      Color defaultColor, Color highlightColor) {
    int startIndex = fullText.indexOf(searchText);
    if (startIndex == -1 || searchText.isEmpty) {
      return TextSpan(
        text: fullText,
        style: TextStyle(
            color: const Color(UserColors.gray07),
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(16.0),
            fontFamily: "Pretendard"),
      );
    }

    List<TextSpan> spans = [];
    spans.add(TextSpan(
      text: fullText.substring(0, startIndex),
      style: TextStyle(
          color: defaultColor,
          fontSize: ScreenUtil().setSp(16.0),
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w400),
    ));

    spans.add(TextSpan(
      text: fullText.substring(startIndex, startIndex + searchText.length),
      style: TextStyle(
          color: highlightColor,
          fontSize: ScreenUtil().setSp(16.0),
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w600),
    ));

    spans.add(TextSpan(
      text: fullText.substring(startIndex + searchText.length),
      style: TextStyle(
          color: defaultColor,
          fontSize: ScreenUtil().setSp(16.0),
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w400),
    ));

    return TextSpan(children: spans);
  }

  Widget _buildSubText() {
    return UserText(
        text: Strings.favoriteMaxCount,
        color: const Color(UserColors.gray05),
        weight: FontWeight.w400,
        size: ScreenUtil().setSp(12.0));
  }

  Widget _buildContent() {
    if (_searchText.isNotEmpty && _searchResults.isNotEmpty) {
      return Column(
        children: _searchResults.map((result) {
          return Column(
            children: [
              _buildSearchList(
                _removeHtmlTags(result['title']),
                result['roadAddress'],
              ),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
            ],
          );
        }).toList(),
      );
    } else {
      return Column(
        children: [
          ..._favoriteTexts.map((text) => _favoriteList(text)).toList(),
          SizedBox(height: ScreenUtil().setHeight(10.0)),
          _buildSubText(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(40.0)),
            _buildSearchInputBox(),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
            const Divider(
              color: Color(UserColors.gray03),
              thickness: 1.0,
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
