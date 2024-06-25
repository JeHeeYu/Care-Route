import 'package:care_route/views/pages/my_page/target_connection_page.dart';
import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:care_route/views/widgets/complete_dialog.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../consts/colors.dart';
import '../../../../consts/strings.dart';
import '../../../../view_models/routine_view_model.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/infinity_button.dart';

class TargetListPage extends StatefulWidget {
  final String userType;

  const TargetListPage({Key? key, required this.userType}) : super(key: key);

  @override
  State<TargetListPage> createState() => _TargetConnectionListPageState();
}

class _TargetConnectionListPageState extends State<TargetListPage> {
  late RoutineViewModel _routineViewModel;

  @override
  void initState() {
    super.initState();
    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
  }

  void _deleteTarget(int index) async {
    int memberId =
        _routineViewModel.targetList.data?.targetInfos[index].memberId ?? -1;
    Map<String, dynamic> data = {Strings.targetIdKey: memberId};

    if (memberId == -1) {
      CompleteDialog.showCompleteDialog(context, Strings.retryGuide);
    } else {
      final result = await _routineViewModel.targetDelete(data);

      if(result == 200) {
        CompleteDialog.showCompleteDialog(context, Strings.deleteComplete);
        _routineViewModel.getTargetList();
      }
    }
  }

  void _navigateToConnectionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TargetConnectionPage()),
    );
  }

  Widget _buildTargetListText() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28.0),
          bottom: ScreenUtil().setHeight(8.0)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: UserText(
            text: Strings.targetList,
            color: const Color(UserColors.gray06),
            weight: FontWeight.w700,
            size: ScreenUtil().setSp(16.0)),
      ),
    );
  }

  Widget _buildTargetList(int index) {
    String profileImage =
        _routineViewModel.targetList.data?.targetInfos[index].profileImage ??
            '';
    String nickName =
        _routineViewModel.targetList.data?.targetInfos[index].nickname ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8.0)),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(64.0),
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
              Row(
                children: [
                  ClipOval(child: Image.network(profileImage)),
                  SizedBox(width: ScreenUtil().setWidth(12.0)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserText(
                          text: nickName,
                          color: const Color(UserColors.gray07),
                          weight: FontWeight.w400,
                          size: ScreenUtil().setSp(16.0)),
                      SizedBox(height: ScreenUtil().setHeight(2.0)),
                      UserText(
                          text: "안내인",
                          color: const Color(UserColors.gray06),
                          weight: FontWeight.w400,
                          size: ScreenUtil().setSp(12.0)),
                    ],
                  ),
                ],
              ),
              ButtonIcon(
                icon: Icons.close,
                iconColor: Colors.red,
                callback: () => _deleteTarget(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetListEmpty() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(32.0)),
        child: UserText(
            text: Strings.emptyTargetList,
            color: const Color(UserColors.gray06),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(16.0)),
      ),
    );
  }

  Widget _buildGuideText() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
      child: UserText(
          text: (widget.userType == Strings.targetKey)
              ? Strings.targetListGuide
              : Strings.guideListGuide,
          color: const Color(UserColors.gray05),
          weight: FontWeight.w400,
          size: ScreenUtil().setSp(12.0)),
    );
  }

  bool _isButtonEnabled() {
    if (widget.userType == "GUIDE") {
      return true;
    }
    return (_routineViewModel.targetList.data?.targetInfos.length ?? 0) < 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(isRight: true),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTargetListText(),
                  (_routineViewModel.targetList.data?.targetInfos.isNotEmpty ??
                          false)
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _routineViewModel
                                    .targetList.data?.targetInfos.length ??
                                0,
                            itemBuilder: (context, index) {
                              return _buildTargetList(index);
                            },
                          ),
                        )
                      : _buildTargetListEmpty(),
                ],
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(20.0)),
          _buildGuideText(),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(16.0)),
            child: InfinityButton(
              height: ScreenUtil().setHeight(56.0),
              radius: ScreenUtil().radius(8.0),
              backgroundColor: _isButtonEnabled()
                  ? const Color(UserColors.pointGreen)
                  : const Color(UserColors.gray03),
              text: Strings.addTarget,
              textSize: ScreenUtil().setSp(16.0),
              textColor: const Color(UserColors.gray01),
              textWeight: FontWeight.w600,
              callback: () => _isButtonEnabled()
                  ? _navigateToConnectionPage(context)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
