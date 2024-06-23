import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../consts/colors.dart';
import '../../consts/strings.dart';
import '../widgets/infinity_button.dart';

class ConnectionRequestPage extends StatelessWidget {
  const ConnectionRequestPage({super.key});

  Widget _buildConnectionGuide() {
    return UserText(
        text: Strings.connectionGuide,
        color: const Color(UserColors.gray06),
        weight: FontWeight.w700,
        size: ScreenUtil().setSp(16.0));
  }

  Widget _buildToWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(252.0),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray02),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
      ),
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(32.0)),
          UserText(
              text: Strings.role,
              color: const Color(UserColors.gray06),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(16.0)),
          UserText(
              text: Strings.role,
              color: const Color(UserColors.gray06),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(16.0)),
          UserText(
              text: Strings.role,
              color: const Color(UserColors.gray06),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(16.0)),
        ],
      ),
    );
  }

  Widget _buildFromWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(56.0),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray02),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: '당신에게 ',
            style: TextStyle(
              color: const Color(UserColors.gray06),
              fontWeight: FontWeight.w700,
              fontSize: ScreenUtil().setSp(16.0),
              fontFamily: "Pretendard",
            ),
            children: <TextSpan>[
              TextSpan(
                text: '[안내 대상]',
                style: TextStyle(
                  color: const Color(UserColors.pointGreen),
                  fontFamily: "Pretendard",
                ),
              ),
              TextSpan(
                text: '을 요청했어요.',
                style: TextStyle(
                  color: const Color(UserColors.gray06),
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(16.0),
                  fontFamily: "Pretendard",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionQuestionText() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(21.0)),
      child: UserText(
          text: Strings.connectionQuestionGuide,
          color: const Color(UserColors.gray06),
          weight: FontWeight.w700,
          size: ScreenUtil().setSp(16.0)),
    );
  }

  Widget _buildGuideText() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(21.0)),
      child: UserText(
          text: Strings.connectionTimeGuide,
          color: const Color(UserColors.gray05),
          weight: FontWeight.w400,
          size: ScreenUtil().setSp(12.0)),
    );
  }

  Widget _buildAllAgreementButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16.0)),
      child: InfinityButton(
        height: ScreenUtil().setHeight(56.0),
        radius: ScreenUtil().radius(8.0),
        backgroundColor: const Color(UserColors.pointGreen),
        text: Strings.allAgreemnet,
        textSize: ScreenUtil().setSp(16.0),
        textColor: Colors.white,
        textWeight: FontWeight.w600,
        // callback: () => _navigateToPermissionPage(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(isRight: true),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildConnectionGuide(),
                  SizedBox(height: ScreenUtil().setHeight(20.0)),
                  _buildToWidget(),
                  SizedBox(height: ScreenUtil().setHeight(8.0)),
                  _buildFromWidget(),
                  SizedBox(height: ScreenUtil().setHeight(20.0)),
                  _buildConnectionQuestionText(),
                ],
              ),
            ),
            _buildGuideText(),
            _buildAllAgreementButton(context),
          ],
        ),
      ),
    );
  }
}
