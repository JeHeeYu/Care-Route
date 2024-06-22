import 'package:care_route/views/pages/schedule/target_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../../view_models/routine_view_model.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/button_image.dart';
import '../../widgets/infinity_button.dart';
import '../../widgets/user_text.dart';
import '../search/search_page.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();
  List<TextEditingController> _destinationControllers = [
    TextEditingController()
  ];
  String _startLocation = "";
  late RoutineViewModel _routineViewModel;

  @override
  void initState() {
    super.initState();
    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
  }

  void _navigateToSearchPage(String from, [int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );

    if (result != null) {
      setState(() {
        if (from == 'startLocation') {
          _startLocation = result['title'];
        } else if (from == 'destination' && index != null) {
          _destinationControllers[index].text = result['title'];
        }
      });
    }
  }

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
          child: TextField(
            controller: _contentsController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.scheduleTitleHint,
              hintStyle: TextStyle(
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtil().setSp(16.0),
                color: const Color(UserColors.gray05),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20.0),
                  vertical: ScreenUtil().setHeight(18.5)),
            ),
            style: TextStyle(
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(16.0),
              color: Colors.black,
            ),
            maxLines: 3,
            minLines: 1,
          ),
        ),
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
        GestureDetector(
          onTap: () => _navigateToSearchPage('startLocation'),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(56.0),
            decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20.0)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: UserText(
                    text: (_startLocation.isEmpty)
                        ? Strings.scheduleStartDestinationHint
                        : _startLocation,
                    color: (_startLocation.isEmpty)
                        ? const Color(UserColors.gray05)
                        : const Color(UserColors.gray07),
                    weight: FontWeight.w400,
                    size: ScreenUtil().setSp(16.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestination(int index) {
    final numberList = ['❶', '❷', '❸'];

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
            if (index == 0 && _destinationControllers.length < 3)
              ButtonIcon(
                icon: Icons.add,
                iconColor: const Color(UserColors.pointGreen),
                callback: _addDestination,
              ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        GestureDetector(
          onTap: () => _navigateToSearchPage('destination', index),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(56.0),
            decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: Container(
              width: MediaQuery.of(context).size.width / 2 -
                  (ScreenUtil().setWidth(20.0)),
              height: ScreenUtil().setHeight(56.0),
              decoration: BoxDecoration(
                color: const Color(UserColors.gray02),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(20.0)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      UserText(
                          text: (_destinationControllers[index].text.isEmpty)
                              ? numberList[index]
                              : '',
                          color: const Color(UserColors.gray05),
                          weight: FontWeight.w400,
                          size: ScreenUtil().setSp(26.0)),
                      SizedBox(width: ScreenUtil().setWidth(4.0)),
                      UserText(
                          text: (_destinationControllers[index].text.isEmpty)
                              ? Strings.scheduleEndDestinationHint
                              : _destinationControllers[index].text,
                          color: (_destinationControllers[index].text.isEmpty)
                              ? const Color(UserColors.gray05)
                              : const Color(UserColors.gray07),
                          weight: FontWeight.w400,
                          size: ScreenUtil().setSp(16.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        _buildDateWidget(),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(56.0),
          decoration: BoxDecoration(
              color: const Color(UserColors.gray02),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
          child: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(20.0)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: UserText(
                  text: Strings.scheduleStartTimeHint,
                  color: const Color(UserColors.gray05),
                  weight: FontWeight.w400,
                  size: ScreenUtil().setSp(16.0)),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(56.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(UserColors.pointGreen),
                  width: 1.0,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0))),
            child: Center(
              child: UserText(
                  text: Strings.setRoute,
                  color: const Color(UserColors.pointGreen),
                  weight: FontWeight.w700,
                  size: ScreenUtil().setSp(16.0)),
            )),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
      ],
    );
  }

  Widget _buildDateWidget() {
    return Container(
      width: double.infinity,
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

  void _addDestination() {
    if (_destinationControllers.length < 3) {
      setState(() {
        _destinationControllers.add(TextEditingController());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TargetListWidget(isBackKey: true),
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
                    ...List.generate(_destinationControllers.length,
                        (index) => _buildDestination(index)),
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
