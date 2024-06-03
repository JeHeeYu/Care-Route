import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/widgets/button_image.dart';
import 'package:care_route/views/pages/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../consts/images.dart';
import '../../consts/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _buildLoginButton(BuildContext context, String image) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SvgPicture.asset(
        image,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  void kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');

        User user = await UserApi.instance.me();
        Map<String, dynamic> userData = {
          "idToken": user.id,
          "email": user.kakaoAccount?.email,
          "name": user.kakaoAccount?.profile?.nickname,
          "sns": "kakao",
        };
        print("User Data : ${userData}");
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');

          User user = await UserApi.instance.me();
          Map<String, dynamic> userData = {
            "idToken": user.id,
            "email": user.kakaoAccount?.email,
            "name": user.kakaoAccount?.profile?.nickname,
            "sns": "kakao",
          };
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');

        User user = await UserApi.instance.me();
        Map<String, dynamic> userData = {
          "idToken": user.id,
          "email": user.kakaoAccount?.email,
          "name": user.kakaoAccount?.profile?.nickname,
          "sns": "kakao",
        };
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      Map<String, dynamic> userData = {
        "idToken": googleUser.id,
        "email": googleUser.email,
        "name": googleUser.displayName,
        "sns": "google",
      };

      print("User Data : ${userData}");
    } else {}
  }

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
            ButtonImage(
                imagePath: Images.googleLogin,
                width: MediaQuery.of(context).size.width,
                callback: () => googleLogin()),
            ButtonImage(
                imagePath: Images.kakaoLogin,
                width: MediaQuery.of(context).size.width,
                callback: () => kakaoLogin()),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
          ],
        ),
      ),
    );
  }
}
