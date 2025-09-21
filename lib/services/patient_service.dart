import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import '../models/patient_model.dart';
import '../utils/api_config.dart';

class PatientService {
  static const _uuid = Uuid();

  /// Register a new patient with the dispatch system
  static Future<Patient> registerPatient({
    String? customPatientId,
    required Location location,
  }) async {
    try {
      final patientId = customPatientId ?? _uuid.v4();

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.patientRegisterEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'patient_id': patientId,
          'location': location.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Patient.fromJson(responseData);
      } else {
        throw Exception('Failed to register patient: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registering patient: $e');
    }
  }

  /// Create an emergency request
  static Future<EmergencyRequest> createEmergencyRequest({
    required String patientId,
    required Location location,
    required EmergencyType emergencyType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.patientEmergencyEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'patient_id': patientId,
          'location': location.toJson(),
          'emergency_type': emergencyType.value,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return EmergencyRequest.fromJson(responseData);
      } else {
        throw Exception('Failed to create emergency request: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating emergency request: $e');
    }
  }

  /// Get patient status
  static Future<PatientStatus> getPatientStatus(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.patientStatusEndpoint(patientId)}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PatientStatus.fromJson(responseData);
      } else {
        throw Exception('Failed to get patient status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting patient status: $e');
    }
  }

  /// Get system status
  static Future<Map<String, dynamic>> getSystemStatus() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.systemStatusEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get system status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting system status: $e');
    }
  }

  /// Helper method to get current location and create Location object
  static Future<Location> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return Location(
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  /// Register patient with current location
  static Future<Patient> registerPatientWithCurrentLocation({
    String? customPatientId,
  }) async {
    final location = await getCurrentLocation();
    return registerPatient(
      customPatientId: customPatientId,
      location: location,
    );
  }

  /// Create emergency request with current location
  static Future<EmergencyRequest> createEmergencyRequestWithCurrentLocation({
    required String patientId,
    required EmergencyType emergencyType,
  }) async {
    final location = await getCurrentLocation();
    return createEmergencyRequest(
      patientId: patientId,
      location: location,
      emergencyType: emergencyType,
    );
  }

  /// Complete emergency flow: register patient and create emergency request
  static Future<Map<String, dynamic>> requestEmergencyAssistance({
    String? customPatientId,
    required EmergencyType emergencyType,
  }) async {
    try {
      // Step 1: Get current location
      final location = await getCurrentLocation();

      // Step 2: Register patient
      final patient = await registerPatient(
        customPatientId: customPatientId,
        location: location,
      );

      // Step 3: Create emergency request
      final emergencyRequest = await createEmergencyRequest(
        patientId: patient.patientId,
        location: location,
        emergencyType: emergencyType,
      );

      return {
        'patient': patient,
        'emergency_request': emergencyRequest,
        'success': true,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'success': false,
      };
    }
  }
}
