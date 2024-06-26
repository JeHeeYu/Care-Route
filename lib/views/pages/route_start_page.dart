import 'package:care_route/services/naver_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../consts/strings.dart';
import '../../models/routine/schedule_list_model.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../widgets/button_icon.dart';
import '../widgets/button_image.dart';
import '../widgets/user_text.dart';

class RouteStartPage extends StatefulWidget {
  NaverMapController mapController;
  final List<Destination> destinations;
  Position? currentPosition;

  RouteStartPage({
    Key? key,
    required this.mapController,
    required this.destinations,
    required this.currentPosition,
  }) : super(key: key);

  @override
  State<RouteStartPage> createState() => _RouteStartPageState();
}

class _RouteStartPageState extends State<RouteStartPage> {
  late Future<String> _addressFuture;

  @override
  void initState() {
    super.initState();
    _addressFuture = NaverSearchService.getAddressFromCoordinates(
      widget.currentPosition?.latitude ?? 0.0,
      widget.currentPosition?.longitude ?? 0.0,
    );
  }

  Widget _buildNaverMap() {
    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(
            widget.currentPosition?.latitude ?? 0.0,
            widget.currentPosition?.longitude ?? 0.0,
          ),
          zoom: 18,
        ),
        locationButtonEnable: true,
      ),
      onMapReady: (controller) async {
        widget.mapController = controller;
        widget.mapController
            .setLocationTrackingMode(NLocationTrackingMode.face);
      },
    );
  }

  Widget _buildInputBoxArea() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(176.0),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(40.0)),
        child: Column(
          children: [
            _buildDestinationInputBox(),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
            // Container(
            //   height: ScreenUtil().setHeight(56.0),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
            //     border: Border.all(
            //       color: const Color(UserColors.gray03),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationInputBox() {
    return FutureBuilder<String>(
      future: _addressFuture,
      builder: (context, snapshot) {
        String currentLocationText = 'Loading...';
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            currentLocationText = 'Error: ${snapshot.error}';
          } else if (snapshot.hasData) {
            currentLocationText = snapshot.data!;
          } else {
            currentLocationText = 'No address found';
          }
        }

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                // onTap: () => _navigateToSearchPage('start'),
                child: Container(
                  height: ScreenUtil().setHeight(56.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(8.0)),
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
                        Expanded(
                          child: Row(
                            children: [
                              UserText(
                                text: Strings.start,
                                color: const Color(UserColors.gray05),
                                weight: FontWeight.w700,
                                size: ScreenUtil().setSp(16.0),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(16.0)),
                              Expanded(
                                child: UserText(
                                  text: currentLocationText,
                                  color: const Color(UserColors.gray07),
                                  weight: FontWeight.w700,
                                  size: ScreenUtil().setSp(16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(16.0)),
                            ],
                          ),
                        ),
                        ButtonImage(
                          imagePath: Images.locationIcon,
                          // callback: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(8.0)),
              GestureDetector(
                // onTap: () => _navigateToSearchPage('arrive'),
                child: Container(
                  height: ScreenUtil().setHeight(56.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(8.0)),
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
                        Expanded(
                          child: Row(
                            children: [
                              UserText(
                                text: Strings.arrive,
                                color: const Color(UserColors.gray05),
                                weight: FontWeight.w700,
                                size: ScreenUtil().setSp(16.0),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(16.0)),
                              Expanded(
                                child: UserText(
                                  text: widget.destinations[0].name,
                                  color: const Color(UserColors.gray07),
                                  weight: FontWeight.w700,
                                  size: ScreenUtil().setSp(16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(16.0)),
                            ],
                          ),
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
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildNaverMap(),
          _buildInputBoxArea(),
        ],
      ),
    );
  }
}
