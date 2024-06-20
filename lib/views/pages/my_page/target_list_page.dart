import 'package:care_route/views/widgets/back_app_bar.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/strings.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/infinity_button.dart';

class TargetListPage extends StatefulWidget {
  const TargetListPage({super.key});

  @override
  State<TargetListPage> createState() => _TargetListPageState();
}

class _TargetListPageState extends State<TargetListPage> {
  Widget _buildTargetListText() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28.0),
          bottom: ScreenUtil().setHeight(8.0)),
      child: UserText(
          text: Strings.targetList,
          color: const Color(UserColors.gray06),
          weight: FontWeight.w700,
          size: ScreenUtil().setSp(16.0)),
    );
  }

  Widget _buildTargetList() {
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
                  ClipOval(
                    child: Container(
                      color: Colors.red,
                      width: ScreenUtil().setWidth(40.0),
                      height: ScreenUtil().setHeight(40.0),
                      child: Container(),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(12.0)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserText(
                          text: "닉네임",
                          color: const Color(UserColors.gray07),
                          weight: FontWeight.w400,
                          size: ScreenUtil().setSp(16.0)),
                      SizedBox(height: ScreenUtil().setHeight(2.0)),
                      UserText(
                          text: "닉네임",
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
                // callback: () => _deleteBookMark(bookmarkId)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(isRight: true),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTargetListText(),
                    _buildTargetList(),
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
              backgroundColor: const Color(UserColors.pointGreen),
              text: Strings.addTarget,
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
