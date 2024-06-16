import 'package:care_route/views/widgets/button_icon.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../consts/colors.dart';
import '../../consts/strings.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  void _showPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildNickNameWidget() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(12.0),
          bottom: ScreenUtil().setHeight(32.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserText(
              text: "닉네임",
              color: const Color(UserColors.gray07),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(16.0)),
          SizedBox(width: ScreenUtil().setWidth(8.0)),
          ButtonIcon(
            icon: Icons.edit,
            iconColor: const Color(UserColors.gray05),
          )
        ],
      ),
    );
  }

  Widget _buildContentsWidget(String title, Widget page) {
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
              ButtonIcon(
                icon: Icons.arrow_forward_ios,
                iconColor: const Color(UserColors.pointGreen),
                callback: () => _showPage(context, page),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutAndWithdrawal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserText(
            text: Strings.logout,
            color: const Color(UserColors.gray05),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(12.0)),
        Container(
          width: ScreenUtil().setWidth(1.0),
          height: ScreenUtil().setHeight(12.0),
          color: const Color(UserColors.gray05),
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20.0)),
        ),
        UserText(
            text: Strings.withdrawal,
            color: const Color(UserColors.gray05),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(12.0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipOval(
                child: Container(
                  color: Colors.red,
                  width: ScreenUtil().setWidth(100.0),
                  height: ScreenUtil().setHeight(100.0),
                  child: Container(),
                ),
              ),
              _buildNickNameWidget(),
              _buildContentsWidget(Strings.changePhoneNumber, Container()),
              _buildContentsWidget(Strings.targetConnection, Container()),
              _buildContentsWidget(Strings.setEasyAddress, Container()),
              _buildContentsWidget(Strings.customerCenter, Container()),
              _buildContentsWidget(Strings.notification, Container()),
              SizedBox(height: ScreenUtil().setHeight(6.0)),
              _buildLogoutAndWithdrawal(),
            ],
          ),
        ),
      ),
    );
  }
}
