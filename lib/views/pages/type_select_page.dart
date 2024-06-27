import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/agreements/agreements_page.dart';
import 'package:care_route/views/pages/login_page.dart';
import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:care_route/views/widgets/infinity_button.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../consts/strings.dart';
import '../../view_models/member_view_model.dart';

class TypeSelectPage extends StatefulWidget {
  const TypeSelectPage({super.key});

  @override
  State<TypeSelectPage> createState() => _TypeSelectPageState();
}

class _TypeSelectPageState extends State<TypeSelectPage> {
  String? _selectedType;
  late MemberViewModel _memberViewModel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _memberViewModel = Provider.of<MemberViewModel>(context, listen: false);
  }

  void _sendType() async {
    Map<String, dynamic> data = {Strings.typeKey: _selectedType};
    final result = await _memberViewModel.type(data);

    if (!mounted) return;

    if (result == 200) {
      _storage.write(key: Strings.typeKey, value: _selectedType);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AgreementsPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Widget _buildRichText(List<String> texts, List<Color> colors) {
    List<TextSpan> spans = [];
    for (int i = 0; i < texts.length; i++) {
      spans.add(TextSpan(
        text: texts[i],
        style: TextStyle(
          fontFamily: "Pretendard",
          fontSize: ScreenUtil().setSp(16.0),
          fontWeight: FontWeight.w600,
          color: colors[i],
        ),
      ));
    }
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildInfoWidget(List<String> texts, List<Color> colors, String type) {
    bool isSelected = _selectedType == type;
    bool isInitiallySelected = _selectedType == null;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(210.0),
        decoration: BoxDecoration(
          color: isSelected || isInitiallySelected
              ? const Color(UserColors.gray02)
              : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(35.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRichText(
                [texts[0], texts[1]],
                [colors[0], colors[1]],
              ),
              SizedBox(height: ScreenUtil().setHeight(6.0)),
              _buildRichText(
                [texts[2], texts[3], texts[4], texts[5], texts[6]],
                [colors[2], colors[3], colors[4], colors[5], colors[6]],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetWidget() {
    return _buildInfoWidget(
      [
        Strings.typeColorGuide1,
        Strings.typeTargetGuide1,
        Strings.typeTargetGuide2_1,
        Strings.typeTargetColorGuide2_1,
        Strings.typeTargetGuide2_2,
        Strings.typeTargetColorGuide2_2,
        Strings.typeTargetGuide2_3,
      ],
      [
        const Color(UserColors.pointGreen),
        Colors.black,
        Colors.black,
        const Color(UserColors.pointGreen),
        Colors.black,
        const Color(UserColors.pointGreen),
        Colors.black,
      ],
      Strings.targetKey,
    );
  }

  Widget _buildGuiderWidget() {
    return _buildInfoWidget(
      [
        Strings.typeGuiderGuide1_1,
        Strings.typeGuiderColorGuide1_1,
        Strings.typeGuiderGuide1_2,
        Strings.typeGuiderColorGuide1_2,
        Strings.typeGuiderGuide1_3,
        Strings.typeGuiderGuide2_1,
        Strings.typeGuiderColorGuide2_1,
        Strings.typeGuiderGuide2_2,
        Strings.typeGuiderColorGuide2_2,
        Strings.typeGuiderGuide2_3,
      ],
      [
        Colors.black,
        const Color(UserColors.pointGreen),
        Colors.black,
        const Color(UserColors.pointGreen),
        Colors.black,
        Colors.black,
        const Color(UserColors.pointGreen),
        Colors.black,
        const Color(UserColors.pointGreen),
        Colors.black,
      ],
      Strings.guideKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(20.0)),
            UserText(
              text: Strings.typeSelectGuide,
              color: const Color(0xFF6F6F6F),
              weight: FontWeight.w600,
              size: ScreenUtil().setSp(16.0),
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
            Expanded(
              child: Column(
                children: [
                  _buildTargetWidget(),
                  SizedBox(height: ScreenUtil().setHeight(9.0)),
                  _buildGuiderWidget(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16.0)),
              child: InfinityButton(
                height: ScreenUtil().setHeight(56.0),
                radius: ScreenUtil().radius(8.0),
                backgroundColor: _selectedType == null
                    ? const Color(UserColors.gray03)
                    : const Color(UserColors.pointGreen),
                text: Strings.selectComplete,
                textSize: ScreenUtil().setSp(16.0),
                textColor: Colors.white,
                textWeight: FontWeight.w600,
                callback: () => _sendType(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
