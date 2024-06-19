import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight weight;
  final double size;
  final bool? softWrap;
  final TextOverflow? overflow;

  const UserText({
    Key? key,
    required this.text,
    required this.color,
    required this.weight,
    required this.size,
    this.softWrap,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: softWrap,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: "Pretendard",
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}