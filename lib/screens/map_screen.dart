import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/widgets.dart';
import 'constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  List<LatLng> polylinePoints = [
    LatLng(39.653971, 66.961304),
    LatLng(39.653831, 66.960754),
  ];

  late AnimationController _controller;
  late Animation<LatLng> _animation;

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
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    positionStreamController.close();
    headingStreamController.close();
    super.dispose();
  }

  void nearestAmbulance() {
    determinePosition().then((value) {
      getRoutePoints(LatLng(_currentLat, _currentLng), LatLng(value.latitude, value.longitude)).then((value) {
        setState(() {
          polylinePoints = value;
        });
        moveCar(value);
      });
    });
  }

  void moveCar(List<LatLng> polylinePoints) {
    Future.forEach(polylinePoints, (element) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // custom app bar
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
          // change to map widget\
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
                      setState(
                        () {
                          navigationMode = !navigationMode;
                          _followOnLocationUpdate = navigationMode ? FollowOnLocationUpdate.always : FollowOnLocationUpdate.never;
                          _turnOnHeadingUpdate = navigationMode ? TurnOnHeadingUpdate.always : TurnOnHeadingUpdate.never;
                        },
                      );
                      if (navigationMode) {
                        // this is only test mode
                        // it is going to be removed
                        nearestAmbulance();
                        _followCurrentLocationStreamController.add(18);
                        _turnHeadingUpStreamController.add(null);
                      }
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
                      child: Image.asset(
                        'assets/gps_map_car.png',
                      ),
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
                    marker: DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
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
    );
  }
}
