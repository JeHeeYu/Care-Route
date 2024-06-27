import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../widgets/infinity_button.dart';

class TargetConnectionPage extends StatefulWidget {
  const TargetConnectionPage({super.key});

  @override
  State<TargetConnectionPage> createState() => _TargetConnectionPageState();
}

class _TargetConnectionPageState extends State<TargetConnectionPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  int _selectedConnectionTypeIndex = -1;

  Widget _buildInputNumberGuide() {
    return UserText(
        text: Strings.connectionInputGuide,
        color: const Color(UserColors.gray06),
        weight: FontWeight.w700,
        size: ScreenUtil().setSp(16.0));
  }

  Widget _buildInputPhoneNumber() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: Strings.inputPhoneNumber,
          hintStyle: TextStyle(
            fontFamily: "Pretendard",
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(16.0),
            color: const Color(UserColors.gray07),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20.0),
              vertical: ScreenUtil().setHeight(18.5)),
        ),
        style: TextStyle(
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w400,
          fontSize: ScreenUtil().setSp(16.0),
          color: const Color(UserColors.gray07),
        ),
        maxLines: 1,
        onChanged: (text) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildInputGuideText(String text, List<TextSpan> spans, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConnectionTypeIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedConnectionTypeIndex == -1
              ? const Color(UserColors.gray02)
              : (_selectedConnectionTypeIndex == index
                  ? Colors.white
                  : const Color(UserColors.gray04)),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
          border: Border.all(
            color: _selectedConnectionTypeIndex == index
                ? const Color(UserColors.pointGreen)
                : Colors.transparent,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(20.0),
              left: ScreenUtil().setWidth(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserText(
                  text: text,
                  color: const Color(UserColors.gray07),
                  weight: FontWeight.w700,
                  size: ScreenUtil().setSp(16.0)),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  children: spans,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(List<Map<String, dynamic>> data) {
    return data
        .map((item) => TextSpan(
              text: item['text'],
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12.0),
                fontWeight: FontWeight.w400,
                color: item['color'],
              ),
            ))
        .toList();
  }

  Widget _buildConnectionTypeGuide() {
    return UserText(
        text: Strings.connectionTypeGuide,
        color: const Color(UserColors.gray06),
        weight: FontWeight.w700,
        size: ScreenUtil().setSp(16.0));
  }

  Widget _buildConnectionTypeWidget() {
    return SizedBox(
      width: double.infinity,
      height: ScreenUtil().setHeight(117.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildInputGuideText(
              Strings.guide,
              _buildTextSpans([
                {
                  'text': Strings.targetConnectionColorGude1,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.targetConnectionGude1,
                  'color': const Color(UserColors.gray07)
                },
                {
                  'text': Strings.targetConnectionColorGude2,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.targetConnectionGude2,
                  'color': const Color(UserColors.gray07)
                },
                {
                  'text': Strings.targetConnectionColorGude3,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.targetConnectionGude3,
                  'color': const Color(UserColors.gray07)
                },
              ]),
              0,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(8.0)),
          Expanded(
            child: _buildInputGuideText(
              Strings.target,
              _buildTextSpans([
                {
                  'text': Strings.guideConnectionColorGude1,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.guideConnectionGude1,
                  'color': const Color(UserColors.gray07)
                },
                {
                  'text': Strings.guideConnectionColorGude2,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.guideConnectionGude2,
                  'color': const Color(UserColors.gray07)
                },
                {
                  'text': Strings.guideConnectionColorGude3,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.guideConnectionGude3,
                  'color': const Color(UserColors.gray07)
                },
                {
                  'text': Strings.guideConnectionColorGude4,
                  'color': const Color(UserColors.pointGreen)
                },
                {
                  'text': Strings.guideConnectionGude4,
                  'color': const Color(UserColors.gray07)
                },
              ]),
              1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(isRight: true),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputNumberGuide(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildInputPhoneNumber(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildConnectionTypeGuide(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildConnectionTypeWidget(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(16.0)),
            child: InfinityButton(
              height: ScreenUtil().setHeight(56.0),
              radius: ScreenUtil().radius(8.0),
              backgroundColor: const Color(UserColors.gray03),
              text: Strings.addTarget,
              textSize: ScreenUtil().setSp(16.0),
              textColor: (_selectedConnectionTypeIndex == -1 ||
                      _phoneNumberController.text.isEmpty)
                  ? const Color(UserColors.gray01)
                  : const Color(UserColors.pointGreen),
              textWeight: FontWeight.w600,
              // callback: () => _isButtonEnabled()
              //     ? _navigateToConnectionPage(context)
              //     : null,
            ),
          ),
        ],
      ),
    );
  }
}
