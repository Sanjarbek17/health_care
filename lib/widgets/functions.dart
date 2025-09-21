// import http
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
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

// sendMessage function to send message to the user
// IMPORTANT: This function uses deprecated FCM legacy API which is causing 404 errors
// RECOMMENDED SOLUTION: Implement Firebase Cloud Functions or backend API for sending notifications
// For production, consider: https://firebase.google.com/docs/cloud-messaging/send-message
Future<void> sendMessage(Map data) async {
  try {
    // TEMPORARY: Using deprecated legacy endpoint (causing 404 errors)
    // TODO: Replace with Firebase Cloud Functions or backend API
    String url = 'https://fcm.googleapis.com/fcm/send';

    // WARNING: Server key should be stored securely on backend, not in client code
    String serverKey = 'AAAAOnLyMKI:APA91bHwCqvFRCjShbQ58DU3Bxjr4Al0ULdG0RG2ukoYK_KyjzqWntJ_nSPpamESVXy7WS89NK9BePxFaQyCMKaMwD9KMti83cwmOOD1huxgpPaVNpNoI9mBQ-s4V-c_0bihGUNPWHf5';

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map body = {
      "to": "/topics/driver",
      "notification": {"title": "Emergency Help Request", "body": "A user needs immediate assistance"},
      "data": data,
    };

    String bodyEncoded = json.encode(body);
    Uri uri = Uri.parse(url);

    var r = await http.post(uri, body: bodyEncoded, headers: header);

    print('FCM Response Status Code: ${r.statusCode}');

    if (r.statusCode == 200) {
      print('✅ Emergency message sent successfully to drivers');
      // You could show a success snackbar here
    } else if (r.statusCode == 404) {
      print('❌ FCM Legacy API no longer available (404 error)');
      print('📋 Emergency request logged locally');
      print('🔧 Action required: Implement backend notification service');

      // FALLBACK: Log the emergency request locally
      // In a real app, you might want to store this in local database
      // and retry when connection is restored
      _logEmergencyRequestLocally(data);
    } else if (r.statusCode == 401) {
      print('❌ Authentication failed. Invalid server key.');
      _logEmergencyRequestLocally(data);
    } else {
      print('❌ Failed to send emergency message. Status: ${r.statusCode}');
      _logEmergencyRequestLocally(data);
    }
  } catch (e) {
    print('❌ Error sending emergency message: $e');
    print('📋 Logging emergency request locally as fallback');
    _logEmergencyRequestLocally(data);
  }
}

// Fallback function to log emergency requests when FCM fails
void _logEmergencyRequestLocally(Map data) {
  print('🚨 EMERGENCY REQUEST LOGGED:');
  print('   Time: ${DateTime.now()}');
  print('   Data: $data');
  print('   Status: Pending (awaiting backend notification service)');

  // TODO: In production, store this in local database (SQLite/Hive)
  // TODO: Implement retry mechanism when connection is restored
  // TODO: Show user feedback that request was logged and will be retried
}

// Test function to verify FCM setup
Future<void> testFCMSetup() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('🔔 FCM Permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      String? token = await messaging.getToken();
      print('✅ FCM Token received: ${token?.substring(0, 50)}...');

      // Subscribe to topic
      await messaging.subscribeToTopic('driver');
      print('✅ Subscribed to "driver" topic');

      print('🎉 FCM Setup appears to be working correctly!');
      return;
    } else {
      print('❌ FCM Permission denied');
    }
  } catch (e) {
    print('❌ FCM Setup test failed: $e');
    print('💡 This likely means google-services.json is missing or FCM is not enabled');
  }
}
