import 'package:care_route/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../consts/images.dart';
import '../consts/strings.dart';
import '../views/pages/my_page/my_page.dart';
import '../views/pages/notification_page.dart';
import '../views/pages/route_guide_page.dart';
import '../views/pages/schedule/schedule_page.dart';

class BottomNavigation extends StatefulWidget {
  final String userType;

  const BottomNavigation({super.key, required this.userType});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectIndex;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _bottomNavItems;

  @override
  void initState() {
    super.initState();

    if (widget.userType == Strings.guideKey) {
      _selectIndex = 0;
      _pages = [
        SchedulePage(userType: widget.userType),
        const RouteGuidePage(),
        const NotificationPage(),
        MyPage(userType: widget.userType),
      ];
      _bottomNavItems = [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.scheduleDisable),
          activeIcon: SvgPicture.asset(Images.scheduleEnable),
          label: Strings.scheduleManage,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.guideDisable),
          activeIcon: SvgPicture.asset(Images.guideEnable),
          label: Strings.routeGuide,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.notificationDisable),
          activeIcon: SvgPicture.asset(Images.notificationEnable),
          label: Strings.notification,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.myPageDisable),
          activeIcon: SvgPicture.asset(Images.myPageEnable),
          label: Strings.myPage,
        ),
      ];
    } else if (widget.userType == Strings.targetKey) {
      _selectIndex = 0;
      _pages = [
        const RouteGuidePage(),
        SchedulePage(userType: widget.userType),
        const NotificationPage(),
        MyPage(userType: widget.userType),
      ];
      _bottomNavItems = [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.guideDisable),
          activeIcon: SvgPicture.asset(Images.guideEnable),
          label: Strings.routeGuide,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.scheduleDisable),
          activeIcon: SvgPicture.asset(Images.scheduleEnable),
          label: Strings.scheduleManage,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.notificationDisable),
          activeIcon: SvgPicture.asset(Images.notificationEnable),
          label: Strings.notification,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.myPageDisable),
          activeIcon: SvgPicture.asset(Images.myPageEnable),
          label: Strings.myPage,
        ),
      ];
    } else {
      _selectIndex = 0;
      _pages = [
        const RouteGuidePage(),
        SchedulePage(userType: widget.userType),
        const NotificationPage(),
        MyPage(userType: widget.userType),
      ];
      _bottomNavItems = [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.guideDisable),
          activeIcon: SvgPicture.asset(Images.guideEnable),
          label: Strings.routeGuide,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.scheduleDisable),
          activeIcon: SvgPicture.asset(Images.scheduleEnable),
          label: Strings.scheduleManage,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.notificationDisable),
          activeIcon: SvgPicture.asset(Images.notificationEnable),
          label: Strings.notification,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(Images.myPageDisable),
          activeIcon: SvgPicture.asset(Images.myPageEnable),
          label: Strings.myPage,
        ),
      ];
    }
  }

  void _onBottomTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: BottomNavigationBar(
          onTap: _onBottomTapped,
          currentIndex: _selectIndex,
          type: BottomNavigationBarType.fixed,
          items: _bottomNavItems,
          showUnselectedLabels: true,
          selectedItemColor: const Color(UserColors.pointGreen),
          unselectedItemColor: const Color(UserColors.gray04),
          selectedLabelStyle: const TextStyle(
              color: Color(UserColors.pointGreen),
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: 12),
          unselectedLabelStyle: const TextStyle(
              color: Colors.white,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
              fontSize: 12),
        ),
      ),
    );
  }
}
