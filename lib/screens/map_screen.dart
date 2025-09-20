// ignore_for_file: must_be_immutable, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/main_provider.dart';
import '../widgets/functions.dart';
import 'constants.dart';

class HomeScreen extends StatefulWidget with ChangeNotifier {
  HomeScreen({super.key});
  static const routeName = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, ChangeNotifier {
  List<LatLng> polylinePoints = [LatLng(39.6548, 66.9597)];

  late final StreamController<LocationMarkerPosition> positionStreamController;
  late final StreamController<LocationMarkerHeading> headingStreamController;

  late bool navigationMode;
  late int pointerCount;

  late StreamController<double?> _followCurrentLocationStreamController;
  late MapController _mapController;

  double _currentLat = 39.68056955590667;
  double _currentLng = 66.94095809907301;
  double _userLat = 39.68056955590667;
  double _userLng = 66.94095809907301;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      //  fBg22SJITjWIxwTdvkruzW:APA91bE1cAqAT1u6jBHIZY-YntoEX0K6plOTdAXT6yT5z_5hf-O7E3LuK4IJeMPlk-5LwYpynotpnKqHQ5x1lInyfu0xYpsfYOieTw20c8My3EbifxkjCd-FoK0AjM48RCs0bgF70yAu
      print('fiebase token');
      print(value);
    });
    messaging.unsubscribeFromTopic('driver');
    messaging.subscribeToTopic('user');

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // Map position = jsonDecode(event.data['position']);

      DriverLocationProvider driver = Provider.of<DriverLocationProvider>(context, listen: false);
      // change driver location
      // driver.setLatitude(position['latitude'], position['longitude']);
      // driver location enabled
      driver.setLocationEnabled(true);

      final mapProvider = Provider.of<MapProvider>(context, listen: false);
      if (!mapProvider.isRun) {
        print('car is running');
        nearestAmbulance(mapProvider.makeItZero);
        mapProvider.addOne();
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Ambulance is coming',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      // Map position = jsonDecode(event.data['position']);
      DriverLocationProvider driver = Provider.of<DriverLocationProvider>(context, listen: false);
      // change driver location
      // driver.setLatitude(position['latitude'], position['longitude']);
      // driver location enabled
      driver.setLocationEnabled(true);
      final mapProvider = Provider.of<MapProvider>(context, listen: false);
      if (!mapProvider.isRun) {
        print('car is running');
        nearestAmbulance(mapProvider.makeItZero);
        mapProvider.addOne();
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Ambulance is coming',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

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

    _followCurrentLocationStreamController = StreamController<double?>();
    _mapController = MapController();
    determinePosition();
    statusPermission();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    positionStreamController.close();
    headingStreamController.close();
    super.dispose();
  }

  void _startLocationTracking() async {
    // Track user's real location continuously
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _userLat = position.latitude;
      _userLng = position.longitude;

      // If navigation mode is active, move camera to follow user
      if (navigationMode) {
        _mapController.move(LatLng(_userLat, _userLng), 15);
      }
    });
  }

  void nearestAmbulance(Function func) {
    print('start car');
    determinePosition().then((value) {
      getRoutePoints(LatLng(_currentLat, _currentLng), LatLng(value.latitude, value.longitude)).then((value) {
        print('routes geted');
        setState(() {
          polylinePoints = value;
        });
        moveCar(value, func);
      });
    });
  }

  /// Toggles the navigation mode state and updates the UI accordingly.
  ///
  /// When navigation mode is enabled, this method triggers the following actions:
  /// - Moves the map camera to the user's current location with zoom level 15.
  /// - Enables continuous camera tracking of the user's position through location stream.
  ///
  /// This method should be called when the user chooses to take an ambulance or start navigation.
  void takeAmbulance() async {
    setState(
      () {
        navigationMode = !navigationMode;
      },
    );
    if (navigationMode) {
      // Get current location first, then move camera
      try {
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _userLat = currentPosition.latitude;
        _userLng = currentPosition.longitude;

        // Move camera to user's current location with zoom level 15
        _mapController.move(LatLng(_userLat, _userLng), 15);
      } catch (e) {
        // Fallback to stored location if getting current location fails
        _mapController.move(LatLng(_userLat, _userLng), 15);
      }
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
    // get driver location provider
    final driverLocationProvider = Provider.of<DriverLocationProvider>(context);
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
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(39.6548, 66.9597),
                initialZoom: 13,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.sanjarbek.health_care',
                  maxZoom: 17,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(points: polylinePoints, color: Colors.blue, strokeWidth: 4),
                  ],
                ),
                // the ambulance car
                driverLocationProvider.isLocationEnabled
                    ? CurrentLocationLayer(
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
                      )
                    : Container(),
                // the user marker
                CurrentLocationLayer(
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(child: Icon(Icons.navigation, color: Colors.white)),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
                // Floating action button overlay
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
            ),
          ),
        ]),
      ),
    );
  }
}
