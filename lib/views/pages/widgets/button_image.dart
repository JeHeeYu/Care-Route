import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final VoidCallback callback;

  const ButtonImage({
    Key? key,
    required this.imagePath,
    this.callback = _callback,
    this.width,
    this.height,
  }) : super(key: key);

  static void _callback() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: SvgPicture.asset(
        imagePath,
        width: width != null ? ScreenUtil().setWidth(width!) : null,
        height: height != null ? ScreenUtil().setHeight(height!) : null,
      ),
    );
  }
}
