import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../consts/colors.dart';
import '../../consts/strings.dart';
import '../widgets/infinity_button.dart';
import '../widgets/user_text.dart';

class EmergencyCallPage extends StatefulWidget {
  const EmergencyCallPage({super.key});

  @override
  State<EmergencyCallPage> createState() => EmergencyCallStatePage();
}

class EmergencyCallStatePage extends State<EmergencyCallPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF27676),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(80.0)),
                    UserText(
                      text: Strings.emergencyCallGuide,
                      color: const Color(UserColors.gray01),
                      weight: FontWeight.w700,
                      size: ScreenUtil().setSp(20.0),
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(36.0)),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(ScreenUtil().radius(260.0),
                              ScreenUtil().radius(260.0)),
                          painter: CirclePainter(_controller),
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            int secondsLeft =
                                (15 - (_controller.value * 15)).ceil();
                            return Text(
                              '$secondsLeft초',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(60.0),
                                fontWeight: FontWeight.w800,
                                fontFamily: "Pretendard",
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(36.0)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
            child: Column(
              children: [
                InfinityButton(
                  height: ScreenUtil().setHeight(56.0),
                  radius: ScreenUtil().radius(8.0),
                  backgroundColor: const Color(0xFFF27676),
                  text: Strings.immediatelyCall,
                  textSize: ScreenUtil().setSp(16.0),
                  textColor: Colors.white,
                  textWeight: FontWeight.w600,
                  borderColor: Colors.white,
                  // callback: () => _isButtonEnabled()
                  //     ? _navigateToConnectionPage(context)
                  //     : null,
                ),
                SizedBox(height: ScreenUtil().setHeight(16.0)),
                InfinityButton(
                  height: ScreenUtil().setHeight(56.0),
                  radius: ScreenUtil().radius(8.0),
                  backgroundColor: Colors.white,
                  text: Strings.cancelEmergencyCall,
                  textSize: ScreenUtil().setSp(16.0),
                  textColor: const Color(0xFFF27676),
                  textWeight: FontWeight.w600,
                  // callback: () => _isButtonEnabled()
                  //     ? _navigateToConnectionPage(context)
                  //     : null,
                ),
                SizedBox(height: ScreenUtil().setHeight(16.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Animation<double> _animation;

  CirclePainter(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFFA0A0)
      ..style = PaintingStyle.fill;

    final Paint blackPaint = Paint()
      ..color = const Color(0xFFDB5C5C)
      ..style = PaintingStyle.fill;

    double progress = _animation.value;
    double sweepAngle = 2 * 3.141592653589793238 * progress;

    Rect rect = Offset.zero & size;
    canvas.drawArc(
        rect, -3.141592653589793238 / 2, sweepAngle, true, blackPaint);
    canvas.drawArc(rect, sweepAngle - 3.141592653589793238 / 2,
        2 * 3.141592653589793238 - sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
