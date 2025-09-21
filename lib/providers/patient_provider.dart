import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/patient_service.dart';
import '../services/socket_service.dart';

enum PatientState { idle, registering, registered, requestingEmergency, emergencyRequested, driverAssigned, ambulanceEnRoute, ambulanceArrived, emergencyCompleted, error }

class PatientProvider with ChangeNotifier {
  // Core patient data
  Patient? _patient;
  EmergencyRequest? _currentEmergencyRequest;
  Driver? _assignedDriver;
  PatientStatus? _patientStatus;

  // State management
  PatientState _state = PatientState.idle;
  String? _errorMessage;
  bool _isLoading = false;

  // Real-time data
  Location? _currentDriverLocation;
  int? _estimatedArrival;
  String _emergencyStatus = '';

  // Socket service
  final SocketService _socketService = SocketService();
  StreamSubscription? _driverAssignedSub;
  StreamSubscription? _driverLocationSub;
  StreamSubscription? _ambulanceArrivedSub;
  StreamSubscription? _emergencyStatusSub;
  StreamSubscription? _connectionStatusSub;

  // Getters
  Patient? get patient => _patient;
  EmergencyRequest? get currentEmergencyRequest => _currentEmergencyRequest;
  Driver? get assignedDriver => _assignedDriver;
  PatientStatus? get patientStatus => _patientStatus;
  PatientState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  Location? get currentDriverLocation => _currentDriverLocation;
  int? get estimatedArrival => _estimatedArrival;
  String get emergencyStatus => _emergencyStatus;
  bool get isSocketConnected => _socketService.isConnected;

  // Convenience getters
  bool get isRegistered => _patient != null;
  bool get hasActiveEmergency => _currentEmergencyRequest != null;
  bool get hasAssignedDriver => _assignedDriver != null;
  String? get patientId => _patient?.patientId;

  PatientProvider() {
    _initializeSocketConnection();
  }

  /// Initialize WebSocket connection and listeners
  Future<void> _initializeSocketConnection() async {
    await _socketService.connect();
    _setupSocketListeners();
  }

  /// Setup WebSocket event listeners
  void _setupSocketListeners() {
    _driverAssignedSub = _socketService.driverAssignedStream.listen(
      (data) {
        _handleDriverAssigned(data);
      },
      onError: (error) {
        if (kDebugMode) print('Error in driver assigned stream: $error');
      },
    );

    _driverLocationSub = _socketService.driverLocationUpdateStream.listen(
      (location) {
        _currentDriverLocation = location;
        notifyListeners();
      },
      onError: (error) {
        if (kDebugMode) print('Error in driver location stream: $error');
      },
    );

    _ambulanceArrivedSub = _socketService.ambulanceArrivedStream.listen(
      (data) {
        _handleAmbulanceArrived(data);
      },
      onError: (error) {
        if (kDebugMode) print('Error in ambulance arrived stream: $error');
      },
    );

    _emergencyStatusSub = _socketService.emergencyStatusUpdateStream.listen(
      (data) {
        _handleEmergencyStatusUpdate(data);
      },
      onError: (error) {
        if (kDebugMode) print('Error in emergency status stream: $error');
      },
    );

    _connectionStatusSub = _socketService.connectionStatusStream.listen(
      (isConnected) {
        notifyListeners();
      },
    );
  }

  /// Register patient with the system
  Future<bool> registerPatient({String? customPatientId}) async {
    _setLoading(true);
    _setState(PatientState.registering);
    _clearError();

    try {
      _patient = await PatientService.registerPatientWithCurrentLocation(
        customPatientId: customPatientId,
      );

      // Register with WebSocket
      if (_patient != null) {
        _socketService.registerPatient(
          patientId: _patient!.patientId,
          location: _patient!.location,
        );
      }

      _setState(PatientState.registered);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to register patient: $e');
      _setState(PatientState.error);
      _setLoading(false);
      return false;
    }
  }

  /// Request emergency assistance
  Future<bool> requestEmergencyAssistance(EmergencyType emergencyType) async {
    _setLoading(true);
    _setState(PatientState.requestingEmergency);
    _clearError();

    try {
      // If not registered, register first
      if (_patient == null) {
        final registered = await registerPatient();
        if (!registered) return false;
      }

      // Create emergency request
      _currentEmergencyRequest = await PatientService.createEmergencyRequestWithCurrentLocation(
        patientId: _patient!.patientId,
        emergencyType: emergencyType,
      );

      // Send via WebSocket for real-time dispatch
      _socketService.sendEmergencyRequest(
        patientId: _patient!.patientId,
        location: _patient!.location,
        emergencyType: emergencyType,
      );

      _setState(PatientState.emergencyRequested);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to request emergency assistance: $e');
      _setState(PatientState.error);
      _setLoading(false);
      return false;
    }
  }

  /// Update patient location
  Future<void> updateLocation(Location newLocation) async {
    if (_patient != null) {
      _patient = Patient(
        patientId: _patient!.patientId,
        location: newLocation,
        registrationTime: _patient!.registrationTime,
        status: _patient!.status,
      );

      // Update via WebSocket
      _socketService.updatePatientLocation(
        patientId: _patient!.patientId,
        location: newLocation,
      );

      notifyListeners();
    }
  }

  /// Get current patient status from API
  Future<void> refreshPatientStatus() async {
    if (_patient == null) return;

    try {
      _patientStatus = await PatientService.getPatientStatus(_patient!.patientId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error refreshing patient status: $e');
    }
  }

  /// Handle driver assigned event
  void _handleDriverAssigned(Map<String, dynamic> data) {
    try {
      _assignedDriver = Driver.fromJson(data);
      _estimatedArrival = data['estimated_arrival'];
      _emergencyStatus = 'Driver Assigned';
      _setState(PatientState.driverAssigned);
    } catch (e) {
      if (kDebugMode) print('Error handling driver assigned: $e');
    }
  }

  /// Handle ambulance arrived event
  void _handleAmbulanceArrived(Map<String, dynamic> data) {
    _emergencyStatus = 'Ambulance Arrived';
    _setState(PatientState.ambulanceArrived);
  }

  /// Handle emergency status update
  void _handleEmergencyStatusUpdate(Map<String, dynamic> data) {
    _emergencyStatus = data['status'] ?? '';

    switch (data['status']?.toLowerCase()) {
      case 'en_route':
      case 'en route':
        _setState(PatientState.ambulanceEnRoute);
        break;
      case 'arrived':
        _setState(PatientState.ambulanceArrived);
        break;
      case 'completed':
        _setState(PatientState.emergencyCompleted);
        break;
    }
  }

  /// Clear current emergency and reset state
  void clearEmergency() {
    _currentEmergencyRequest = null;
    _assignedDriver = null;
    _currentDriverLocation = null;
    _estimatedArrival = null;
    _emergencyStatus = '';
    _setState(_patient != null ? PatientState.registered : PatientState.idle);
  }

  /// Reset all patient data
  void resetPatient() {
    _patient = null;
    _currentEmergencyRequest = null;
    _assignedDriver = null;
    _patientStatus = null;
    _currentDriverLocation = null;
    _estimatedArrival = null;
    _emergencyStatus = '';
    _setState(PatientState.idle);
    _clearError();
  }

  /// Private helper methods
  void _setState(PatientState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _driverAssignedSub?.cancel();
    _driverLocationSub?.cancel();
    _ambulanceArrivedSub?.cancel();
    _emergencyStatusSub?.cancel();
    _connectionStatusSub?.cancel();
    _socketService.dispose();
    super.dispose();
  }
}
