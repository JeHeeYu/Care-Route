import 'package:care_route/routes/page_router.dart';
import 'package:care_route/routes/routes_name.dart';
import 'package:care_route/views/pages/agreements/agreements_page.dart';
import 'package:care_route/views/pages/agreements/permissions_page.dart';
import 'package:care_route/views/pages/login_page.dart';
import 'package:care_route/views/pages/splash_page.dart';
import 'package:care_route/views/pages/user_info_page.dart';
import 'package:flutter/material.dart';

import '../app.dart';
import '../views/pages/my_page/target_connection_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String? type = settings.arguments as String?;
    switch (settings.name) {
      case RoutesName.app:
        return PageRouter(
            builder: (BuildContext context) =>
                App(initialPageType: type ?? 'TARGET'));
      case RoutesName.splash:
        return PageRouter(
            builder: (BuildContext context) => const SplashPage());
      case RoutesName.login:
        return PageRouter(builder: (BuildContext context) => const LoginPage());
      case RoutesName.userInfo:
        return PageRouter(
            builder: (BuildContext context) => const UserInfoPage());
      case RoutesName.agreements:
        return PageRouter(
            builder: (BuildContext context) => const AgreementsPage());
      case RoutesName.permissions:
        return PageRouter(
            builder: (BuildContext context) => const PermissionsPage());
      case RoutesName.targetConnection:
        return PageRouter(
            builder: (BuildContext context) =>
                const TargetConnectionPage());
      default:
        return PageRouter(
            builder: (BuildContext context) =>
                App(initialPageType: type ?? 'TARGET'));
    }
  }
}
