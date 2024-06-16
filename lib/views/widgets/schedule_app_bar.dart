import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/widgets/button_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/images.dart';

class ScheduleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback callback;

  const ScheduleAppBar({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(17.0)),
          child: ButtonImage(imagePath: Images.addSchedule, callback: callback),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}