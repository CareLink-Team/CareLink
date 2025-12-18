import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carelink/services/healthdata_service.dart';

class CaretakerHealthData extends StatefulWidget {
  final String caretakerId;
  const CaretakerHealthData({super.key, required this.caretakerId});

  @override
  State<CaretakerHealthData> createState() => _CaretakerHealthDataState();
}

class _CaretakerHealthDataState extends State<CaretakerHealthData> {
  final supabase = Supabase.instance.client;

  bool _loading = true;
  String? _patientId;
  List<Map<String, dynamic>> _healthList = [];

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    try {
      final assignment = await supabase
          .from('caretaker_profiles')
          .select('patient_id')
          .eq('caretaker_id', widget.caretakerId)
          .single();

      _patientId = assignment['patient_id'];

      final data = await HealthDataService().getHealthDataForPatient(
        _patientId!,
      );

      setState(() {
        _healthList = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  // Animated card
  Widget _animatedCard(Widget child, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 100),
      builder: (context, double value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Health Data'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _healthList.isEmpty
          ? const Center(
              child: Text(
                'No health records found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _healthList.length,
              itemBuilder: (context, index) {
                final h = _healthList[index];

                // Colors for card gradient
                final gradientColors = [
                  const Color.fromARGB(255, 188, 226, 255),
                  const Color.fromARGB(255, 236, 245, 252),
                ];

                return _animatedCard(
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Blood Sugar: ${h['blood_sugar_level']} mg/dL',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B4F6C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Blood Pressure: ${h['blood_pressure_systolic']}/${h['blood_pressure_diastolic']} mmHg',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0B4F6C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Medication Taken: ${h['medication_taken'] ? 'Yes' : 'No'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0B4F6C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Symptoms: ${h['symptoms'] ?? '-'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0B4F6C),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                DateTime.parse(
                                  h['date_time'],
                                ).toLocal().toString().split(' ')[0],
                                style: const TextStyle(
                                  color: Color(0xFF0B4F6C),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  index,
                );
              },
            ),
    );
  }
}
