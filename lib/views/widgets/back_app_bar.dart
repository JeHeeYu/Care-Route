import 'package:care_route/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isRight;

  const BackAppBar({super.key, this.isRight = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isRight
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(UserColors.gray03)),
              onPressed: () => Navigator.of(context).pop(),
            ),
      actions: isRight
          ? [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(UserColors.gray03)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ]
          : null,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
