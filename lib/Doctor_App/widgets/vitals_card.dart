import 'package:flutter/material.dart';
import 'package:carelink/core/theme/theme.dart';

class VitalsCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const VitalsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(data['date_time']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          // 🔹 Header
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text(
                "${dateTime.day}/${dateTime.month}/${dateTime.year}  •  ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          // 🔹 Vitals Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _vitalChip("Blood Sugar", "${data['blood_sugar_level']} mg/dL"),
              _vitalChip(
                "Blood Pressure",
                "${data['blood_pressure_systolic']}/${data['blood_pressure_diastolic']} mmHg",
              ),
              _vitalChip(
                "Medication Taken",
                data['medication_taken'] == true ? "Yes" : "No",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Symptoms
          if (data['symptoms'] != null &&
              data['symptoms'].toString().isNotEmpty)
            _infoRow(Icons.report, "Symptoms", data['symptoms']),

          // 🔹 Remarks
          if (data['remarks'] != null && data['remarks'].toString().isNotEmpty)
            _infoRow(Icons.notes, "Remarks", data['remarks']),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _vitalChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.normal),
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
