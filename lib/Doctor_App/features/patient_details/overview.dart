import 'package:flutter/material.dart';
import 'package:carelink/core/theme/theme.dart';
import '../../../services/patient_service.dart';

class OverviewTab extends StatelessWidget {
  final String patientId;

  const OverviewTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patientService = PatientService();
    //final profileService = ProfileService();
    // print(patientId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔹 PATIENT INFO
          FutureBuilder<Map<String, dynamic>?>(
            future: patientService.getPatientById(patientId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Patient info not available');
              }

              final data = snapshot.data!;
              final user = data['user_profiles'];

              return _infoCard(
                title: "Patient Information",
                icon: Icons.person,
                items: {
                  "Name": user?['full_name'] ?? 'N/A',
                  "Age": "${data['age'] ?? 'N/A'}",
                  "Gender": data['gender'] ?? 'N/A',
                  "Contact": data['contact_number'] ?? 'N/A',
                  "email": user?['email'] ?? 'N/A',
                  "Address": data['address'] ?? 'N/A',
                  "Condition": data['medical_condition'] ?? 'N/A',
                },
              );
            },
          ),

          const SizedBox(height: 20),

          // 🔹 CARETAKER INFO
          FutureBuilder<Map<String, dynamic>?>(
            future: patientService.getCaretakerByPatientId(patientId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Caretaker info not available');
              }

              final data = snapshot.data!;
              final user = data['user_profiles'];

              return _infoCard(
                title: "Caretaker Information",
                icon: Icons.people,
                items: {
                  "Name": user?['full_name'] ?? 'N/A',
                  "Age": "${data['age'] ?? 'N/A'}",
                  "Gender": data['gender'] ?? 'N/A',
                  "Contact": data['contact_number'] ?? 'N/A',
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Info Card
  Widget _infoCard({
    required String title,
    required IconData icon,
    required Map<String, String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Info rows
          ...items.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.key,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
