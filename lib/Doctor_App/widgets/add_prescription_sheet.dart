import '../../../services/prescription_service.dart';
import 'package:flutter/material.dart';

class AddPrescriptionSheet extends StatefulWidget {
  final String patientId;
  final VoidCallback onSaved;

  const AddPrescriptionSheet({
    super.key,
    required this.patientId,
    required this.onSaved,
  });

  @override
  State<AddPrescriptionSheet> createState() => _AddPrescriptionSheetState();
}

class _AddPrescriptionSheetState extends State<AddPrescriptionSheet> {
  final notesCtrl = TextEditingController();
  final PrescriptionService service = PrescriptionService();

  final List<Map<String, String>> medicines = [];

  void _save() async {
    await service.createPrescription(
      patientId: widget.patientId,
      notes: notesCtrl.text,
      medicines: medicines,
    );

    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: notesCtrl,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save Prescription'),
          ),
        ],
      ),
    );
  }
}
