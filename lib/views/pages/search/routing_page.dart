import 'package:care_route/views/pages/search/search_page.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/button_image.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  String _startLocation = "";
  String _arriveLocation = "";

  void _navigateToSearchPage(String from) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );

    if (result != null) {
      setState(() {
        if (from == 'start') {
          _startLocation = result['title'];
        } else if (from == 'arrive') {
          _arriveLocation = result['title'];
          
        }
      });
    }
  }

  Widget _buildDestinationInputBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => _navigateToSearchPage('start'),
            child: Container(
              height: ScreenUtil().setHeight(56.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                border: Border.all(
                  color: const Color(UserColors.gray03),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        UserText(
                            text: Strings.start,
                            color: const Color(UserColors.gray05),
                            weight: FontWeight.w700,
                            size: ScreenUtil().setSp(16.0)),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                        UserText(
                            text: (_startLocation.isEmpty) ? Strings.rouingStartGuide : _startLocation,
                            color: (_startLocation.isEmpty) ? const Color(UserColors.gray04) : const Color(UserColors.gray07),
                            weight: FontWeight.w700,
                            size: ScreenUtil().setSp(16.0)),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                      ],
                    ),
                    ButtonIcon(
                        icon: Icons.arrow_back_ios,
                        iconColor: const Color(UserColors.gray05),
                        callback: () => Navigator.of(context).pop()),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(8.0)),
          GestureDetector(
            onTap: () => _navigateToSearchPage('arrive'),
            child: Container(
              height: ScreenUtil().setHeight(56.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
                border: Border.all(
                  color: const Color(UserColors.gray03),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        UserText(
                            text: Strings.arrive,
                            color: const Color(UserColors.gray05),
                            weight: FontWeight.w700,
                            size: ScreenUtil().setSp(16.0)),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                        UserText(
                            text: (_arriveLocation.isEmpty) ? Strings.rouingArriveGuide : _arriveLocation,
                            color: (_arriveLocation.isEmpty) ? const Color(UserColors.gray04) : const Color(UserColors.gray07),
                            weight: FontWeight.w700,
                            size: ScreenUtil().setSp(16.0)),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                      ],
                    ),
                    ButtonImage(
                        imagePath: Images.mic,
                        callback: () => Navigator.of(context).pop()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(40.0)),
          _buildDestinationInputBox(),
        ],
      ),
    );
  }
}
