import 'package:latlong2/latlong.dart';

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  LatLng toLatLng() {
    return LatLng(lat, lng);
  }

  @override
  String toString() => 'Location(lat: $lat, lng: $lng)';
}

class Patient {
  final String patientId;
  final Location location;
  final DateTime? registrationTime;
  final String? status;

  Patient({
    required this.patientId,
    required this.location,
    this.registrationTime,
    this.status,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patient_id'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      registrationTime: json['registration_time'] != null ? DateTime.tryParse(json['registration_time']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'location': location.toJson(),
      if (registrationTime != null) 'registration_time': registrationTime!.toIso8601String(),
      if (status != null) 'status': status,
    };
  }

  @override
  String toString() => 'Patient(id: $patientId, location: $location, status: $status)';
}

enum EmergencyType { cardiac, trauma, respiratory, neurological, accident, burn, poisoning, bleeding, fall, other }

extension EmergencyTypeExtension on EmergencyType {
  String get value {
    switch (this) {
      case EmergencyType.cardiac:
        return 'cardiac';
      case EmergencyType.trauma:
        return 'trauma';
      case EmergencyType.respiratory:
        return 'respiratory';
      case EmergencyType.neurological:
        return 'neurological';
      case EmergencyType.accident:
        return 'accident';
      case EmergencyType.burn:
        return 'burn';
      case EmergencyType.poisoning:
        return 'poisoning';
      case EmergencyType.bleeding:
        return 'bleeding';
      case EmergencyType.fall:
        return 'fall';
      case EmergencyType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case EmergencyType.cardiac:
        return 'Cardiac Emergency';
      case EmergencyType.trauma:
        return 'Trauma/Injury';
      case EmergencyType.respiratory:
        return 'Breathing Problems';
      case EmergencyType.neurological:
        return 'Neurological Issues';
      case EmergencyType.accident:
        return 'Accident';
      case EmergencyType.burn:
        return 'Burns';
      case EmergencyType.poisoning:
        return 'Poisoning';
      case EmergencyType.bleeding:
        return 'Severe Bleeding';
      case EmergencyType.fall:
        return 'Fall/Fracture';
      case EmergencyType.other:
        return 'Other Emergency';
    }
  }

  static EmergencyType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cardiac':
        return EmergencyType.cardiac;
      case 'trauma':
        return EmergencyType.trauma;
      case 'respiratory':
        return EmergencyType.respiratory;
      case 'neurological':
        return EmergencyType.neurological;
      case 'accident':
        return EmergencyType.accident;
      case 'burn':
        return EmergencyType.burn;
      case 'poisoning':
        return EmergencyType.poisoning;
      case 'bleeding':
        return EmergencyType.bleeding;
      case 'fall':
        return EmergencyType.fall;
      default:
        return EmergencyType.other;
    }
  }
}

class EmergencyRequest {
  final String? requestId;
  final String patientId;
  final Location location;
  final EmergencyType emergencyType;
  final DateTime? timestamp;
  final String? status;
  final String? driverId;
  final String? ambulanceInfo;
  final int? estimatedArrival;

  EmergencyRequest({
    this.requestId,
    required this.patientId,
    required this.location,
    required this.emergencyType,
    this.timestamp,
    this.status,
    this.driverId,
    this.ambulanceInfo,
    this.estimatedArrival,
  });

  factory EmergencyRequest.fromJson(Map<String, dynamic> json) {
    return EmergencyRequest(
      requestId: json['request_id'],
      patientId: json['patient_id'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      emergencyType: EmergencyTypeExtension.fromString(json['emergency_type'] ?? 'other'),
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
      status: json['status'],
      driverId: json['driver_id'],
      ambulanceInfo: json['ambulance_info'],
      estimatedArrival: json['estimated_arrival'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (requestId != null) 'request_id': requestId,
      'patient_id': patientId,
      'location': location.toJson(),
      'emergency_type': emergencyType.value,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (status != null) 'status': status,
      if (driverId != null) 'driver_id': driverId,
      if (ambulanceInfo != null) 'ambulance_info': ambulanceInfo,
      if (estimatedArrival != null) 'estimated_arrival': estimatedArrival,
    };
  }

  @override
  String toString() => 'EmergencyRequest(id: $requestId, patient: $patientId, type: ${emergencyType.value}, status: $status)';
}

class Driver {
  final String driverId;
  final String? name;
  final Location location;
  final String? status;
  final String? ambulanceId;

  Driver({
    required this.driverId,
    this.name,
    required this.location,
    this.status,
    this.ambulanceId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driver_id'] ?? '',
      name: json['name'],
      location: Location.fromJson(json['location'] ?? {}),
      status: json['status'],
      ambulanceId: json['ambulance_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      if (name != null) 'name': name,
      'location': location.toJson(),
      if (status != null) 'status': status,
      if (ambulanceId != null) 'ambulance_id': ambulanceId,
    };
  }

  @override
  String toString() => 'Driver(id: $driverId, name: $name, status: $status)';
}

class PatientStatus {
  final String patientId;
  final String status;
  final EmergencyRequest? currentRequest;
  final Driver? assignedDriver;
  final DateTime lastUpdated;

  PatientStatus({
    required this.patientId,
    required this.status,
    this.currentRequest,
    this.assignedDriver,
    required this.lastUpdated,
  });

  factory PatientStatus.fromJson(Map<String, dynamic> json) {
    return PatientStatus(
      patientId: json['patient_id'] ?? '',
      status: json['status'] ?? '',
      currentRequest: json['current_request'] != null ? EmergencyRequest.fromJson(json['current_request']) : null,
      assignedDriver: json['assigned_driver'] != null ? Driver.fromJson(json['assigned_driver']) : null,
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'status': status,
      if (currentRequest != null) 'current_request': currentRequest!.toJson(),
      if (assignedDriver != null) 'assigned_driver': assignedDriver!.toJson(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() => 'PatientStatus(id: $patientId, status: $status)';
}
