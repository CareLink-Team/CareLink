import 'package:flutter/material.dart';
import '../../../services/patient_service.dart';
import '../../widgets/vitals_card.dart';
import '../../widgets/animated_vital_card.dart';

class VitalsTab extends StatelessWidget {
  final String patientId;

  const VitalsTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final healthService = PatientService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: healthService.getHealthDataByPatientId(patientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _emptyState();
        }

        final vitalsList = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vitalsList.length,
          itemBuilder: (context, index) {
            final data = vitalsList[index];

            return AnimatedVitalsCard(
              delay: index * 120,
              child: VitalsCard(data: data),
            );
          },
        );
      },
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.monitor_heart, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No vitals data available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
