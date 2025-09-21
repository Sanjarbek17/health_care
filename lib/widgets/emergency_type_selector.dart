import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/patient_model.dart';
import '../providers/patient_provider.dart';

class EmergencyTypeSelector extends StatefulWidget {
  final Function(EmergencyType)? onEmergencyTypeSelected;

  const EmergencyTypeSelector({
    super.key,
    this.onEmergencyTypeSelected,
  });

  @override
  State<EmergencyTypeSelector> createState() => _EmergencyTypeSelectorState();
}

class _EmergencyTypeSelectorState extends State<EmergencyTypeSelector> {
  EmergencyType? selectedType;

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.center,
                ),

                const Text(
                  '🚨 Emergency Type',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Please select the type of emergency to help us dispatch the right assistance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Emergency type grid - wrapped with ConstrainedBox to control height
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300, // Limit the height to prevent overflow
                  ),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: EmergencyType.values.map((type) {
                      final isSelected = selectedType == type;
                      return _buildEmergencyTypeCard(type, isSelected);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: selectedType != null && !patientProvider.isLoading ? () => _requestEmergency(patientProvider) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                            : const Text(
                                'REQUEST AMBULANCE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                // Error message
                if (patientProvider.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      patientProvider.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyTypeCard(EmergencyType type, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmergencyIcon(type),
              size: 32,
              color: isSelected ? Colors.red : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              type.displayName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.red : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEmergencyIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.cardiac:
        return Icons.favorite;
      case EmergencyType.trauma:
        return Icons.healing;
      case EmergencyType.respiratory:
        return Icons.air;
      case EmergencyType.neurological:
        return Icons.psychology;
      case EmergencyType.accident:
        return Icons.car_crash;
      case EmergencyType.burn:
        return Icons.local_fire_department;
      case EmergencyType.poisoning:
        return Icons.warning;
      case EmergencyType.bleeding:
        return Icons.bloodtype;
      case EmergencyType.fall:
        return Icons.accessibility_new;
      case EmergencyType.other:
        return Icons.emergency;
    }
  }

  void _requestEmergency(PatientProvider patientProvider) async {
    if (selectedType == null) return;

    try {
      final success = await patientProvider.requestEmergencyAssistance(selectedType!);

      if (success && mounted) {
        widget.onEmergencyTypeSelected?.call(selectedType!);
        Navigator.pop(context, selectedType);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🚑 Emergency request sent for ${selectedType!.displayName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to send emergency request: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

/// Helper function to show emergency type selector
Future<EmergencyType?> showEmergencyTypeSelector(
  BuildContext context, {
  Function(EmergencyType)? onEmergencyTypeSelected,
}) {
  return showModalBottomSheet<EmergencyType>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EmergencyTypeSelector(
      onEmergencyTypeSelected: onEmergencyTypeSelected,
    ),
  );
}
