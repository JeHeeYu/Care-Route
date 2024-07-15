import 'package:care_route/view_models/mypage_view_model.dart';
import 'package:care_route/views/pages/login_page.dart';
import 'package:care_route/views/pages/my_page/number_change_page.dart';
import 'package:care_route/views/pages/my_page/target_list_page.dart';
import 'package:care_route/views/widgets/button_icon.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../widgets/complete_dialog.dart';

class MyPage extends StatefulWidget {
  final String userType;

  const MyPage({Key? key, required this.userType}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late MypageViewModel _mypageViewModel;
  late TextEditingController _nicknameController;
  bool _isEditingNickname = false;

  @override
  void initState() {
    super.initState();

    _mypageViewModel = Provider.of<MypageViewModel>(context, listen: false);
    _nicknameController = TextEditingController(
      text: _mypageViewModel.getMypageData.data?.nickname ?? '',
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditingNickname = !_isEditingNickname;
      if (!_isEditingNickname) {
        _updateNickname();
      }
    });

    Map<String, String> data = { Strings.nicknameKey: _nicknameController.text};

    _mypageViewModel.updateNickname(data);
  }

  void _updateNickname() {
    setState(() {
      _mypageViewModel.getMypageData.data?.nickname = _nicknameController.text;
    });
  }

  Widget _buildNickNameWidget() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(12.0),
          bottom: ScreenUtil().setHeight(32.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isEditingNickname
              ? SizedBox(
                  width: _nicknameController.text.length * 20.0,
                  child: TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(16.0),
                      color: const Color(UserColors.gray07),
                    ),
                    onSubmitted: (value) {
                      _toggleEditing();
                    },
                  ),
                )
              : UserText(
                  text: _mypageViewModel.getMypageData.data?.nickname ?? '',
                  color: const Color(UserColors.gray07),
                  weight: FontWeight.w700,
                  size: ScreenUtil().setSp(16.0)),
          SizedBox(width: ScreenUtil().setWidth(8.0)),
          ButtonIcon(
            icon: Icons.edit,
            iconColor: Color(UserColors.gray05),
            callback: () => _toggleEditing(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentsWidget(String title, Widget page) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8.0)),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        child: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(56.0),
          decoration: BoxDecoration(
            color: const Color(UserColors.gray02),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserText(
                    text: title,
                    color: const Color(UserColors.gray07),
                    weight: FontWeight.w400,
                    size: ScreenUtil().setSp(16.0)),
                const ButtonIcon(
                  icon: Icons.arrow_forward_ios,
                  iconColor: Color(UserColors.pointGreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutAndWithdrawal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            CompleteDialog.showCompleteDialog(context, Strings.logoutComplete);
            _storage.deleteAll();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: UserText(
              text: Strings.logout,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0)),
        ),
        Container(
          width: ScreenUtil().setWidth(1.0),
          height: ScreenUtil().setHeight(12.0),
          color: const Color(UserColors.gray05),
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20.0)),
        ),
        GestureDetector(
          onTap: () {
            CompleteDialog.showCompleteDialog(
                context, Strings.withdrawalComplete);
            _storage.deleteAll();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: UserText(
              text: Strings.withdrawal,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(60.0)),
                    ClipOval(
                      child: Image.network(
                          _mypageViewModel.getMypageData.data?.profileImage ??
                              '',
                          width: ScreenUtil().setWidth(100.0),
                          height: ScreenUtil().setHeight(100.0)),
                    ),
                    _buildNickNameWidget(),
                    _buildContentsWidget(
                        Strings.changePhoneNumber, const NumberChangePage()),
                    _buildContentsWidget(
                        Strings.targetConnection,
                        TargetListPage(
                          userType: widget.userType,
                        )),
                    // _buildContentsWidget(Strings.setEasyAddress, Container()),
                    // _buildContentsWidget(Strings.customerCenter, Container()),
                    // _buildContentsWidget(Strings.notification, Container()),
                    SizedBox(height: ScreenUtil().setHeight(6.0)),
                    _buildLogoutAndWithdrawal(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
