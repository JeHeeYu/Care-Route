import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../widgets/button_icon.dart';
import '../widgets/button_image.dart';
import '../widgets/infinity_button.dart';
import '../widgets/user_text.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();

  Widget _buildTextFieldWidget(
      TextEditingController controller, String hintText, FontWeight weight) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Pretendard",
          fontWeight: weight,
          fontSize: ScreenUtil().setSp(16.0),
          color: const Color(UserColors.gray05),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20.0),
            vertical: ScreenUtil().setHeight(18.5)),
      ),
      style: TextStyle(
        fontFamily: "Pretendard",
        fontWeight: weight,
        fontSize: ScreenUtil().setSp(16.0),
        color: Colors.black,
      ),
      maxLines: 3,
      minLines: 1,
    );
  }

  Widget _buildScheduleTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserText(
          text: Strings.scheduleTitle,
          color: const Color(UserColors.gray05),
          weight: FontWeight.w600,
          size: ScreenUtil().setSp(16.0),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Container(
            decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: _buildTextFieldWidget(_contentsController,
                Strings.scheduleTitleHint, FontWeight.w600)),
      ],
    );
  }

  Widget _buildScheduleContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserText(
          text: Strings.scheduleContents,
          color: const Color(UserColors.gray05),
          weight: FontWeight.w600,
          size: ScreenUtil().setSp(16.0),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Container(
            decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: _buildTextFieldWidget(_titleController,
                Strings.scheduleContentsHint, FontWeight.w400)),
      ],
    );
  }

  Widget _buildStartLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ButtonImage(imagePath: Images.startLocation),
            SizedBox(width: ScreenUtil().setWidth(4.0)),
            UserText(
              text: Strings.startLocation,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w600,
              size: ScreenUtil().setSp(16.0),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Container(
            decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: _buildTextFieldWidget(_titleController,
                Strings.scheduleContentsHint, FontWeight.w400)),
      ],
    );
  }

  Widget _buildDestination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const ButtonImage(imagePath: Images.destination),
                SizedBox(width: ScreenUtil().setWidth(4.0)),
                UserText(
                  text: Strings.destination,
                  color: const Color(UserColors.gray05),
                  weight: FontWeight.w600,
                  size: ScreenUtil().setSp(16.0),
                ),
              ],
            ),
            ButtonIcon(
                icon: Icons.add, iconColor: const Color(UserColors.pointGreen)),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Container(
            decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: _buildTextFieldWidget(_titleController,
                Strings.scheduleContentsHint, FontWeight.w400)),
      ],
    );
  }

  Widget _buildDateWidget() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 -
              (ScreenUtil().setWidth(20.0)),
          height: ScreenUtil().setHeight(56.0),
          decoration: BoxDecoration(
            color: const Color(UserColors.gray02),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
          ),
          child: Center(
            child: UserText(
                text: "2000/12/31",
                color: const Color(UserColors.gray07),
                weight: FontWeight.w400,
                size: ScreenUtil().setSp(16.0)),
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(8.0)),
        Container(
          width: MediaQuery.of(context).size.width / 2 -
              (ScreenUtil().setWidth(20.0)),
          height: ScreenUtil().setHeight(56.0),
          decoration: BoxDecoration(
            color: const Color(UserColors.gray02),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
          ),
          child: Center(
            child: UserText(
                text: "2000/12/31",
                color: const Color(UserColors.gray07),
                weight: FontWeight.w400,
                size: ScreenUtil().setSp(16.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundTripAndOneWay() {
    return Column(
      children: [
        Row(
          children: [
            const ButtonImage(imagePath: Images.directionType),
            SizedBox(width: ScreenUtil().setWidth(4.0)),
            UserText(
              text: Strings.roundTripAndOneWay,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w600,
              size: ScreenUtil().setSp(16.0),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 -
                  (ScreenUtil().setWidth(20.0)),
              height: ScreenUtil().setHeight(56.0),
              decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ButtonImage(imagePath: Images.roundTrip),
                  SizedBox(width: ScreenUtil().setWidth(8.0)),
                  UserText(
                      text: Strings.roundTrip,
                      color: const Color(UserColors.gray07),
                      weight: FontWeight.w700,
                      size: ScreenUtil().setSp(16.0)),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(8.0)),
            Container(
              width: MediaQuery.of(context).size.width / 2 -
                  (ScreenUtil().setWidth(20.0)),
              height: ScreenUtil().setHeight(56.0),
              decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserText(
                        text: Strings.oneWay,
                        color: const Color(UserColors.gray07),
                        weight: FontWeight.w700,
                        size: ScreenUtil().setSp(16.0)),
                    SizedBox(width: ScreenUtil().setWidth(8.0)),
                    const ButtonImage(imagePath: Images.oneWAy),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildScheduleTitle(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildScheduleContents(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildStartLocation(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildDestination(),
                    SizedBox(height: ScreenUtil().setHeight(8.0)),
                    _buildDateWidget(),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    _buildRoundTripAndOneWay(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(16.0)),
            child: InfinityButton(
              height: ScreenUtil().setHeight(56.0),
              radius: ScreenUtil().radius(8.0),
              backgroundColor: const Color(UserColors.pointGreen),
              text: Strings.selectComplete,
              textSize: ScreenUtil().setSp(16.0),
              textColor: Colors.white,
              textWeight: FontWeight.w600,
              // callback: () => _sendType(),
            ),
          ),
        ],
      ),
    );
  }
}
