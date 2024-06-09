import 'package:care_route/view_models/login_view_model.dart';
import 'package:care_route/views/pages/favorite_page.dart';
import 'package:care_route/views/pages/login_page.dart';
import 'package:care_route/views/pages/route_guide/route_guide_page.dart';
import 'package:care_route/views/pages/splash_page.dart';
import 'package:care_route/views/pages/type_select_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '2009513e88266b07a15ad4578d2eacee');
  await NaverMapSdk.instance.initialize(
    clientId: 'b8fgmkfu11',
    //FonAuthFailed: (ex) =>
  );
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (BuildContext context, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const TypeSelectPage(),
        ),
      ),
    );
  }
}
