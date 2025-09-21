import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../models/patient_model.dart';

class PatientStatusScreen extends StatefulWidget {
  static const routeName = 'patient-status';

  const PatientStatusScreen({super.key});

  @override
  State<PatientStatusScreen> createState() => _PatientStatusScreenState();
}

class _PatientStatusScreenState extends State<PatientStatusScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh patient status on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().refreshPatientStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Status'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PatientProvider>().refreshPatientStatus();
            },
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          if (!patientProvider.isRegistered) {
            return _buildNotRegisteredView(patientProvider);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await patientProvider.refreshPatientStatus();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientCard(patientProvider),
                  const SizedBox(height: 16),
                  _buildConnectionStatus(patientProvider),
                  const SizedBox(height: 16),
                  if (patientProvider.hasActiveEmergency) ...[
                    _buildEmergencyCard(patientProvider),
                    const SizedBox(height: 16),
                  ],
                  if (patientProvider.hasAssignedDriver) ...[
                    _buildDriverCard(patientProvider),
                    const SizedBox(height: 16),
                  ],
                  _buildStatusHistory(patientProvider),
                  const SizedBox(height: 16),
                  _buildActionButtons(patientProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotRegisteredView(PatientProvider patientProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Not Registered',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You need to register before using emergency services',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: patientProvider.isLoading
                  ? null
                  : () async {
                      final success = await patientProvider.registerPatient();
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully registered!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: patientProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Register Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(PatientProvider patientProvider) {
    final patient = patientProvider.patient!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(patientProvider.state),
              ],
            ),
            const Divider(),
            _buildInfoRow('Patient ID', patient.patientId),
            _buildInfoRow(
              'Location',
              '${patient.location.lat.toStringAsFixed(6)}, ${patient.location.lng.toStringAsFixed(6)}',
            ),
            if (patient.registrationTime != null)
              _buildInfoRow(
                'Registered',
                _formatDateTime(patient.registrationTime!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(PatientProvider patientProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              patientProvider.isSocketConnected ? Icons.wifi : Icons.wifi_off,
              color: patientProvider.isSocketConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              patientProvider.isSocketConnected ? 'Connected to Emergency Services' : 'Disconnected from Emergency Services',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: patientProvider.isSocketConnected ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(PatientProvider patientProvider) {
    final emergency = patientProvider.currentEmergencyRequest!;

    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Active Emergency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Emergency Type', emergency.emergencyType.displayName),
            if (emergency.requestId != null) _buildInfoRow('Request ID', emergency.requestId!),
            if (emergency.timestamp != null) _buildInfoRow('Requested', _formatDateTime(emergency.timestamp!)),
            if (patientProvider.emergencyStatus.isNotEmpty) _buildInfoRow('Status', patientProvider.emergencyStatus),
            if (patientProvider.estimatedArrival != null)
              _buildInfoRow(
                'ETA',
                '${patientProvider.estimatedArrival} minutes',
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(PatientProvider patientProvider) {
    final driver = patientProvider.assignedDriver!;

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_hospital, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Assigned Ambulance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Driver ID', driver.driverId),
            if (driver.name != null) _buildInfoRow('Driver Name', driver.name!),
            if (driver.ambulanceId != null) _buildInfoRow('Ambulance ID', driver.ambulanceId!),
            _buildInfoRow(
              'Current Location',
              patientProvider.currentDriverLocation != null ? '${patientProvider.currentDriverLocation!.lat.toStringAsFixed(6)}, ${patientProvider.currentDriverLocation!.lng.toStringAsFixed(6)}' : '${driver.location.lat.toStringAsFixed(6)}, ${driver.location.lng.toStringAsFixed(6)}',
            ),
            if (driver.status != null) _buildInfoRow('Status', driver.status!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHistory(PatientProvider patientProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Status History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildStatusHistoryItem(
              'Current Status',
              _getStatusText(patientProvider.state),
              DateTime.now(),
              Colors.blue,
            ),
            // Add more history items here if available from API
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(PatientProvider patientProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (patientProvider.hasActiveEmergency) ...[
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to map to see real-time tracking
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.map),
            label: const Text('View on Map'),
          ),
          const SizedBox(height: 12),
        ],
        if (!patientProvider.hasActiveEmergency)
          ElevatedButton.icon(
            onPressed: patientProvider.isLoading
                ? null
                : () {
                    // Navigate back to trigger emergency request
                    Navigator.pop(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.emergency),
            label: const Text('Request Emergency'),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            _showClearDataDialog(context, patientProvider);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.clear_all),
          label: const Text('Clear All Data'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.black87,
                fontWeight: color != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(PatientState state) {
    return Chip(
      label: Text(
        _getStatusText(state),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: _getStatusColor(state),
    );
  }

  Widget _buildStatusHistoryItem(
    String title,
    String status,
    DateTime timestamp,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _formatDateTime(timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, PatientProvider patientProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'This will clear all patient data and emergency requests. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                patientProvider.resetPatient();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(PatientState state) {
    switch (state) {
      case PatientState.idle:
        return 'Idle';
      case PatientState.registering:
        return 'Registering';
      case PatientState.registered:
        return 'Registered';
      case PatientState.requestingEmergency:
        return 'Requesting';
      case PatientState.emergencyRequested:
        return 'Requested';
      case PatientState.driverAssigned:
        return 'Assigned';
      case PatientState.ambulanceEnRoute:
        return 'En Route';
      case PatientState.ambulanceArrived:
        return 'Arrived';
      case PatientState.emergencyCompleted:
        return 'Completed';
      case PatientState.error:
        return 'Error';
    }
  }

  Color _getStatusColor(PatientState state) {
    switch (state) {
      case PatientState.idle:
      case PatientState.registered:
        return Colors.blue;
      case PatientState.registering:
      case PatientState.requestingEmergency:
        return Colors.orange;
      case PatientState.emergencyRequested:
      case PatientState.driverAssigned:
      case PatientState.ambulanceEnRoute:
        return Colors.red;
      case PatientState.ambulanceArrived:
      case PatientState.emergencyCompleted:
        return Colors.green;
      case PatientState.error:
        return Colors.red[900]!;
    }
  }
}
