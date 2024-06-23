import 'package:care_route/view_models/member_view_model.dart';
import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../consts/colors.dart';
import '../../consts/strings.dart';
import '../widgets/infinity_button.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _certificationNumberController =
      TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();

  late MemberViewModel _memberViewModel;

  @override
  void initState() {
    super.initState();
    _memberViewModel = Provider.of<MemberViewModel>(context, listen: false);
  }

  void _sendAuth() {
    Map<String, dynamic> data = {
      Strings.phoneNumberKey: _phoneNumberController.text
    };

    _memberViewModel.auth(data);
  }

  bool _getButtonEnableState() {
    return _phoneNumberController.text.isNotEmpty &&
        _certificationNumberController.text.isNotEmpty &&
        _nickNameController.text.isNotEmpty;
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

  Widget _buildInputPhoneNumber() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: _buildTextFieldWidget(
        _phoneNumberController,
        Strings.inputPhoneNumberHint,
        TextInputType.number,
        [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildSendCertificationNumber() {
    return GestureDetector(
      onTap: () => _sendAuth(),
      child: Container(
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
      ),
    );
  }

  Widget _buildInputCertificationNumber() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: _buildTextFieldWidget(
        _certificationNumberController,
        Strings.certificationNumberHint,
        TextInputType.number,
        [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildInputNickName() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
      child: _buildTextFieldWidget(
        _nickNameController,
        Strings.inputNickNameHint,
        TextInputType.text,
        [LengthLimitingTextInputFormatter(4)],
      ),
    );
  }

  Widget _buildGuideText() {
    return UserText(
      text: Strings.certificationNumberGuide,
      color: const Color(UserColors.gray05),
      weight: FontWeight.w400,
      size: ScreenUtil().setSp(12.0),
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
                    _buildInputPhoneNumber(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildSendCertificationNumber(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildInputCertificationNumber(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildInputNickName(),
                  ],
                ),
              ),
            ),
          ),
          _buildGuideText(),
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
