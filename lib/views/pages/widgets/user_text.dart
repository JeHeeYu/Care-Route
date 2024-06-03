import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight weight;
  final double size;

  const UserText(
      {Key? key,
      required this.text,
      required this.color,
      required this.weight,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Pretendard",
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
