import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/type_select_page.dart';
import 'package:care_route/views/pages/widgets/button_image.dart';
import 'package:care_route/views/pages/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../consts/images.dart';
import '../../consts/strings.dart';
import '../../view_models/member_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late MemberViewModel _memberViewModel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _memberViewModel = Provider.of<MemberViewModel>(context, listen: false);
  }

  Future<void> handleLogin(Future<OAuthToken> Function() loginMethod) async {
    try {
      OAuthToken token = await loginMethod();
      User user = await UserApi.instance.me();
      Map<String, dynamic> userData = {
        "idToken": token.idToken,
        "nickname": user.kakaoAccount?.profile?.nickname,
      };
      final result = await _memberViewModel.login(userData);

      if (result == 200) {
        _storage.write(key: Strings.idTokenKey, value: token.idToken);
        _storage.write(
            key: Strings.typeKey, value: _memberViewModel.loginData.data?.type);
        navigateToNextPage();
      }
    } catch (error) {
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      } else {
        print('로그인 실패 $error');
      }
    }
  }

  void navigateToNextPage() {
    String pageType = _memberViewModel.loginData.data?.type ?? '';
    if (_memberViewModel.loginData.data?.type == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TypeSelectPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => App(
                  initialPageType: pageType,
                )),
      );
    }
  }

  void kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      await handleLogin(UserApi.instance.loginWithKakaoTalk);
    } else {
      await handleLogin(UserApi.instance.loginWithKakaoAccount);
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
    } else {
      print("Google 로그인 실패");
    }
  }

  Widget buildRichText(List<String> texts, List<Color> colors) {
    List<TextSpan> spans = [];
    for (int i = 0; i < texts.length; i++) {
      spans.add(TextSpan(
        text: texts[i],
        style: TextStyle(
          fontFamily: "Pretendard",
          fontSize: ScreenUtil().setSp(20.0),
          fontWeight: FontWeight.w800,
          color: colors[i],
        ),
      ));
    }
    return RichText(
      text: TextSpan(children: spans),
    );
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
                  buildRichText(
                    [Strings.loginColorGuide1, Strings.loginGuide1],
                    [const Color(UserColors.pointGreen), Colors.black],
                  ),
                  buildRichText(
                    [
                      Strings.loginGuide2,
                      Strings.loginColorGuide2,
                      Strings.loginGuide2_1
                    ],
                    [
                      Colors.black,
                      const Color(UserColors.pointGreen),
                      Colors.black
                    ],
                  ),
                  buildRichText(
                    [Strings.loginColorGuide3, Strings.loginGuide3],
                    [const Color(UserColors.pointGreen), Colors.black],
                  ),
                ],
              ),
            ),
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
