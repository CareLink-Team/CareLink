import 'package:flutter/material.dart';
import '../../../models/patient.dart';
import '../../../models/caretaker.dart';
import '../../../services/profile_service.dart';

class OverviewTab extends StatelessWidget {
  final Patient patient;

  const OverviewTab({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard(
            title: 'Basic Information',
            children: [
              _infoRow('Age', patient.age.toString()),
              _infoRow('Gender', patient.gender),
              _infoRow('Contact', patient.contactNumber),
              _infoRow('Address', patient.address),
            ],
          ),
          const SizedBox(height: 16),
          _infoCard(
            title: 'Medical Information',
            children: [
              _infoRow('Condition', patient.medicalCondition),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<Caretaker?>(
            future: ProfileService().getCaretakerById(patient.caretakerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return const Text('No caretaker assigned');
              }

              final caretaker = snapshot.data!;
              return _infoCard(
                title: 'Caretaker Information',
                children: [
                  _infoRow('Gender', caretaker.gender),
                  _infoRow('Age', caretaker.age.toString()),
                  _infoRow('Contact', caretaker.contactNumber),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
