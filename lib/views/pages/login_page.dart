import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/widgets/UserText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../consts/images.dart';
import '../../consts/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Widget _buildLoginButton(BuildContext context, String image) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: SvgPicture.asset(
      image,
      fit: BoxFit.fitWidth,
    ),
  );
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 첫 번째 라인
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Strings.loginColorGuide1,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: const Color(UserColors.pointGreen),
                        ),
                      ),
                      TextSpan(
                        text: Strings.loginGuide1,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // 두 번째 라인
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Strings.loginGuide2,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: Strings.loginColorGuide2,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: const Color(UserColors.pointGreen),
                        ),
                      ),
                      TextSpan(
                        text: Strings.loginGuide2_1,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // 세 번째 라인
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Strings.loginColorGuide3,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: const Color(UserColors.pointGreen),
                        ),
                      ),
                      TextSpan(
                        text: Strings.loginGuide3,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            UserText(
                text: Strings.easyLoginGuide,
                color: const Color(UserColors.gray04),
                weight: FontWeight.w500,
                size: ScreenUtil().setSp(12.0)),
            SizedBox(height: ScreenUtil().setHeight(8.0)),
            _buildLoginButton(context, Images.googleLogin),
            SizedBox(height: ScreenUtil().setHeight(8.0)),
            _buildLoginButton(context, Images.kakaoLogin),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
          ],
        ),
      ),
    );
  }
}
