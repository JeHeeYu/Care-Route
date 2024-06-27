import 'dart:async';
import 'package:care_route/consts/images.dart';
import 'package:care_route/views/pages/route_start_page.dart';
import 'package:care_route/views/pages/search/search_page.dart';
import 'package:care_route/views/widgets/destination_dialog.dart';
import 'package:care_route/views/widgets/button_image.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../consts/colors.dart';
import '../../consts/strings.dart';
import '../../models/routine/schedule_list_model.dart';
import '../../services/naver_search_service.dart';
import '../../view_models/route_view_model.dart';
import '../../view_models/routine_view_model.dart';
import '../widgets/button_icon.dart';
import '../widgets/infinity_button.dart';
import 'favorite_page.dart';

class RouteGuidePage extends StatefulWidget {
  const RouteGuidePage({super.key});

  @override
  State<RouteGuidePage> createState() => _RouteGuidePageState();
}

class _RouteGuidePageState extends State<RouteGuidePage> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> _mapControllerCompleter = Completer();
  Position? _currentPosition;
  final TextEditingController _destinationController = TextEditingController();
  bool _destinationDialogOpen = false;
  NMarker? _currentMarker;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  Timer? _timer;
  late RouteViewModel _routeViewModel;
  late RoutineViewModel _routineViewModel;
  bool _isStart = true;
  List<Destination> _todayDestinations = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _speech = stt.SpeechToText();

    _routeViewModel = Provider.of<RouteViewModel>(context, listen: false);
    _routineViewModel = Provider.of<RoutineViewModel>(context, listen: false);
    _checkTodayStart();
  }

  Future<void> _initializeMap() async {
    Position position = await getCurrentLocation();
    setState(() {
      _currentPosition = position;
    });
  }

  void _checkTodayStart() {
    int length = _routineViewModel.scheduleList.data?.routines.length ?? 0;
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (int i = 0; i < length; i++) {
      if (_routineViewModel.scheduleList.data?.routines[i].startDate == today) {
        setState(() {
          _isStart = true;
          _todayDestinations =
              _routineViewModel.scheduleList.data?.routines[i].destinations ??
                  [];
        });
        return;
      }
    }

    setState(() {
      _isStart = false;
    });
  }

  void _setCameraCurrentLocation() {
    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(_currentPosition?.latitude ?? 0.0,
          _currentPosition?.longitude ?? 0.0),
      zoom: 16,
      bearing: 0,
    );

    _mapController.updateCamera(cameraUpdate);
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void _showDestinationDialog() {
    setState(() {
      _destinationDialogOpen = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DestinationDialog(
          onStartListening: _startListening,
          onStopListening: _stopListening,
        );
      },
    ).then((_) {
      setState(() {
        _destinationDialogOpen = false;
      });
      _stopListening();
    });

    _startListening();
    _resetTimer();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _destinationController.text = val.recognizedWords;
          _resetTimer();
        }),
        localeId: 'ko_KR',
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _cancelTimer();
  }

  void _resetTimer() {
    _cancelTimer();
    _timer = Timer(const Duration(seconds: 4), () {
      if (_destinationDialogOpen) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _destinationDialogOpen = false;
        });
        _stopListening();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  void _showFavoriteScreen(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritePage(title: title)),
    );
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage(isRoute: true)),
    );
  }

  void _navigateToStartPage() {
    NaverSearchService.getAddressFromCoordinates(
      _currentPosition?.latitude ?? 0.0,
      _currentPosition?.longitude ?? 0.0,
    ).then((address) {
    }).catchError((error) {
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteStartPage(
          mapController: _mapController,
          destinations: _todayDestinations,
          currentPosition: _currentPosition,
        ),
      ),
    );
  }

  void _isStartFalse() {
    setState(() {
      _isStart = false;
    });
  }

  Widget _buildNaverMap() {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
              target: NLatLng(_currentPosition?.latitude ?? 0.0,
                  _currentPosition?.longitude ?? 0.0),
              zoom: 16,
              bearing: 0,
              tilt: 0),
          indoorEnable: true,
          locationButtonEnable: true,
          consumeSymbolTapEvents: false,
          locale: const Locale('ko'),
          logoClickEnable: false,
        ),
        onMapReady: (controller) async {
          _mapController = controller;
          if (!_mapControllerCompleter.isCompleted) {
            _mapControllerCompleter.complete(controller);
            _mapController
                .setLocationTrackingMode(NLocationTrackingMode.follow);
          }

          NOverlayImage markerImage =
              const NOverlayImage.fromAssetImage(Images.defaultMarker);
          final marker = NMarker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            position: NLatLng(_currentPosition?.latitude ?? 0.0,
                _currentPosition?.longitude ?? 0.0),
            icon: markerImage,
            size:
                Size(ScreenUtil().setWidth(40.0), ScreenUtil().setHeight(44.0)),
          );

          _mapController.addOverlay(marker);
          _currentMarker = marker;
        },
        onMapTapped: (point, latLng) {
          NOverlayImage markerImage =
              const NOverlayImage.fromAssetImage(Images.defaultMarker);
          final marker = NMarker(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            position: latLng,
            icon: markerImage,
            size:
                Size(ScreenUtil().setWidth(40.0), ScreenUtil().setHeight(44.0)),
          );

          if (_currentMarker != null) {
            _mapController.clearOverlays();
          }

          _mapController.addOverlay(marker);
          _currentMarker = marker;

          print('Marker added at: ${latLng.latitude}, ${latLng.longitude}');
        },
      );
    }
  }

  Widget _buildFavoriteList() {
    return SizedBox(
      height: ScreenUtil().setHeight(48.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _routeViewModel.getBookMarkData.data?.bookmarks.length ?? 0,
        itemBuilder: (context, index) {
          var bookmark = _routeViewModel.getBookMarkData.data!.bookmarks[index];
          return GestureDetector(
            onTap: () => _showFavoriteScreen(bookmark.title ?? ''),
            child: Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(8.0)),
              child: IntrinsicWidth(
                child: Container(
                  height: ScreenUtil().setHeight(48.0),
                  decoration: BoxDecoration(
                    color: const Color(UserColors.gray02),
                    border: Border.all(
                      color: const Color(UserColors.gray04),
                      width: 1.0,
                    ),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(28.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonIcon(
                          icon: Icons.star_border,
                          iconSize: ScreenUtil().setWidth(25.0),
                          iconColor: const Color(UserColors.pointGreen),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(8.0)),
                        UserText(
                            text: bookmark.title ?? '',
                            color: const Color(UserColors.gray07),
                            weight: FontWeight.w700,
                            size: ScreenUtil().setSp(16.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationInputBox() {
    return Positioned(
      top: ScreenUtil().setHeight(40.0),
      left: ScreenUtil().setWidth(16.0),
      right: ScreenUtil().setWidth(16.0),
      child: GestureDetector(
        onTap: _navigateToSearchPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(48.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(UserColors.gray03),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserText(
                        text: Strings.destinationHint,
                        color: const Color(UserColors.gray04),
                        weight: FontWeight.w700,
                        size: ScreenUtil().setSp(16.0)),
                    ButtonImage(
                      imagePath: Images.mic,
                      callback: _destinationDialogOpen
                          ? () {}
                          : _showDestinationDialog,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: _buildFavoriteList()),
                ButtonImage(
                  imagePath: (_destinationDialogOpen == false)
                      ? Images.favoriteEnable
                      : Images.favoriteDisable,
                  callback: _destinationDialogOpen
                      ? () {}
                      : () => _showFavoriteScreen(""),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationEnableButton() {
    return Positioned(
      bottom: ScreenUtil().setHeight(66.0),
      right: ScreenUtil().setWidth(16.0),
      child: ButtonImage(
        imagePath: (_destinationDialogOpen == false)
            ? Images.locationEnable
            : Images.locationDisable,
        callback:
            _destinationDialogOpen ? () {} : () => _setCameraCurrentLocation(),
      ),
    );
  }

  Widget _buildRouteStartWidget() {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(40.0),
          left: ScreenUtil().setWidth(16.0),
          right: ScreenUtil().setWidth(16.0)),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(142.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(UserColors.gray03),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(16.0),
              horizontal: ScreenUtil().setWidth(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      UserText(
                          text: Strings.scheduleStartGuide1,
                          color: const Color(UserColors.gray07),
                          weight: FontWeight.w700,
                          size: ScreenUtil().setSp(16.0)),
                      UserText(
                          text: Strings.scheduleStartColorGuide1,
                          color: const Color(UserColors.pointGreen),
                          weight: FontWeight.w700,
                          size: ScreenUtil().setSp(16.0)),
                      UserText(
                          text: Strings.scheduleStartGuide3,
                          color: const Color(UserColors.gray07),
                          weight: FontWeight.w700,
                          size: ScreenUtil().setSp(16.0)),
                    ],
                  ),
                  ButtonIcon(
                      icon: Icons.close,
                      iconColor: const Color(UserColors.gray05),
                      iconSize: ScreenUtil().setWidth(20.0),
                      callback: () => _isStartFalse()),
                ],
              ),
              UserText(
                  text: Strings.scheduleStartGuide2,
                  color: const Color(UserColors.gray07),
                  weight: FontWeight.w700,
                  size: ScreenUtil().setSp(16.0)),
              SizedBox(height: ScreenUtil().setHeight(12.0)),
              InfinityButton(
                height: ScreenUtil().setHeight(56.0),
                radius: ScreenUtil().radius(8.0),
                backgroundColor: const Color(UserColors.pointGreen),
                text: Strings.routeStart,
                textSize: ScreenUtil().setSp(16.0),
                textColor: Colors.white,
                textWeight: FontWeight.w600,
                callback: () => _navigateToStartPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildNaverMap(),
          (_isStart == true)
              ? _buildRouteStartWidget()
              : _buildDestinationInputBox(),
          _buildLocationEnableButton(),
        ],
      ),
    );
  }
}
