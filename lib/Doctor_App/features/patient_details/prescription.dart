import 'package:flutter/material.dart';
import '../../../services/prescription_service.dart';

class PrescriptionTab extends StatefulWidget {
  final String patientId;

  const PrescriptionTab({super.key, required this.patientId});

  @override
  State<PrescriptionTab> createState() => _PrescriptionTabState();
}

class _PrescriptionTabState extends State<PrescriptionTab> {
  final PrescriptionService service = PrescriptionService();

  void _addPrescription() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddPrescriptionSheet(
        patientId: widget.patientId,
        onSaved: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: service.getPrescriptionsForPatient(widget.patientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final prescriptions = snapshot.data ?? [];

            if (prescriptions.isEmpty) {
              return const Center(child: Text('No prescriptions yet'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final p = prescriptions[index];
                final items = p['prescription_items'] as List;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notes: ${p['notes'] ?? '—'}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        ...items.map((item) {
                          return Text(
                            "• ${item['medicine_name']} "
                            "(${item['dosage']}, "
                            "${item['frequency']}, "
                            "${item['duration']})",
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

        /// Floating Add Button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _addPrescription,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
