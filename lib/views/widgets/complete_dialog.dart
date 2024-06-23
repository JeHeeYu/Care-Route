import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteDialog extends StatelessWidget {
  final String title;
  final bool shouldPop;

  const CompleteDialog({
    Key? key,
    required this.title,
    this.shouldPop = true, // 조건부로 pop을 제어하는 플래그
  }) : super(key: key);

  static void showCompleteDialog(BuildContext context, String text, {bool shouldPop = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return CompleteDialog(title: text, shouldPop: shouldPop);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (shouldPop) {
      Timer(const Duration(seconds: 1), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(
        top: ScreenUtil().setHeight(6.0),
        left: ScreenUtil().setWidth(22.0),
        right: ScreenUtil().setWidth(22.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: ScreenUtil().setHeight(50.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(29.0)),
          color: Colors.black.withOpacity(0.6),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
