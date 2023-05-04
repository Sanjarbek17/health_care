// ignore_for_file: must_be_immutable, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/main_provider.dart';
import '/screens/catalog/catalog_screen.dart';
import 'info/info_screen.dart';
import '../style/my_flutter_app_icons.dart';
import '../widgets/widgets.dart';
import 'constants.dart';
import 'profile/profil_screen.dart';

class HomeScreen extends StatefulWidget with ChangeNotifier {
  HomeScreen({super.key});
  static const routeName = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, ChangeNotifier {
  List<LatLng> polylinePoints = [];

  late final StreamController<LocationMarkerPosition> positionStreamController;
  late final StreamController<LocationMarkerHeading> headingStreamController;

  late bool navigationMode;
  late int pointerCount;

  late FollowOnLocationUpdate _followOnLocationUpdate;
  late TurnOnHeadingUpdate _turnOnHeadingUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  late StreamController<void> _turnHeadingUpStreamController;

  double _currentLat = 39.6548;
  double _currentLng = 66.9597;

  @override
  void initState() {
    super.initState();

    positionStreamController = StreamController()
      ..add(
        LocationMarkerPosition(
          latitude: _currentLat,
          longitude: _currentLng,
          accuracy: 0,
        ),
      );
    headingStreamController = StreamController()
      ..add(
        LocationMarkerHeading(
          heading: 0,
          accuracy: pi * 0.2,
        ),
      );

    navigationMode = false;
    pointerCount = 0;

    _followOnLocationUpdate = FollowOnLocationUpdate.never;
    _turnOnHeadingUpdate = TurnOnHeadingUpdate.never;
    _followCurrentLocationStreamController = StreamController<double?>();
    _turnHeadingUpStreamController = StreamController<void>();
    determinePosition();
    statusPermission();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    positionStreamController.close();
    headingStreamController.close();
    super.dispose();
  }

  void nearestAmbulance(Function func) {
    determinePosition().then((value) {
      getRoutePoints(LatLng(_currentLat, _currentLng), LatLng(value.latitude, value.longitude)).then((value) {
        setState(() {
          polylinePoints = value;
        });
        moveCar(value, func);
      });
    });
  }

  void takeAmbulance() {
    setState(
      () {
        navigationMode = !navigationMode;
        _followOnLocationUpdate = navigationMode ? FollowOnLocationUpdate.always : FollowOnLocationUpdate.never;
        _turnOnHeadingUpdate = navigationMode ? TurnOnHeadingUpdate.always : TurnOnHeadingUpdate.never;
      },
    );
    if (navigationMode) {
      _followCurrentLocationStreamController.add(18);
      _turnHeadingUpStreamController.add(null);
    }
  }

  void moveCar(List<LatLng> polylinePoints, Function func) async {
    await Future.forEach(polylinePoints, (element) async {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        headingStreamController.add(
          LocationMarkerHeading(
            heading: (atan2(element.longitude - _currentLng, element.latitude - _currentLat)) % (pi * 2),
            accuracy: pi * 0.2,
          ),
        );
        _currentLat = element.latitude;
        _currentLat = _currentLat.clamp(-85, 85);
        _currentLng = element.longitude;
        _currentLng = _currentLng.clamp(-180, 180);

        positionStreamController.add(
          LocationMarkerPosition(
            latitude: _currentLat,
            longitude: _currentLng,
            accuracy: 0,
          ),
        );
      });
    });
    func();
  }

  final phoneNumber = Uri.parse('tel:103');
  final smsNumber = Uri.parse('sms:103');

  @override
  Widget build(BuildContext context) {
    // get mapprovider
    final mapProvider = Provider.of<MapProvider>(context);
    if (mapProvider.isRun) {
      print('car is running');
      nearestAmbulance(mapProvider.makeItZero);
      mapProvider.addOne();
    }

    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red,
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        Icons.phone_rounded,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Text(
                      appBarTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ]),
                  // small title text
                  Text(
                    appBarLeadingText,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ]),
          ),
          // change to map widget
          // map widget
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(39.6548, 66.9597),
                zoom: 13,
              ),
              nonRotatedChildren: [
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    backgroundColor: navigationMode ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      takeAmbulance();
                    },
                    child: const Icon(
                      Icons.navigation_outlined,
                    ),
                  ),
                )
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(points: polylinePoints, color: Colors.blue, strokeWidth: 4),
                  ],
                ),
                // the ambulance car
                CurrentLocationLayer(
                  positionStream: positionStreamController.stream,
                  headingStream: headingStreamController.stream,
                  style: LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      // color: Colors.transparent,
                      child: Image.asset('assets/gps_map_car.png'),
                    ),
                    markerDirection: MarkerDirection.heading,
                    markerSize: const Size.square(40),
                    // showAccuracyCircle: false,
                    // showHeadingSector: false,
                    accuracyCircleColor: Colors.black,
                    headingSectorColor: Colors.red,
                  ),
                ),
                // the user marker
                CurrentLocationLayer(
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(child: Icon(Icons.navigation, color: Colors.white)),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                  followCurrentLocationStream: _followCurrentLocationStreamController.stream,
                  turnHeadingUpLocationStream: _turnHeadingUpStreamController.stream,
                  followOnLocationUpdate: _followOnLocationUpdate,
                  turnOnHeadingUpdate: _turnOnHeadingUpdate,
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        elevation: 20,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // we're gonna change this  to active and inactive images
          children: [
            const Spacer(flex: 1),
            IconButton(icon: Image.asset(ambulanceActive), onPressed: () {}),
            const Spacer(flex: 2),
            IconButton(
              icon: Image.asset(spravochnik),
              onPressed: () {
                context.goNamed(CatalogScreen.routeName);
              },
            ),
            const Spacer(flex: 4),
            IconButton(
              icon: Image.asset(info),
              onPressed: () {
                context.goNamed(InfoScreen.routeName);
              },
            ),
            const Spacer(flex: 2),
            IconButton(
              icon: Image.asset(profile),
              onPressed: () {
                context.goNamed(ProfilScreen.routeName);
              },
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: SpeedDial(
          icon: MyFlutterApp.logo1034,
          activeIcon: Icons.close,
          iconTheme: const IconThemeData(color: Colors.red, size: 56),
          visible: true,
          closeManually: false,
          childrenButtonSize: Size(width * 0.9, 70),
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: '102',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.sms),
                title: Text(mainButtonThirdText),
                subtitle: Text(mainButtonThirdSubtitleText, style: TextStyle(fontSize: 10)),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              onTap: () async {
                if (await canLaunchUrl(smsNumber)) {
                  await launchUrl(smsNumber);
                } else {
                  throw 'Could not launch $smsNumber';
                }
              },
            ),
            SpeedDialChild(
              child: const ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.phone_iphone_rounded),
                title: Text(mainButtonSecondText),
                subtitle: Text(
                  mainButtonSecondSubtitleText,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              onTap: () async {
                if (await canLaunchUrl(Uri.parse('tel:+998940086601'))) {
                  await launchUrl(Uri.parse('tel:+998940086601'));
                } else {
                  throw 'Could not launch ${Uri.parse('tel:+998940086601')}';
                }
              },
            ),
            SpeedDialChild(
              child: const ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.place_outlined),
                title: Text(mainButtonFirstText),
                subtitle: Text(mainButtonFirstSubtitleText, style: TextStyle(fontSize: 10)),
              ),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              onTap: () {
                if (!mapProvider.isRun) {
                  nearestAmbulance(mapProvider.makeItZero);
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
