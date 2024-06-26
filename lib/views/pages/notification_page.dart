import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../consts/colors.dart';
import '../../consts/strings.dart';
import '../widgets/button_icon.dart';
import '../widgets/infinity_button.dart';
import '../widgets/user_text.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Widget _buildGuideContents(
      String colorGuide, String normalGuide, String destination, String title) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(92.0),
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20.0),
            vertical: ScreenUtil().setHeight(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: colorGuide,
                    style: TextStyle(
                      color: const Color(UserColors.pointGreen),
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(16.0),
                      fontFamily: "Pretendard",
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: normalGuide,
                        style: TextStyle(
                          color: const Color(UserColors.gray07),
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(16.0),
                          fontFamily: "Pretendard",
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonIcon(
                    icon: Icons.close,
                    iconColor: const Color(UserColors.gray05)),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(4.0)),
            UserText(
              text: destination,
              color: const Color(UserColors.gray07),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(4.0)),
            UserText(
              text: title,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleStartWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(142.0),
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20.0),
            vertical: ScreenUtil().setHeight(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: Strings.scheduleStartGuide1,
                    style: TextStyle(
                      color: const Color(UserColors.gray07),
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(16.0),
                      fontFamily: "Pretendard",
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: Strings.scheduleStartColorGuide1,
                        style: TextStyle(
                          color: const Color(UserColors.pointGreen),
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(16.0),
                          fontFamily: "Pretendard",
                        ),
                      ),
                      TextSpan(
                        text: Strings.scheduleStartGuide3,
                        style: TextStyle(
                          color: const Color(UserColors.gray07),
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(16.0),
                          fontFamily: "Pretendard",
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonIcon(
                    icon: Icons.close,
                    iconColor: const Color(UserColors.gray05)),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(4.0)),
            UserText(
              text: Strings.scheduleStartGuide2,
              color: const Color(UserColors.gray07),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(12.0)),
            InfinityButton(
              height: ScreenUtil().setHeight(56.0),
              radius: ScreenUtil().radius(8.0),
              backgroundColor: const Color(UserColors.pointGreen),
              text: Strings.routeStart,
              textSize: ScreenUtil().setSp(16.0),
              textColor: Colors.white,
              textWeight: FontWeight.w600,
              // callback: () => _isButtonEnabled()
              //     ? _navigateToConnectionPage(context)
              //     : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextScheduleStartWidget(String destination) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(165.0),
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20.0),
            vertical: ScreenUtil().setHeight(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: Strings.nextSchedule,
                    style: TextStyle(
                      color: const Color(UserColors.pointGreen),
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(16.0),
                      fontFamily: "Pretendard",
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: Strings.scheduleStartColorGuide1,
                        style: TextStyle(
                          color: const Color(UserColors.pointGreen),
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(16.0),
                          fontFamily: "Pretendard",
                        ),
                      ),
                      TextSpan(
                        text: Strings.nextScheduleGuide1,
                        style: TextStyle(
                          color: const Color(UserColors.gray07),
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(16.0),
                          fontFamily: "Pretendard",
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonIcon(
                    icon: Icons.close,
                    iconColor: const Color(UserColors.gray05)),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(4.0)),
            UserText(
              text: Strings.nextScheduleGuide2,
              color: const Color(UserColors.gray07),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(4.0)),
            UserText(
              text: destination,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ScreenUtil().setHeight(12.0)),
            InfinityButton(
              height: ScreenUtil().setHeight(56.0),
              radius: ScreenUtil().radius(8.0),
              backgroundColor: const Color(UserColors.pointGreen),
              text: Strings.routeStart,
              textSize: ScreenUtil().setSp(16.0),
              textColor: Colors.white,
              textWeight: FontWeight.w600,
              // callback: () => _isButtonEnabled()
              //     ? _navigateToConnectionPage(context)
              //     : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(60.0)),
                    _buildGuideContents(
                        "1시간 ", "뒤, 일정이 시작해요", "금천구청", "구청에서 여권 발급 받기"),
                    SizedBox(height: ScreenUtil().setHeight(16.0)),
                    _buildGuideContents(
                        "5분 ", "뒤, 일정이 시작해요", "금천구청", "구청에서 여권 발급 받기"),
                    SizedBox(height: ScreenUtil().setHeight(16.0)),
                    _buildScheduleStartWidget(),
                    SizedBox(height: ScreenUtil().setHeight(16.0)),
                    _buildNextScheduleStartWidget('신촌 현대백화점'),
                    SizedBox(height: ScreenUtil().setHeight(40.0)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
