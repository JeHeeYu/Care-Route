import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/widgets/button_image.dart';
import 'package:care_route/views/pages/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../widgets/button_icon.dart';

class DestinationDialog extends StatelessWidget {
  const DestinationDialog({super.key});

  Widget _buildTitleFirstText() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: Strings.inputDestinationGuide1,
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: ScreenUtil().setSp(16.0),
              fontWeight: FontWeight.w600,
              color: const Color(UserColors.pointGreen),
            ),
          ),
          TextSpan(
            text: Strings.inputDestinationGuide2,
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: ScreenUtil().setSp(16.0),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSecondText() {
    return UserText(
        text: Strings.inputDestinationGuide3,
        color: Colors.black,
        weight: FontWeight.w600,
        size: ScreenUtil().setSp(16.0));
  }

    Widget _buildSubText() {
    return UserText(
        text: Strings.inputDestinationSub,
        color: const Color(UserColors.gray05),
        weight: FontWeight.w400,
        size: ScreenUtil().setSp(12.0));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
      ),
      child: SizedBox(
        width: ScreenUtil().setWidth(256.0),
        height: ScreenUtil().setHeight(256.0),
        child: Stack(
          children: [
            Positioned(
              top: ScreenUtil().setHeight(21.0),
              right: ScreenUtil().setWidth(21.0),
              child: ButtonIcon(
                  icon: Icons.close,
                  iconColor: const Color(UserColors.gray05),
                  callback: () => Navigator.of(context).pop()),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitleFirstText(),
                  _buildTitleSecondText(),
                  SizedBox(height: ScreenUtil().setHeight(40.0)),
                  _buildSubText(),
                  SizedBox(height: ScreenUtil().setHeight(12.0)),
                  const ButtonImage(imagePath: Images.ear),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
