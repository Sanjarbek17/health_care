// import http
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future statusPermission() async {
  // Test if location services are enabled.
  var status = await Permission.storage.status;

  if (await Permission.storage.isDenied) {
    // Permissions are denied, next time you could try
    // requesting permissions again (this is also where
    // Android's shouldShowRequestPermissionRationale
    // returned true. According to Android guidelines
    // your App should show an explanatory UI now.
    return Future.error('Location permissions are denied');
  }
  Permission.storage.request();
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return status;
}

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end}) : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    return LatLng(begin!.latitude, begin!.longitude);
  }
}

Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
  print('get ruotes started');
  final String apiUrl = 'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248bbbb913eeda14ab1b42f177bd4cb4e2d&start=${start.longitude},${start.latitude},&end=${end.longitude},${end.latitude}&steps=true';

  final response = await http.get(Uri.parse(apiUrl));
  print('serponse');
  print(response.statusCode);
  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);
    // print(decodedData);
    final geometry = decodedData['features'][0]['geometry']['coordinates'];

    final routePoints = <LatLng>[];
    for (final point in geometry) {
      routePoints.add(LatLng(point[1], point[0]));
    }
    return routePoints;
  } else {
    throw Exception('Failed to load route data');
  }
}

// TODO: Implement WebSocket-based emergency notification system
// This will be replaced with Flask API + WebSocket implementation
Future<void> sendEmergencyMessage(Map data) async {
  print('🚨 Emergency message prepared for WebSocket transmission:');
  print('   Time: ${DateTime.now()}');
  print('   Data: $data');
  print('   Status: Ready for WebSocket API implementation');

  // Placeholder for WebSocket implementation
  // Will be replaced with Flask API call + WebSocket real-time updates
}

// Simulate ambulance response with hardcoded locations and timing
Future<Map<String, dynamic>> simulateAmbulanceResponse(Map emergencyData) async {
  print('🚨 SIMULATING AMBULANCE RESPONSE');

  // Hardcoded ambulance starting locations around Samarkand with realistic coordinates
  List<Map<String, dynamic>> ambulanceStations = [
    {'id': 'AMB001', 'name': 'Samarkand Central Hospital', 'lat': 39.6548, 'lng': 66.9597, 'status': 'available', 'crew': 'Dr. Alisher, Nurse Dilnoza'},
    {'id': 'AMB002', 'name': 'Emergency Medical Center', 'lat': 39.6723, 'lng': 66.9447, 'status': 'available', 'crew': 'Dr. Sanjar, Paramedic Aziz'},
    {'id': 'AMB003', 'name': 'Registan Medical Station', 'lat': 39.6445, 'lng': 66.9708, 'status': 'available', 'crew': 'Dr. Malika, Nurse Feruza'},
    {'id': 'AMB004', 'name': 'University Hospital', 'lat': 39.6612, 'lng': 66.9301, 'status': 'available', 'crew': 'Dr. Bobur, Paramedic Jasur'},
    {'id': 'AMB005', 'name': 'City Emergency Station', 'lat': 39.6389, 'lng': 66.9856, 'status': 'available', 'crew': 'Dr. Nilufar, Nurse Kamola'}
  ];

  // Get user location from emergency data
  Map userPosition = emergencyData['position'];
  double userLat = userPosition['latitude'];
  double userLng = userPosition['longitude'];

  print('📍 User location: $userLat, $userLng');

  // Find nearest ambulance (simplified calculation)
  Map<String, dynamic> nearestAmbulance = ambulanceStations[0];
  double shortestDistance = double.infinity;

  for (var ambulance in ambulanceStations) {
    double distance = _calculateDistance(userLat, userLng, ambulance['lat'], ambulance['lng']);

    if (distance < shortestDistance) {
      shortestDistance = distance;
      nearestAmbulance = ambulance;
    }
  }

  print('🚑 Dispatched: ${nearestAmbulance['name']} (${nearestAmbulance['id']})');
  print('👨‍⚕️ Crew: ${nearestAmbulance['crew']}');
  print('📏 Distance: ${shortestDistance.toStringAsFixed(2)} km');

  // Simulate realistic ambulance timing
  int estimatedArrivalMinutes = (shortestDistance * 1.5).round() + 4; // 1.5 min per km + 4 min prep
  estimatedArrivalMinutes = estimatedArrivalMinutes.clamp(6, 20); // Between 6-20 minutes

  // Add some realistic factors
  int timeOfDay = DateTime.now().hour;
  if (timeOfDay >= 7 && timeOfDay <= 9 || timeOfDay >= 17 && timeOfDay <= 19) {
    estimatedArrivalMinutes += 2; // Rush hour delay
    print('⚠️ Rush hour - adding 2 minutes delay');
  }

  print('⏱️ Estimated arrival: $estimatedArrivalMinutes minutes');
  print('🚨 Status: AMBULANCE EN ROUTE');
  print('🔄 Real-time tracking enabled');

  // Return ambulance data for map display
  return {
    'ambulance': nearestAmbulance,
    'userLocation': {'lat': userLat, 'lng': userLng},
    'estimatedArrival': estimatedArrivalMinutes,
    'distance': shortestDistance,
    'dispatchTime': DateTime.now(),
    'status': 'dispatched',
    'trackingEnabled': true,
  };
}

// Helper function to calculate distance between two points (simplified)
double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  // Simplified distance calculation (not accounting for Earth's curvature)
  // For a more accurate calculation, use the Haversine formula
  double deltaLat = lat2 - lat1;
  double deltaLng = lng2 - lng1;
  return sqrt((deltaLat * deltaLat) + (deltaLng * deltaLng)) * 111; // Approximate km
}
