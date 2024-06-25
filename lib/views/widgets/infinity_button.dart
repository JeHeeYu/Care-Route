import 'package:flutter/material.dart';

class InfinityButton extends StatelessWidget {
  final double height;
  final double radius;
  final Color backgroundColor;
  final String text;
  final double textSize;
  final FontWeight textWeight;
  final Color textColor;
  final VoidCallback callback;
  final Color? borderColor; // borderColor를 선택적으로 받을 수 있도록 변경

  const InfinityButton({
    Key? key,
    required this.height,
    required this.radius,
    required this.backgroundColor,
    required this.text,
    required this.textSize,
    required this.textWeight,
    this.textColor = Colors.black,
    this.callback = _callback,
    this.borderColor,
  }) : super(key: key);

  static void _callback() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: backgroundColor,
              border: borderColor != null ? Border.all(color: borderColor!) : null,
            ),
          ),
          Text(
            text,
            style: TextStyle(
                color: textColor,
                fontFamily: "Pretendard",
                fontWeight: textWeight,
                fontSize: textSize),
          ),
        ],
      ),
    );
  }
}
