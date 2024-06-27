import 'package:flutter/material.dart';
import 'navigations/bottom_navigation.dart';

class App extends StatefulWidget {
  final String initialPageType;

  const App({super.key, required this.initialPageType});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          if (currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = DateTime.now();
            return false;
          }
          return true;
        },
        child: BottomNavigation(userType: widget.initialPageType),
      ),
    );
  }
}
