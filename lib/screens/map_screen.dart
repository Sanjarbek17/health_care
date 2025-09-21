// ignore_for_file: must_be_immutable, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/main_provider.dart';
import '../providers/patient_provider.dart';
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

  @override
  void initState() {
    super.initState();

    // TODO: Replace Firebase messaging with WebSocket connection to Flask API

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
    final patientProvider = Provider.of<PatientProvider>(context);

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
                // Show real ambulance location from WebSocket
                if (patientProvider.currentDriverLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: patientProvider.currentDriverLocation!.toLatLng(),
                        width: 40,
                        height: 40,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_hospital,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                // Fallback to old system for backwards compatibility
                driverLocationProvider.isLocationEnabled && patientProvider.currentDriverLocation == null
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
                ),
                // Enhanced ambulance status panel with real data
                if (patientProvider.hasActiveEmergency)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: _buildEmergencyStatusPanel(patientProvider),
                  )
                else if (driverLocationProvider.isLocationEnabled) // Fallback to old panel
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: _buildFallbackStatusPanel(),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  /// Build enhanced emergency status panel with real data
  Widget _buildEmergencyStatusPanel(PatientProvider patientProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(patientProvider.state),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(patientProvider.state),
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getStatusTitle(patientProvider.state),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusBadge(patientProvider.state),
                  style: TextStyle(
                    color: _getStatusColor(patientProvider.state),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (patientProvider.assignedDriver != null || patientProvider.estimatedArrival != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patientProvider.assignedDriver?.name != null ? 'Driver: ${patientProvider.assignedDriver!.name}' : 'Dispatch in progress...',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                if (patientProvider.estimatedArrival != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ETA: ${patientProvider.estimatedArrival} min',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
          if (patientProvider.emergencyStatus.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              patientProvider.emergencyStatus,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
          // Connection status indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                patientProvider.isSocketConnected ? Icons.wifi : Icons.wifi_off,
                color: Colors.white70,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                patientProvider.isSocketConnected ? 'Connected' : 'Offline',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build fallback status panel for backwards compatibility
  Widget _buildFallbackStatusPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_hospital,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '🚑 AMBULANCE DISPATCHED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'EN ROUTE',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'From: Samarkand Central Hospital',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'ETA: ${(8 + (DateTime.now().millisecond % 10))} min',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get status color based on patient state
  Color _getStatusColor(PatientState state) {
    switch (state) {
      case PatientState.idle:
      case PatientState.registering:
      case PatientState.registered:
        return Colors.blue;
      case PatientState.requestingEmergency:
      case PatientState.emergencyRequested:
        return Colors.orange;
      case PatientState.driverAssigned:
      case PatientState.ambulanceEnRoute:
        return Colors.red;
      case PatientState.ambulanceArrived:
        return Colors.green;
      case PatientState.emergencyCompleted:
        return Colors.teal;
      case PatientState.error:
        return Colors.red[900]!;
    }
  }

  /// Get status icon based on patient state
  IconData _getStatusIcon(PatientState state) {
    switch (state) {
      case PatientState.idle:
      case PatientState.registering:
      case PatientState.registered:
        return Icons.person;
      case PatientState.requestingEmergency:
      case PatientState.emergencyRequested:
        return Icons.emergency;
      case PatientState.driverAssigned:
      case PatientState.ambulanceEnRoute:
        return Icons.local_hospital;
      case PatientState.ambulanceArrived:
        return Icons.check_circle;
      case PatientState.emergencyCompleted:
        return Icons.done_all;
      case PatientState.error:
        return Icons.error;
    }
  }

  /// Get status title based on patient state
  String _getStatusTitle(PatientState state) {
    switch (state) {
      case PatientState.idle:
        return 'Ready for Emergency';
      case PatientState.registering:
        return 'Registering Patient...';
      case PatientState.registered:
        return 'Patient Registered';
      case PatientState.requestingEmergency:
        return 'Requesting Emergency...';
      case PatientState.emergencyRequested:
        return 'Emergency Request Sent';
      case PatientState.driverAssigned:
        return '🚑 AMBULANCE ASSIGNED';
      case PatientState.ambulanceEnRoute:
        return '🚑 AMBULANCE EN ROUTE';
      case PatientState.ambulanceArrived:
        return '🏥 AMBULANCE ARRIVED';
      case PatientState.emergencyCompleted:
        return '✅ EMERGENCY COMPLETED';
      case PatientState.error:
        return '❌ ERROR OCCURRED';
    }
  }

  /// Get status badge based on patient state
  String _getStatusBadge(PatientState state) {
    switch (state) {
      case PatientState.idle:
      case PatientState.registered:
        return 'READY';
      case PatientState.registering:
        return 'REGISTERING';
      case PatientState.requestingEmergency:
        return 'REQUESTING';
      case PatientState.emergencyRequested:
        return 'DISPATCHING';
      case PatientState.driverAssigned:
        return 'ASSIGNED';
      case PatientState.ambulanceEnRoute:
        return 'EN ROUTE';
      case PatientState.ambulanceArrived:
        return 'ARRIVED';
      case PatientState.emergencyCompleted:
        return 'COMPLETED';
      case PatientState.error:
        return 'ERROR';
    }
  }
}
