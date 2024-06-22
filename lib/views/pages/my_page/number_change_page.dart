import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../widgets/infinity_button.dart';
import '../../widgets/user_text.dart';

class NumberChangePage extends StatefulWidget {
  const NumberChangePage({super.key});

  @override
  State<NumberChangePage> createState() => _NumberChangePageState();
}

class _NumberChangePageState extends State<NumberChangePage> {
  final TextEditingController _currentNumberController =
      TextEditingController();
  final TextEditingController _afterNumberController = TextEditingController();
  final TextEditingController _authNumberController = TextEditingController();

  bool _getButtonEnableState() {
    return _currentNumberController.text.isNotEmpty &&
        _afterNumberController.text.isNotEmpty &&
        _authNumberController.text.isNotEmpty;
  }

  Widget _buildTextFieldWidget(
      TextEditingController controller,
      String hintText,
      TextInputType inputType,
      List<TextInputFormatter> inputFormatters) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w400,
          fontSize: ScreenUtil().setSp(16.0),
          color: const Color(UserColors.gray07),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20.0),
            vertical: ScreenUtil().setHeight(18.5)),
      ),
      style: TextStyle(
        fontFamily: "Pretendard",
        fontWeight: FontWeight.w400,
        fontSize: ScreenUtil().setSp(16.0),
        color: const Color(UserColors.gray07),
      ),
      maxLines: 1,
      onChanged: (text) {
        setState(() {});
      },
    );
  }

  Widget _currentInputGuide() {
    return UserText(
      text: Strings.currentNumberGuide,
      color: const Color(UserColors.gray06),
      weight: FontWeight.w700,
      size: ScreenUtil().setSp(16.0),
    );
    ;
  }

  Widget _buildInputPhoneNumber() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: _buildTextFieldWidget(
        _currentNumberController,
        Strings.inputPhoneNumberHint,
        TextInputType.number,
        [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _changeInputGuide() {
    return UserText(
      text: Strings.changeNumber,
      color: const Color(UserColors.gray06),
      weight: FontWeight.w700,
      size: ScreenUtil().setSp(16.0),
    );
    ;
  }

  Widget _buildSendCertificationNumber() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(56.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(UserColors.pointGreen),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
      ),
      child: Center(
        child: UserText(
          text: Strings.sendCertificationNumber,
          color: const Color(UserColors.pointGreen),
          weight: FontWeight.w700,
          size: ScreenUtil().setSp(16.0),
        ),
      ),
    );
  }

  Widget _buildInpuAfterNumber() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: _buildTextFieldWidget(
        _afterNumberController,
        Strings.changeNumberGuide,
        TextInputType.number,
        [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildInputAuthNumber() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: _buildTextFieldWidget(
        _authNumberController,
        Strings.certificationNumberHint,
        TextInputType.text,
        [LengthLimitingTextInputFormatter(4)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(isRight: true),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _currentInputGuide(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildInputPhoneNumber(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _changeInputGuide(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildSendCertificationNumber(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildInpuAfterNumber(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildInputAuthNumber(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(20.0)),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(16.0)),
            child: InfinityButton(
              height: ScreenUtil().setHeight(56.0),
              radius: ScreenUtil().radius(8.0),
              backgroundColor: _getButtonEnableState()
                  ? const Color(UserColors.pointGreen)
                  : const Color(UserColors.gray03),
              text: Strings.appStart,
              textSize: ScreenUtil().setSp(16.0),
              textColor: const Color(UserColors.gray01),
              textWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
