import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/schedule/add_schedule_page.dart';
import 'package:care_route/views/pages/schedule/target_list_widget.dart';
import 'package:care_route/views/widgets/button_image.dart';
import 'package:care_route/views/widgets/complete_dialog.dart';
import 'package:care_route/views/widgets/schedule_app_bar.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../../view_models/routine_view_model.dart';

class SchedulePage extends StatefulWidget {
  final String userType;

  const SchedulePage({Key? key, required this.userType}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late RoutineViewModel _routineViewModel;
  final GlobalKey<TargetListWidgetState> _targetListKey = GlobalKey<TargetListWidgetState>();

  @override
  void initState() {
    super.initState();
    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
    _routineViewModel.getScheduleList();
  }

  void _goAddSchedulePage() {
    final selectedMemberId = _targetListKey.currentState?.selectedMemberId;

    if (selectedMemberId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSchedulePage(
            selectedDate: _dateTimeToString(_selectedDay),
            memberId: selectedMemberId,
          ),
        ),
      );
    } else {
      CompleteDialog.showCompleteDialog(context, Strings.pleaseSelectTarget);
    }
  }

  String _dateTimeToString(DateTime time) {
    return DateFormat('yyyy-MM-dd').format(time);
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonImage(
            imagePath: Images.previousMonth,
            callback: () => {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                    );
                  })
                }),
        SizedBox(width: ScreenUtil().setWidth(16.0)),
        Text(
          '${_focusedDay.year}년 ${_focusedDay.month}월',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(24.0),
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(16.0)),
        ButtonImage(
            imagePath: Images.nextMonth,
            callback: () => {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                    );
                  })
                }),
      ],
    );
  }

  Widget _buildCalendarWidget() {
    return Consumer<RoutineViewModel>(
      builder: (context, viewModel, child) {
        return TableCalendar(
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              if (day.weekday == DateTime.sunday) {
                return const Center(
                  child: Text(
                    '일',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              if (day.weekday == DateTime.saturday) {
                return const Center(
                  child: Text(
                    '토',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              }
            },
            todayBuilder: (context, date, _) {
              return Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(16.0)),
                ),
              );
            },
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(16.0)),
                ),
              );
            },
            markerBuilder: (context, date, events) {
              final routines = viewModel.scheduleList.data?.routines ?? [];
              final hasRoutine = routines.any((routine) =>
                  isSameDay(DateTime.parse(routine.startDate), date));

              if (hasRoutine) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(16.0)),
                  ),
                );
              }
              return null;
            },
          ),
          focusedDay: _focusedDay,
          firstDay: DateTime(1900),
          lastDay: DateTime(3000),
          locale: 'ko-KR',
          headerVisible: false,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        );
      },
    );
  }

  Widget _buildScheduleList() {
    final routines = _routineViewModel.scheduleList.data?.routines ?? [];
    final selectedRoutines = routines
        .where((routine) =>
            isSameDay(DateTime.parse(routine.startDate), _selectedDay))
        .toList();

    if (selectedRoutines.isEmpty) {
      return _buildEmptyScheduleWidget();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: selectedRoutines.length,
        itemBuilder: (context, index) {
          final routine = selectedRoutines[index];
          return _buildScheduleWidget(
            routine.title,
            routine.content,
            routine.destinations.first.name,
            routine.startDate,
          );
        },
      );
    }
  }

  Widget _buildScheduleWidget(
      String title, String content, String destination, String startTime) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(123.0),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20.0),
          vertical: ScreenUtil().setHeight(10.0)),
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(5.0),
          horizontal: ScreenUtil().setWidth(16.0)),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray02),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserText(
              text: title,
              color: const Color(UserColors.gray07),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(16.0)),
          SizedBox(height: ScreenUtil().setHeight(4.0)),
          UserText(
              text: content,
              color: const Color(UserColors.gray07),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(16.0)),
          SizedBox(height: ScreenUtil().setHeight(4.0)),
          UserText(
              text: destination,
              color: const Color(UserColors.gray05),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(16.0)),
          SizedBox(height: ScreenUtil().setHeight(12.0)),
          UserText(
              text: startTime,
              color: const Color(UserColors.gray04),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0)),
        ],
      ),
    );
  }

  Widget _buildEmptyScheduleWidget() {
    return Column(
      children: [
        UserText(
            text: Strings.emptySchedule,
            color: const Color(UserColors.gray05),
            weight: FontWeight.w700,
            size: ScreenUtil().setSp(16.0)),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        UserText(
            text: Strings.addSchedule,
            color: const Color(UserColors.gray05),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(12.0)),
        GestureDetector(
          onTap: _goAddSchedulePage,
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(164.0),
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: ScreenUtil().setHeight(8.0),
                  child: Icon(
                    Icons.add,
                    size: ScreenUtil().setSp(30.0),
                    color: const Color(UserColors.gray05),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScheduleAppBar(callback: _goAddSchedulePage),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCalendarHeader(),
            SizedBox(height: ScreenUtil().setHeight(17.0)),
            _buildCalendarWidget(),
            (widget.userType == Strings.guideKey)
                ? TargetListWidget(key: _targetListKey)
                : Container(),
            _buildScheduleList(),
          ],
        ),
      ),
    );
  }
}
