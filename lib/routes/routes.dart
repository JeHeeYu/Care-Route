import 'package:care_route/routes/page_router.dart';
import 'package:care_route/routes/routes_name.dart';
import 'package:care_route/views/pages/splash_page.dart';
import 'package:flutter/material.dart';

import '../app.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String? type = settings.arguments as String?;
    switch (settings.name) {
      case RoutesName.app:
        return PageRouter(
            builder: (BuildContext context) => App(initialPageType: type ?? 'TARGET'));
      case RoutesName.splash:
        return PageRouter(
            builder: (BuildContext context) => const SplashPage());
      default:
        return PageRouter(
            builder: (BuildContext context) => App(initialPageType: type ?? 'TARGET'));
    }
  }
}
