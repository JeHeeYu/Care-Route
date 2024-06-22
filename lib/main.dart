import 'package:care_route/view_models/member_view_model.dart';
import 'package:care_route/view_models/mypage_view_model.dart';
import 'package:care_route/view_models/route_view_model.dart';
import 'package:care_route/view_models/routine_view_model.dart';
import 'package:care_route/views/pages/favorite_page.dart';
import 'package:care_route/views/pages/login_page.dart';
import 'package:care_route/views/pages/my_page/target_connection_page.dart';
import 'package:care_route/views/pages/route_guide_page.dart';
import 'package:care_route/views/pages/splash_page.dart';
import 'package:care_route/views/pages/type_select_page.dart';
import 'package:care_route/views/pages/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("FCM Message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  KakaoSdk.init(nativeAppKey: '2009513e88266b07a15ad4578d2eacee');
  await NaverMapSdk.instance.initialize(
    clientId: 'b8fgmkfu11',
  );

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    // iOS foreground notification 권한
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message");
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint('fcm getInitialMessage, message : ${message?.data ?? ''}');
      if (message != null) {
        return;
      }
    });

    String token = await FirebaseMessaging.instance.getToken() ?? '';
    debugPrint("fcmToken : $token");
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint('fcm backgroundHandler, message');

    debugPrint(message.notification?.title ?? '');
    debugPrint(message.notification?.body ?? '');
  }

  Future<void> setFCM() async {
    //백그라운드 메세지 핸들링(수신처리)
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  // Future<void> _setupFCM() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('Message clicked!');
  //   });

  //   String? token = await messaging.getToken();
  //   print("FCM Token: $token");
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemberViewModel()),
        ChangeNotifierProvider(create: (_) => RouteViewModel()),
        ChangeNotifierProvider(create: (_) => RoutineViewModel()),
        ChangeNotifierProvider(create: (_) => MypageViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (BuildContext context, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
