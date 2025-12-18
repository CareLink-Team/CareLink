import 'package:flutter/material.dart';
import 'package:carelink/services/caretaker_prescription_service.dart';

class CaretakerPrescriptions extends StatefulWidget {
  final String caretakerId;
  const CaretakerPrescriptions({super.key, required this.caretakerId});

  @override
  State<CaretakerPrescriptions> createState() => _CaretakerPrescriptionsState();
}

class _CaretakerPrescriptionsState extends State<CaretakerPrescriptions> {
  bool _loading = true;
  List<Map<String, dynamic>> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    final data = await getPrescriptionsForMyPatients();

    setState(() {
      _prescriptions = data;
      _loading = false;
    });
  }

  // Animated card wrapper
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
        title: const Text('Prescriptions'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _prescriptions.isEmpty
          ? const Center(
              child: Text(
                'No prescriptions found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _prescriptions.length,
              itemBuilder: (context, index) {
                final p = _prescriptions[index];

                // Safe null checks for nested map
                String patientName = 'Patient';
                try {
                  final patientProfile =
                      p['patient_profiles'] as Map<String, dynamic>?;
                  final userProfile =
                      patientProfile?['user_profiles'] as Map<String, dynamic>?;
                  patientName = userProfile?['full_name'] ?? 'Patient';
                } catch (_) {}

                final items = List<Map<String, dynamic>>.from(
                  p['prescription_items'] ?? [],
                );

                // Blue gradient for cards
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
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                          textTheme: const TextTheme(
                            titleMedium: TextStyle(
                              color: Colors.white,
                            ), // replacement for subtitle1
                          ),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B4F6C),
                            ),
                          ),
                          subtitle: Text(
                            DateTime.parse(
                              p['created_at'],
                            ).toLocal().toString().split(' ')[0],
                            style: const TextStyle(color: Color(0xFF0B4F6C)),
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          children: items
                              .map(
                                (i) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        i['medicine_name'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0B4F6C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${i['dosage'] ?? ''} | ${i['frequency'] ?? ''} | ${i['duration'] ?? ''}',
                                        style: const TextStyle(
                                          color: Color(0xFF0B4F6C),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
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
