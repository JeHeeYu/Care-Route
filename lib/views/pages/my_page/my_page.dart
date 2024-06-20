import 'package:care_route/views/pages/login_page.dart';
import 'package:care_route/views/pages/my_page/target_list_page.dart';
import 'package:care_route/views/widgets/button_icon.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../../routes/routes_name.dart';
import '../../widgets/complete_dialog.dart';

class MyPage extends StatefulWidget {
  final String userType;

  const MyPage({Key? key, required this.userType}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void _showPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void showCompleteDialog(String text) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return CompleteDialog(title: text);
      },
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
          const ButtonIcon(
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
      child: GestureDetector(
        onTap: () => _showPage(context, page),
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
                const ButtonIcon(
                  icon: Icons.arrow_forward_ios,
                  iconColor: Color(UserColors.pointGreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutAndWithdrawal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => {
            showCompleteDialog(Strings.logoutComplete),
            _storage.deleteAll(),
            _showPage(context, const LoginPage()),
          },
          child: UserText(
              text: Strings.logout,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0)),
        ),
        Container(
          width: ScreenUtil().setWidth(1.0),
          height: ScreenUtil().setHeight(12.0),
          color: const Color(UserColors.gray05),
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20.0)),
        ),
        GestureDetector(
          onTap: () => {
            showCompleteDialog(Strings.withdrawalComplete),
            _storage.deleteAll(),
            _showPage(context, const LoginPage()),
          },
          child: UserText(
              text: Strings.withdrawal,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0)),
        ),
      ],
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(60.0)),
                    ClipOval(
                      child: Container(
                        color: Colors.red,
                        width: ScreenUtil().setWidth(100.0),
                        height: ScreenUtil().setHeight(100.0),
                        child: Container(),
                      ),
                    ),
                    _buildNickNameWidget(),
                    _buildContentsWidget(
                        Strings.changePhoneNumber, Container()),
                    _buildContentsWidget(
                        Strings.targetConnection, TargetListPage(userType: widget.userType,)),
                    _buildContentsWidget(Strings.setEasyAddress, Container()),
                    _buildContentsWidget(Strings.customerCenter, Container()),
                    _buildContentsWidget(Strings.notification, Container()),
                    SizedBox(height: ScreenUtil().setHeight(6.0)),
                    _buildLogoutAndWithdrawal(),
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
