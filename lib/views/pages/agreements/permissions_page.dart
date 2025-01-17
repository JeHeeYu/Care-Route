import 'package:care_route/views/pages/user_info_page.dart';
import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../widgets/infinity_button.dart';
import '../../widgets/user_text.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  void _navigateToPermissionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserInfoPage()),
    );
  }

  Widget _buildContentsWidget(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8.0)),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(56.0),
        decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserText(
                  text: title,
                  color: const Color(UserColors.gray07),
                  weight: FontWeight.w400,
                  size: ScreenUtil().setSp(16.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationText_1() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12.0)),
      child: UserText(
        text: Strings.permissionGuide1,
        color: const Color(UserColors.gray07),
        weight: FontWeight.w400,
        size: ScreenUtil().setSp(14.0),
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _buildExplanationText_2() {
    return UserText(
        text: Strings.permissionGuide2,
        color: const Color(UserColors.gray07),
        weight: FontWeight.w400,
        size: ScreenUtil().setSp(14.0));
  }

  Widget _buildGuideText() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(28.0)),
      child: UserText(
          text: Strings.agreementPageGuide,
          color: const Color(UserColors.gray05),
          weight: FontWeight.w400,
          size: ScreenUtil().setSp(12.0)),
    );
  }

  Widget _buildAllPermitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16.0)),
      child: InfinityButton(
        height: ScreenUtil().setHeight(56.0),
        radius: ScreenUtil().radius(8.0),
        backgroundColor: const Color(UserColors.pointGreen),
        text: Strings.allPermit,
        textSize: ScreenUtil().setSp(16.0),
        textColor: Colors.white,
        textWeight: FontWeight.w600,
        callback: () => _navigateToPermissionPage(context),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentsWidget(Strings.notificationPermit),
                  _buildContentsWidget(Strings.locationInfoPermit),
                  _buildContentsWidget(Strings.motionSensorPermit),
                  _buildContentsWidget(Strings.batteryUsePermit),
                  _buildExplanationText_1(),
                  _buildExplanationText_2(),
                ],
              ),
            ),
            _buildGuideText(),
            _buildAllPermitButton(context),
          ],
        ),
      ),
    );
  }
}
