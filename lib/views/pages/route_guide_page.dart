import 'dart:async';
import 'package:care_route/consts/images.dart';
import 'package:care_route/views/pages/search/search_page.dart';
import 'package:care_route/views/widgets/destination_dialog.dart';
import 'package:care_route/views/widgets/button_image.dart';
import 'package:care_route/views/widgets/user_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../consts/colors.dart';
import '../../consts/strings.dart';
import '../../view_models/route_view_model.dart';
import '../widgets/button_icon.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _speech = stt.SpeechToText();

    _routeViewModel = Provider.of<RouteViewModel>(context, listen: false);
  }

  Future<void> _initializeMap() async {
    Position position = await getCurrentLocation();
    setState(() {
      _currentPosition = position;
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

  void _showFavoriteScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritePage()),
    );
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage(isRoute: true)),
    );
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
          return Padding(
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
                        callback: _destinationDialogOpen
                            ? () {}
                            : _showDestinationDialog,
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
                  callback:
                      _destinationDialogOpen ? () {} : _showFavoriteScreen,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildNaverMap(),
          _buildDestinationInputBox(),
          _buildLocationEnableButton(),
        ],
      ),
    );
  }
}
