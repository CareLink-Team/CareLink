import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthForm extends StatefulWidget {
  final String patientId;

  const HealthForm({
    super.key,
    required this.patientId,
  });

  @override
  State<HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {
  final _formKey = GlobalKey<FormState>();

  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _remarksController = TextEditingController();

  bool _medicationTaken = false;
  bool _loading = false;

  final List<String> _selectedSymptoms = [];
  final List<String> _allSymptoms = [
    'Fever',
    'Cough',
    'Fatigue',
    'Headache',
    'Breathing Issue',
  ];

  Future<void> _submitHealthData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final supabase = Supabase.instance.client;

      await supabase.from('health_data').insert({
        'patient_id': widget.patientId,
        'date_time': DateTime.now().toIso8601String(),
        'blood_pressure_systolic':
            int.parse(_systolicController.text),
        'blood_pressure_diastolic':
            int.parse(_diastolicController.text),
        'blood_sugar_level':
            double.parse(_bloodSugarController.text),
        'medication_taken': _medicationTaken,
        'symptoms': _selectedSymptoms.join(', '),
        'remarks': _remarksController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health data saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Health Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Blood Pressure (mmHg)'),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _systolicController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: 'Systolic'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolicController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: 'Diastolic'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _bloodSugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Blood Sugar Level',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 16),

              const Text('Symptoms'),
              Wrap(
                spacing: 8,
                children: _allSymptoms.map((s) {
                  final selected = _selectedSymptoms.contains(s);
                  return FilterChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        v
                            ? _selectedSymptoms.add(s)
                            : _selectedSymptoms.remove(s);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Medication Taken'),
                value: _medicationTaken,
                onChanged: (v) {
                  setState(() => _medicationTaken = v);
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitHealthData,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
