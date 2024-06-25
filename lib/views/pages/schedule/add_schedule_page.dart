import 'package:care_route/views/pages/schedule/target_list_widget.dart';
import 'package:care_route/views/widgets/complete_dialog.dart';
import 'package:flutter/cupertino.dart';
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
  final String selectedDate;
  final int memberId;

  const AddSchedulePage({
    super.key,
    required this.selectedDate,
    required this.memberId,
  });

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
  final GlobalKey<TargetListWidgetState> _targetListKey =
      GlobalKey<TargetListWidgetState>();
  String _isRoundTrip = "Y";
  double _startLatitude = 0.0;
  double _startLongitude = 0.0;
  List<Map<String, dynamic>> destinations = [];
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

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
          _startLatitude = result['latitude'];
          _startLongitude = result['longitude'];
        } else if (from == 'destination' && index != null) {
          _destinationControllers[index].text = result['title'];
          if (index < destinations.length) {
            destinations[index]['name'] = result['title'];
            destinations[index]['destinationLatitude'] = result['latitude'];
            destinations[index]['destinationLongitude'] = result['longitude'];
          } else {
            destinations.add({
              'name': result['title'],
              'destinationLatitude': result['latitude'],
              'destinationLongitude': result['longitude'],
              "time": "20:03:02"
            });
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _registSchedule() {
    Map<String, dynamic> data = {
      Strings.targetId: widget.memberId,
      Strings.titleKey: _titleController.text,
      Strings.contentKey: _contentsController.text,
      Strings.startDateKey: widget.selectedDate,
      Strings.endDateKey: widget.selectedDate,
      Strings.startLatitudeKey: _startLatitude,
      Strings.startLogitude: _startLongitude,
      Strings.isRoundTripKey: _isRoundTrip,
      'destinations': destinations,
    };

    _routineViewModel.registSchedule(data).then((statusCode) {
      if (statusCode == 200) {
        _routineViewModel.getScheduleList();
        CompleteDialog.showCompleteDialog(context, Strings.addScheduleComplete);
        Navigator.of(context).pop();
      } else {}
    }).catchError((error) {});
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
                  size: ScreenUtil().setSp(16.0),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestination(int index) {
    final numberList = [
      '❶',
      '❷',
      '❸',
      '❹',
      '❺',
      '❻',
      '❼',
      '❽',
      '❾',
      '❿',
      '⓫',
      '⓬',
      '⓭',
      '⓮',
      '⓯',
      '⓰',
      '⓱',
      '⓲',
      '⓳',
      '⓴'
    ];

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
                      Expanded(
                        child: UserText(
                          text: (_destinationControllers[index].text.isEmpty)
                              ? Strings.scheduleEndDestinationHint
                              : _destinationControllers[index].text,
                          color: (_destinationControllers[index].text.isEmpty)
                              ? const Color(UserColors.gray05)
                              : const Color(UserColors.gray07),
                          weight: FontWeight.w400,
                          size: ScreenUtil().setSp(16.0),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        _buildDateWidget(index),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        GestureDetector(
          onTap: () => _showTimePickerBottomSheet(context),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(56.0),
            decoration: BoxDecoration(
              color: const Color(UserColors.gray02),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(20.0)),
              child: Align(
                alignment: Alignment.center,
                child: UserText(
                  text: _selectedTime != null
                      ? _selectedTime!.format(context)
                      : Strings.scheduleStartTimeHint,
                  color: _selectedTime != null
                      ? const Color(UserColors.gray07)
                      : const Color(UserColors.gray05),
                  weight: FontWeight.w400,
                  size: ScreenUtil().setSp(16.0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        GestureDetector(
          onTap: () => CompleteDialog.showCompleteDialog(
              context, Strings.destinationSet),
          child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(56.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(UserColors.pointGreen),
                    width: 1.0,
                  ),
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().radius(8.0))),
              child: Center(
                child: UserText(
                    text: Strings.setRoute,
                    color: const Color(UserColors.pointGreen),
                    weight: FontWeight.w700,
                    size: ScreenUtil().setSp(16.0)),
              )),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
      ],
    );
  }

  Widget _buildDateWidget(int index) {
    return GestureDetector(
      onTap: () => _showDatePickerBottomSheet(context),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(56.0),
        decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        ),
        child: Center(
          child: UserText(
            text: _selectedDate != null
                ? "${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}"
                : widget.selectedDate,
            color: const Color(UserColors.gray07),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(16.0),
          ),
        ),
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
            GestureDetector(
              onTap: () {
                setState(() {
                  _isRoundTrip = 'Y';
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 -
                    (ScreenUtil().setWidth(20.0)),
                height: ScreenUtil().setHeight(56.0),
                decoration: BoxDecoration(
                  color: (_isRoundTrip == 'Y')
                      ? const Color(UserColors.gray02)
                      : const Color(UserColors.gray03),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonImage(
                        imagePath: (_isRoundTrip == 'Y')
                            ? Images.roundTripEnable
                            : Images.roundTripDisable),
                    SizedBox(width: ScreenUtil().setWidth(8.0)),
                    UserText(
                        text: Strings.roundTrip,
                        color: (_isRoundTrip == 'Y')
                            ? const Color(UserColors.gray07)
                            : const Color(UserColors.gray05),
                        weight: FontWeight.w700,
                        size: ScreenUtil().setSp(16.0)),
                  ],
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(8.0)),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isRoundTrip = 'N';
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 -
                    (ScreenUtil().setWidth(20.0)),
                height: ScreenUtil().setHeight(56.0),
                decoration: BoxDecoration(
                  color: (_isRoundTrip == 'N')
                      ? const Color(UserColors.gray02)
                      : const Color(UserColors.gray03),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserText(
                          text: Strings.oneWay,
                          color: (_isRoundTrip == 'N')
                              ? const Color(UserColors.gray07)
                              : const Color(UserColors.gray05),
                          weight: FontWeight.w700,
                          size: ScreenUtil().setSp(16.0)),
                      SizedBox(width: ScreenUtil().setWidth(8.0)),
                      ButtonImage(
                          imagePath: (_isRoundTrip == 'N')
                              ? Images.oneWAyEnable
                              : Images.oneWAyDisable),
                    ],
                  ),
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

  void _showTimePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: ScreenUtil().setHeight(250.0),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(18.0),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Pretendard",
                ),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(200.0),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _selectedTime = TimeOfDay(
                          hour: newDateTime.hour,
                          minute: newDateTime.minute,
                        );
                      });
                    },
                    use24hFormat: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDatePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: ScreenUtil().setHeight(250.0),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(18.0),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Pretendard",
                ),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(200.0),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _selectedDate = newDateTime;
                      });
                    },
                    dateOrder: DatePickerDateOrder.ymd,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TargetListWidget(
            isBackKey: true,
            key: _targetListKey,
          ),
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
              callback: () => _registSchedule(),
            ),
          ),
        ],
      ),
    );
  }
}
