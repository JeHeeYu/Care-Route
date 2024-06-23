import 'package:care_route/views/pages/search/search_page.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../../services/odsay_route_service.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/button_image.dart';

class RoutingPage extends StatefulWidget {
  final String? startTitle;
  final double? startX;
  final double? startY;
  final String? endTitle;
  final double? endX;
  final double? endY;

  const RoutingPage({
    super.key,
    this.startTitle,
    this.startX,
    this.startY,
    this.endTitle,
    this.endX,
    this.endY,
  });

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  late String _startLocation;
  late String _arriveLocation;
  late double? _startX;
  late double? _startY;
  late double? _endX;
  late double? _endY;
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _routeData;

  @override
  void initState() {
    super.initState();
    _startLocation = widget.startTitle ?? "";
    _arriveLocation = widget.endTitle ?? "";
    _startX = widget.startX;
    _startY = widget.startY;
    _endX = widget.endX;
    _endY = widget.endY;
  }

  void _navigateToSearchPage(String from) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );

    if (result != null) {
      setState(() {
        if (from == 'start') {
          _startLocation = result['title'];
          _startX = result['longitude'];
          _startY = result['latitude'];
        } else if (from == 'arrive') {
          _arriveLocation = result['title'];
          _endX = result['longitude'];
          _endY = result['latitude'];
        }
        _fetchRouteIfReady();
      });
    }
  }

  void _fetchRouteIfReady() {
    if (_startX != null && _startY != null && _endX != null && _endY != null) {
      _fetchRoute();
    }
  }

  void _fetchRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await OdsayRouteService.fetchRoute(
        _startX!,
        _startY!,
        _endX!,
        _endY!,
      );
      setState(() {
        _routeData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
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
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        UserText(
                          text: Strings.start,
                          color: const Color(UserColors.gray05),
                          weight: FontWeight.w700,
                          size: ScreenUtil().setSp(16.0),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                        UserText(
                          text: (_startLocation.isEmpty) ? Strings.rouingStartGuide : _startLocation,
                          color: (_startLocation.isEmpty) ? const Color(UserColors.gray04) : const Color(UserColors.gray07),
                          weight: FontWeight.w700,
                          size: ScreenUtil().setSp(16.0),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                      ],
                    ),
                    ButtonIcon(
                      icon: Icons.arrow_back_ios,
                      iconColor: const Color(UserColors.gray05),
                      callback: () => Navigator.of(context).pop(),
                    ),
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
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12.0)),
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
                      callback: () => Navigator.of(context).pop(),
                    ),
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
          if (_isLoading) CircularProgressIndicator(),
          if (_routeData != null) ...[
            Text('Route Data:'),
            Text(_routeData.toString()),
          ],
          if (_errorMessage.isNotEmpty) Text('Error: $_errorMessage'),
        ],
      ),
    );
  }
}
