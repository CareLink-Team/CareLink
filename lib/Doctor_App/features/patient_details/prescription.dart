import 'package:flutter/material.dart';
import '../../../services/prescription_service.dart';
import '../../widgets/medicine_prescription.dart';

class PrescriptionTab extends StatefulWidget {
  final String patientId;
  const PrescriptionTab({super.key, required this.patientId});

  @override
  State<PrescriptionTab> createState() => _PrescriptionTabState();
}

class _PrescriptionTabState extends State<PrescriptionTab> {
  final PrescriptionService _service = PrescriptionService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();

  final List<MedicineForm> _medicines = [];
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    _addMedicine(); // start with one medicine row
  }

  void _addMedicine() {
    setState(() {
      _medicines.add(MedicineForm());
    });
  }

  void _removeMedicine(int index) {
    setState(() {
      _medicines.removeAt(index);
    });
  }

  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await _service.createPrescription(
        patientId: widget.patientId,
        notes: _notesController.text,
        medicines: _medicines.map((m) => m.toMap()).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription added successfully')),
      );

      _notesController.clear();
      _medicines.clear();
      _addMedicine();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Write Prescription',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Doctor Notes
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Doctor Notes / Instructions',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Medicines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Medicine Forms
            ..._medicines.asMap().entries.map((entry) {
              final index = entry.key;
              final medicine = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Medicine ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (_medicines.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeMedicine(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      medicine.build(),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addMedicine,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Medicine'),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _savePrescription,
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
