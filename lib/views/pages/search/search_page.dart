import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../../services/naver_search_service.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/button_image.dart';
import '../../widgets/destination_dialog.dart';
import '../../widgets/user_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late stt.SpeechToText _speech;
  List<dynamic> _searchResults = [];
  bool _isListening = false;
  bool _destinationDialogOpen = false;
  Timer? _timer;
  String _searchText = "";



  @override
  void initState() {
    super.initState();
    print("JEhee");
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

    Future<void> _searchPlaces(String query) async {
    final results = await NaverSearchService.searchPlaces(query);
    setState(() {
      print("JEhee : ${results}");
      _searchResults = results;
    });
  }

  void _showDestinationDialog() {
    setState(() {
      _destinationDialogOpen = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DestinationDialog(
          onStartListening: _startListening,
          onStopListening: _stopListening,
        );
      },
    ).then((_) {
      setState(() {
        _destinationDialogOpen = false;
      });
      _stopListening();
    });

    _startListening();
    _resetTimer();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _destinationController.text = val.recognizedWords;
          _searchText = val.recognizedWords;
          _resetTimer();
          _searchPlaces(val.recognizedWords);
        }),
        localeId: 'ko_KR',
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _cancelTimer();
  }

  void _resetTimer() {
    _cancelTimer();
    _timer = Timer(const Duration(seconds: 4), () {
      if (_destinationDialogOpen) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _destinationDialogOpen = false;
        });
        _stopListening();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Widget _buildDestinationInputBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _destinationController,
            focusNode: _focusNode,
            onChanged: (text) {
              setState(() {
                _searchText = text;
              });
              if (text.isNotEmpty) {
                _searchPlaces(text);
                print("Jehee : ${text}");
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
              hintText: Strings.destinationHint,
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
                  callback:
                      _destinationDialogOpen ? () {} : _showDestinationDialog,
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(16.0)),
        ],
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
                              _destinationController.text,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_searchText.isNotEmpty && _searchResults.isNotEmpty) {
      return Column(
        children: _searchResults.map((result) {
          return Column(
            children: [
              _buildSearchList(
                  _removeHtmlTags(result['title']), result['address']),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
            ],
          );
        }).toList(),
      );
    } else {
      return Container(
        child: UserText(
          text: "검색 결과가 없습니다.",
          color: const Color(UserColors.gray05),
          weight: FontWeight.w400,
          size: ScreenUtil().setSp(16.0),
        ),
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
            _buildDestinationInputBox(),
            SizedBox(height: ScreenUtil().setHeight(6.0)),
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
