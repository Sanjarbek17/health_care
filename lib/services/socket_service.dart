import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/patient_model.dart';
import '../utils/api_config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;

  // Stream controllers for different event types
  final _driverAssignedController = StreamController<Map<String, dynamic>>.broadcast();
  final _driverLocationUpdateController = StreamController<Location>.broadcast();
  final _patientLocationUpdateController = StreamController<Location>.broadcast();
  final _ambulanceArrivedController = StreamController<Map<String, dynamic>>.broadcast();
  final _emergencyStatusUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  // Public streams
  Stream<Map<String, dynamic>> get driverAssignedStream => _driverAssignedController.stream;
  Stream<Location> get driverLocationUpdateStream => _driverLocationUpdateController.stream;
  Stream<Location> get patientLocationUpdateStream => _patientLocationUpdateController.stream;
  Stream<Map<String, dynamic>> get ambulanceArrivedStream => _ambulanceArrivedController.stream;
  Stream<Map<String, dynamic>> get emergencyStatusUpdateStream => _emergencyStatusUpdateController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  bool get isConnected => _isConnected;

  /// Initialize and connect to WebSocket
  Future<void> connect() async {
    if (_socket != null && _isConnected) {
      if (kDebugMode) print('🔌 Socket already connected');
      return;
    }

    try {
      _socket = IO.io(
        ApiConfig.webSocketUrl,
        IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect().enableForceNew().build(),
      );

      _setupEventListeners();
      _socket!.connect();

      if (kDebugMode) print('🔌 Attempting to connect to WebSocket...');
    } catch (e) {
      if (kDebugMode) print('❌ Error connecting to WebSocket: $e');
      _connectionStatusController.add(false);
    }
  }

  /// Disconnect from WebSocket
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _isConnected = false;
      _connectionStatusController.add(false);
      if (kDebugMode) print('🔌 Disconnected from WebSocket');
    }
  }

  /// Setup event listeners for WebSocket events
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      _isConnected = true;
      _connectionStatusController.add(true);
      if (kDebugMode) print('✅ Connected to WebSocket');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      _connectionStatusController.add(false);
      if (kDebugMode) print('❌ Disconnected from WebSocket');
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      _connectionStatusController.add(false);
      if (kDebugMode) print('❌ WebSocket connection error: $error');
    });

    // Patient-specific events
    _socket!.on('driver_assigned', (data) {
      if (kDebugMode) print('🚑 Driver assigned: $data');
      _driverAssignedController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('driver_location_update', (data) {
      if (kDebugMode) print('📍 Driver location update: $data');
      try {
        final location = Location.fromJson(data['driver_location']);
        _driverLocationUpdateController.add(location);
      } catch (e) {
        if (kDebugMode) print('❌ Error parsing driver location: $e');
      }
    });

    _socket!.on('ambulance_arrived', (data) {
      if (kDebugMode) print('🏥 Ambulance arrived: $data');
      _ambulanceArrivedController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('emergency_status_update', (data) {
      if (kDebugMode) print('🚨 Emergency status update: $data');
      _emergencyStatusUpdateController.add(Map<String, dynamic>.from(data));
    });

    // General event handler for debugging
    _socket!.onAny((event, data) {
      if (kDebugMode) print('📡 Socket event received: $event with data: $data');
    });
  }

  /// Register patient with WebSocket
  void registerPatient({
    required String patientId,
    required Location location,
  }) {
    if (_socket != null && _isConnected) {
      _socket!.emit('register_patient', {
        'patient_id': patientId,
        'location': location.toJson(),
      });
      if (kDebugMode) print('📝 Patient registered via WebSocket: $patientId');
    } else {
      if (kDebugMode) print('❌ Cannot register patient - not connected to WebSocket');
    }
  }

  /// Send emergency request via WebSocket
  void sendEmergencyRequest({
    required String patientId,
    required Location location,
    required EmergencyType emergencyType,
  }) {
    if (_socket != null && _isConnected) {
      _socket!.emit('emergency_request', {
        'patient_id': patientId,
        'location': location.toJson(),
        'emergency_type': emergencyType.value,
      });
      if (kDebugMode) print('🚨 Emergency request sent via WebSocket: $patientId');
    } else {
      if (kDebugMode) print('❌ Cannot send emergency request - not connected to WebSocket');
    }
  }

  /// Update patient location
  void updatePatientLocation({
    required String patientId,
    required Location location,
  }) {
    if (_socket != null && _isConnected) {
      _socket!.emit('update_location', {
        'user_id': patientId,
        'location': location.toJson(),
        'user_type': 'patient',
      });
      if (kDebugMode) print('📍 Patient location updated via WebSocket: $patientId');
    } else {
      if (kDebugMode) print('❌ Cannot update location - not connected to WebSocket');
    }
  }

  /// Send custom event
  void emit(String event, Map<String, dynamic> data) {
    if (_socket != null && _isConnected) {
      _socket!.emit(event, data);
      if (kDebugMode) print('📤 Custom event sent: $event with data: $data');
    } else {
      if (kDebugMode) print('❌ Cannot send custom event - not connected to WebSocket');
    }
  }

  /// Listen for custom events
  void on(String event, Function(dynamic) handler) {
    if (_socket != null) {
      _socket!.on(event, handler);
      if (kDebugMode) print('👂 Listening for custom event: $event');
    }
  }

  /// Remove custom event listener
  void off(String event) {
    if (_socket != null) {
      _socket!.off(event);
      if (kDebugMode) print('🚫 Stopped listening for event: $event');
    }
  }

  /// Dispose all resources
  void dispose() {
    _driverAssignedController.close();
    _driverLocationUpdateController.close();
    _patientLocationUpdateController.close();
    _ambulanceArrivedController.close();
    _emergencyStatusUpdateController.close();
    _connectionStatusController.close();
    disconnect();
    if (kDebugMode) print('🧹 SocketService disposed');
  }
}
