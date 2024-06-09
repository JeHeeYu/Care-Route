import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/widgets/back_app_bar.dart';
import 'package:care_route/views/pages/widgets/infinity_button.dart';
import 'package:care_route/views/pages/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../consts/strings.dart';

class TypeSelectPage extends StatelessWidget {
  const TypeSelectPage({super.key});

  Widget _buildTargetWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(210.0),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray02),
        borderRadius: BorderRadius.circular(8.0), // BorderRadius 추가
      ),
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(35.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: Strings.typeColorGuide1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeTargetGuide1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(6.0)),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: Strings.typeTargetGuide2_1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeTargetColorGuide2_1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeTargetGuide2_2,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeTargetColorGuide2_2,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeTargetGuide2_3,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuiderWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(210.0),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray02),
        borderRadius: BorderRadius.circular(8.0), // BorderRadius 추가
      ),
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(35.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: Strings.typeGuiderGuide1_1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderColorGuide1_1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderGuide1_2,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderColorGuide1_2,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderGuide1_3,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(6.0)),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: Strings.typeGuiderGuide2_1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderColorGuide2_1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderGuide2_2,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderColorGuide2_2,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(UserColors.pointGreen),
                    ),
                  ),
                  TextSpan(
                    text: Strings.typeGuiderGuide2_3,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(16.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(20.0)),
            UserText(
              text: Strings.typeSelectGuide,
              color: const Color(0xFF6F6F6F),
              weight: FontWeight.w600,
              size: ScreenUtil().setSp(16.0),
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
            Expanded(
              child: Column(
                children: [
                  _buildTargetWidget(),
                  SizedBox(height: ScreenUtil().setHeight(9.0)),
                  _buildGuiderWidget(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16.0)),
              child: InfinityButton(
                height: ScreenUtil().setHeight(56.0),
                radius: ScreenUtil().radius(8.0),
                backgroundColor: const Color(UserColors.pointGreen),
                text: Strings.selectComplete,
                textSize: ScreenUtil().setSp(16.0),
                textColor: Colors.white,
                textWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
