import 'package:care_route/views/pages/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../consts/colors.dart';
import '../../../consts/images.dart';
import '../../../consts/strings.dart';
import '../../widgets/button_icon.dart';
import '../../widgets/button_image.dart';
import '../../../services/odsay_route_service.dart';
import '../../widgets/user_text.dart';

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
  bool _isFinish = false;

  int _selectedRouteTypeIndex = -1;
  List<Map<String, dynamic>> _routes = [];

  @override
  void initState() {
    super.initState();
    _startLocation = widget.startTitle ?? "";
    _arriveLocation = widget.endTitle ?? "";
    _startX = widget.startX;
    _startY = widget.startY;
    _endX = widget.endX;
    _endY = widget.endY;
    _fetchRouteIfReady();
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
        _isFinish = true;

        _routes.clear();

        for (var path in data['result']['path']) {
          List<int> times = [];
          List<String> labels = [];
          int walkTime = 0;
          bool lastWasWalk = false;


          for (var subPath in path['subPath']) {
            int trafficType = subPath['trafficType'];
            int sectionTime = (subPath['sectionTime'] as num).toInt();

            if (trafficType == 1) {
              // 지하철
              if (lastWasWalk && walkTime > 0) {
                labels.add('도보');
                times.add(walkTime);
                walkTime = 0;
              }
              lastWasWalk = false;
              String subwayLine =
                  subPath['lane'][0]['name'].replaceFirst('수도권 ', '');
              labels.add(subwayLine);
              times.add(sectionTime);
            } else if (trafficType == 2) {
              // 버스
              if (lastWasWalk && walkTime > 0) {
                labels.add('도보');
                times.add(walkTime);
                walkTime = 0;
              }
              lastWasWalk = false;
              String busNo = subPath['lane'][0]['busNo'];
              labels.add(busNo);
              times.add(sectionTime);
            } else if (trafficType == 3) {
              // 도보
              walkTime += sectionTime;
              lastWasWalk = true;
            }
          }

          if (lastWasWalk && walkTime > 0) {
            labels.add('도보');
            times.add(walkTime);
          }

          List<int> filteredTimes = [];
          List<String> filteredLabels = [];
          for (int i = 0; i < times.length; i++) {
            if (times[i] > 0) {
              filteredTimes.add(times[i]);
              filteredLabels.add(labels[i]);
            }
          }

          int totalPayment = path['info']['payment'];

          _routes.add({
            'times': filteredTimes,
            'labels': filteredLabels,
            'totalTime': filteredTimes.reduce((a, b) => a + b),
            'totalPayment': totalPayment,
          });
        }

        _routes.sort((a, b) => a['totalTime'].compareTo(b['totalTime']));
        if (_routes.length > 5) {
          _routes = _routes.sublist(0, 5);
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _isFinish = false;
      });
    }
  }

  Color _getSubwayColor(String line) {
    switch (line) {
      case '1호선':
        return Color(UserColors.station1ST);
      case '2호선':
        return Color(UserColors.station2ST);
      case '3호선':
        return Color(UserColors.station3ST);
      case '4호선':
        return Color(UserColors.station4ST);
      case '5호선':
        return Color(UserColors.station5ST);
      case '6호선':
        return Color(UserColors.station6ST);
      case '7호선':
        return Color(UserColors.station7ST);
      case '8호선':
        return Color(UserColors.station8ST);
      case '9호선':
        return Color(UserColors.station9ST);
      case '인천1호선':
        return Color(UserColors.incheon1ST);
      case '인천2호선':
        return Color(UserColors.incheon2ST);
      case '신분당선':
        return Color(UserColors.sinBundangLine);
      case '공항철도':
        return Color(UserColors.airportRailroad);
      case '용인경전철':
        return Color(UserColors.yonginGyeongHeonLine);
      case '경강선':
        return Color(UserColors.gyeonggangLine);
      case '신림선':
        return Color(UserColors.sinlimLine);
      case '수인분당선':
        return Color(UserColors.suinBundangLine);
      case '경의중앙선':
        return Color(UserColors.gyeonguiJungangLine);
      case '경춘선':
        return Color(UserColors.gyungChunLine);
      case '의정부경전철':
        return Color(UserColors.uijeongbuLine);
      case '우이신설선':
        return Color(UserColors.uiSinseolLine);
      case '서해선':
        return Color(UserColors.seohaeLine);
      case '김포도시철도':
        return Color(UserColors.gimpoGoldline);
      default:
        return Colors.grey;
    }
  }

  Color _getBusColor(String busNo) {
    if (RegExp(r'^[가-힣]').hasMatch(busNo)) {
      return Color(UserColors.villageBus);
    } else if (busNo.length == 3) {
      return Color(UserColors.cityBus);
    } else if (busNo.length == 4) {
      return Color(UserColors.intercityBus);
    } else {
      return Colors.red;
    }
  }

  void _onRouteTypeTap(int index) {
    setState(() {
      _selectedRouteTypeIndex = index;
    });
  }

  String destinationTime(int minutes) {
    DateTime now = DateTime.now();

    DateTime newTime = now.add(Duration(minutes: minutes));

    int hour = newTime.hour;
    int minute = newTime.minute;

    String period = hour >= 12 ? "오후" : "오전";

    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    return "$period $hourStr:$minuteStr";
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
                          size: ScreenUtil().setSp(16.0),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(16.0)),
                        UserText(
                          text: (_startLocation.isEmpty)
                              ? Strings.rouingStartGuide
                              : _startLocation,
                          color: (_startLocation.isEmpty)
                              ? const Color(UserColors.gray04)
                              : const Color(UserColors.gray07),
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
                            text: (_arriveLocation.isEmpty)
                                ? Strings.rouingArriveGuide
                                : _arriveLocation,
                            color: (_arriveLocation.isEmpty)
                                ? const Color(UserColors.gray04)
                                : const Color(UserColors.gray07),
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

  Widget _buildRouteTypeWidget() {
    return Container(
      height: ScreenUtil().setHeight(80.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        border: Border.all(
          color: const Color(UserColors.gray03),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _routeType(Icons.access_time, 0),
            _routeType(Icons.directions_bus, 1),
            _routeType(Icons.directions_bike, 2),
            _routeType(Icons.directions_walk, 3),
          ],
        ),
      ),
    );
  }

  Widget _routeType(IconData icon, int index) {
    final isSelected = _selectedRouteTypeIndex == index;
    return GestureDetector(
      onTap: () => _onRouteTypeTap(index),
      child: Container(
        width: ScreenUtil().setWidth(78.0),
        height: ScreenUtil().setHeight(48.0),
        decoration: BoxDecoration(
          color: const Color(UserColors.gray02),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(28.0)),
          border: Border.all(
            color: isSelected
                ? const Color(UserColors.pointGreen)
                : const Color(UserColors.gray04),
          ),
        ),
        child: Center(
          child: Icon(icon,
              color: isSelected
                  ? const Color(UserColors.pointGreen)
                  : const Color(UserColors.gray04),
              size: ScreenUtil().setWidth(30.0)),
        ),
      ),
    );
  }

  Widget _buildRouteResultWidget(
      int routeIndex, List<int> times, List<String> labels, int payment) {
    final numberList = [
      '⓿',
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

    int totalMinutes = times.reduce((value, element) => value + element);
    List<double> percentages =
        times.map((time) => time / totalMinutes).toList();

    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(138.0),
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8.0)),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray02),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16.0),
            vertical: ScreenUtil().setHeight(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserText(
                  text: numberList[routeIndex],
                  color: const Color(UserColors.pointGreen),
                  weight: FontWeight.w700,
                  size: ScreenUtil().setSp(25.0),
                ),
                SizedBox(width: ScreenUtil().setHeight(9.0)),
                _buildTotalTime(totalMinutes),
              ],
            ),
            UserText(
              text: "${destinationTime(totalMinutes)} 도착 예정 / $payment원 예상",
              color: const Color(UserColors.gray06),
              weight: FontWeight.w400,
              size: ScreenUtil().setSp(12.0),
            ),
            SizedBox(height: ScreenUtil().setHeight(8.0)),
            _buildRouteTimeWidget(percentages, labels, times),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalTime(int totalMinutes) {
    if (totalMinutes >= 60) {
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;
      return Row(
        children: [
          UserText(
            text: "$hours",
            color: const Color(UserColors.pointGreen),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(16.0),
          ),
          UserText(
            text: "시간 ",
            color: const Color(UserColors.gray07),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(16.0),
          ),
          UserText(
            text: "$minutes",
            color: const Color(UserColors.pointGreen),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(16.0),
          ),
          UserText(
            text: "분 소요",
            color: const Color(UserColors.gray07),
            weight: FontWeight.w400,
            size: ScreenUtil().setSp(16.0),
          ),
        ],
      );
    } else {
      return UserText(
        text: "$totalMinutes분 소요",
        color: const Color(UserColors.pointGreen),
        weight: FontWeight.w400,
        size: ScreenUtil().setSp(16.0),
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildRouteTimeWidget(
      List<double> percentages, List<String> labels, List<int> times) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(52.0),
      decoration: BoxDecoration(
        color: const Color(UserColors.gray03),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(100.0)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < percentages.length; i++)
            _buildColoredBox(
              percentages[i],
              labels[i] == '도보'
                  ? const Color(UserColors.gray03)
                  : labels[i].contains('호선')
                      ? _getSubwayColor(labels[i])
                      : _getBusColor(labels[i]),
              labels[i],
              times[i],
              i == 0,
              i == percentages.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildColoredBox(double percentage, Color color, String label,
      int time, bool isFirst, bool isLast) {
    return Expanded(
      flex: (percentage * 100).toInt(),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: isFirst || isLast
              ? BorderRadius.only(
                  topLeft: isFirst
                      ? Radius.circular(ScreenUtil().radius(100.0))
                      : Radius.zero,
                  bottomLeft: isFirst
                      ? Radius.circular(ScreenUtil().radius(100.0))
                      : Radius.zero,
                  topRight: isLast
                      ? Radius.circular(ScreenUtil().radius(100.0))
                      : Radius.zero,
                  bottomRight: isLast
                      ? Radius.circular(ScreenUtil().radius(100.0))
                      : Radius.zero,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserText(
              text: label,
              color: const Color(UserColors.gray06),
              weight: FontWeight.w700,
              size: ScreenUtil().setSp(12.0),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ScreenUtil().setHeight(4.0)),
            _buildTimeText(time),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeText(int time) {
    if (time >= 60) {
      int hours = time ~/ 60;
      int minutes = time % 60;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserText(
            text: "$hours",
            color: const Color(UserColors.pointGreen),
            weight: FontWeight.w700,
            size: ScreenUtil().setSp(12.0),
          ),
          UserText(
            text: "시간 ",
            color: const Color(UserColors.gray07),
            weight: FontWeight.w700,
            size: ScreenUtil().setSp(12.0),
          ),
          UserText(
            text: "$minutes",
            color: const Color(UserColors.pointGreen),
            weight: FontWeight.w700,
            size: ScreenUtil().setSp(12.0),
          ),
          UserText(
            text: "분",
            color: const Color(UserColors.gray07),
            weight: FontWeight.w700,
            size: ScreenUtil().setSp(12.0),
          ),
        ],
      );
    } else {
      return UserText(
        text: "$time분",
        color: const Color(UserColors.gray07),
        weight: FontWeight.w700,
        size: ScreenUtil().setSp(12.0),
        overflow: TextOverflow.ellipsis,
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        SizedBox(height: ScreenUtil().setHeight(40.0)),
        _buildDestinationInputBox(),
        SizedBox(height: ScreenUtil().setHeight(6.0)),
        const Divider(
          color: Color(UserColors.gray03),
          thickness: 1.0,
        ),
        SizedBox(height: ScreenUtil().setHeight(16.0)),
        (_isFinish == true) ? _buildRouteTypeWidget() : Container(),
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16.0)),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setHeight(16.0)),
                if (_isLoading) CircularProgressIndicator(),
                if (_routeData != null) ...[
                  for (int i = 0; i < _routes.length; i++)
                    _buildRouteResultWidget(
                      i + 1,
                      _routes[i]['times'],
                      _routes[i]['labels'],
                      _routes[i]['totalPayment'],
                    ),
                ],
                if (_errorMessage.isNotEmpty) Text('Error: $_errorMessage'),
              ],
            ),
          ),
        )),
      ],
    ),
  );
}

}
