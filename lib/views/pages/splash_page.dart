import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../consts/strings.dart';
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

  @override
  void initState() {
    super.initState();

    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
    _routineViewModel.getTargetList();

    Future.delayed(const Duration(seconds: 3), _checkLoginStatus);
  }

  void _checkLoginStatus() async {
    String? loginInfo = await _storage.read(key: Strings.loginKey);
    String? typeInfo = await _storage.read(key: Strings.typeKey);
    print("Jehee ${loginInfo} ${typeInfo}");
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
