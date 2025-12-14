import 'package:flutter/material.dart';

class HealthForm extends StatefulWidget {
  const HealthForm({super.key});

  @override
  State<HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final List<String> _symptoms = [];

  final List<String> _allSymptoms = [
    'Fever',
    'Cough',
    'Difficulty Breathing',
    'Fatigue',
  ];

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
              // 👩‍⚕️ Blood Pressure
              const Text('Blood Pressure (mmHg)'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _systolicController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Systolic',
                        prefixIcon: Icon(
                          Icons.arrow_upward,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter systolic';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolicController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Diastolic',
                        prefixIcon: Icon(
                          Icons.arrow_downward,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter diastolic';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ❤️ Heart Rate
              TextFormField(
                controller: _heartRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Heart Rate (bpm)',
                  prefixIcon: Icon(Icons.favorite, color: Color(0xFF1976D2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter heart rate';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 🌡 Temperature
              TextFormField(
                controller: _temperatureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Temperature (°C)',
                  prefixIcon: Icon(Icons.thermostat, color: Color(0xFF1976D2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter temperature';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 🤒 Symptoms Multi-Select
              const Text('Symptoms'),
              Wrap(
                spacing: 8,
                children: _allSymptoms.map((symptom) {
                  final isSelected = _symptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _symptoms.add(symptom);
                        } else {
                          _symptoms.remove(symptom);
                        }
                      });
                    },
                    selectedColor: Colors.blue.shade100,
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // 🔘 Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Health data submitted!')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
