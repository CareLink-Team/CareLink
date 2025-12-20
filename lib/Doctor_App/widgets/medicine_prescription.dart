import 'package:flutter/material.dart';

class MedicineForm {
  final TextEditingController name = TextEditingController();
  final TextEditingController dosage = TextEditingController();
  final TextEditingController frequency = TextEditingController();
  final TextEditingController duration = TextEditingController();

  Widget build() {
    return Column(
      children: [
        _field(name, 'Medicine Name', required: true),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _field(dosage, 'Dosage (e.g. 500mg)')),
            const SizedBox(width: 8),
            Expanded(child: _field(frequency, 'Frequency (e.g. 2x/day)')),
          ],
        ),
        const SizedBox(height: 8),
        _field(duration, 'Duration (e.g. 5 days)'),
      ],
    );
  }

  Map<String, String> toMap() {
    return {
      'medicine_name': name.text,
      'dosage': dosage.text,
      'frequency': frequency.text,
      'duration': duration.text,
    };
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool required = false,
  }) {
    return TextFormField(
      controller: c,
      validator: required
          ? (v) => v == null || v.isEmpty ? 'Required' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
