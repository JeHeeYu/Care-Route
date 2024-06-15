import 'package:care_route/consts/colors.dart';
import 'package:care_route/views/pages/schedule/add_schedule_page.dart';
import 'package:care_route/views/pages/widgets/button_icon.dart';
import 'package:care_route/views/pages/widgets/button_image.dart';
import 'package:care_route/views/pages/widgets/schedule_app_bar.dart';
import 'package:care_route/views/pages/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../consts/images.dart';
import '../../../consts/strings.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void _goAddSchedulePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSchedulePage()),
    );
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
              style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16.0)),
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
              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16.0)),
            ),
          );
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
            SizedBox(height: ScreenUtil().setHeight(35.0)),
            _buildEmptyScheduleWidget(),
          ],
        ),
      ),
    );
  }
}
