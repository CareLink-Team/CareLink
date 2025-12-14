import 'package:carelink/services/profile_service.dart';
import 'package:flutter/material.dart';
import '../../../models/healthdata.dart';

class VitalsTab extends StatelessWidget {
  final String patientId;
  const VitalsTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HealthData>>(
      stream: ProfileService().vitalsStream(patientId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final vitals = snapshot.data!;
        if (vitals.isEmpty) {
          return const Center(child: Text('No vitals recorded'));
        }

        final latest = vitals.first;

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latest Vitals',
                    style: Theme.of(context).textTheme.titleMedium),
                const Divider(),
                Text('Blood Pressure: '
                    '${latest.bloodPressureSystolic}/'
                    '${latest.bloodPressureDiastolic}'),
                Text('Blood Sugar: ${latest.bloodSugarLevel}'),
                Text('Medication Taken: ${latest.medicationTaken ? "Yes" : "No"}'),
                Text('Symptoms: ${latest.symptoms}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
