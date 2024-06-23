import 'package:care_route/view_models/mypage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../consts/strings.dart';
import '../../view_models/route_view_model.dart';
import '../../view_models/routine_view_model.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late RoutineViewModel _routineViewModel;
  late RouteViewModel _routeViewModel;
  late MypageViewModel _mypageViewModel;

  @override
  void initState() {
    super.initState();

    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
    _routeViewModel = Provider.of<RouteViewModel>(context, listen: false);
    _mypageViewModel = Provider.of<MypageViewModel>(context, listen: false);

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _routineViewModel.getTargetList();
      await _routineViewModel.getScheduleList();
      await _routeViewModel.getBookMark();
      await _mypageViewModel.getMypage();

      Future.delayed(const Duration(seconds: 3), _checkLoginStatus);
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _checkLoginStatus() async {
    String? loginInfo = await _storage.read(key: Strings.loginKey);
    String? typeInfo = await _storage.read(key: Strings.typeKey);

    if (!mounted) return;

    if (loginInfo == 'true' && typeInfo != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => App(initialPageType: typeInfo)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
