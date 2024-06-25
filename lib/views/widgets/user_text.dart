import 'package:flutter/material.dart';

class UserText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight weight;
  final double size;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? height; // Optional height parameter

  const UserText({
    Key? key,
    required this.text,
    required this.color,
    required this.weight,
    required this.size,
    this.softWrap,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: softWrap,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: "Pretendard",
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}
