import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'caretaker_appointments.dart';
import 'caretaker_notes.dart';
import 'patient_list.dart';

class CaretakerHome extends StatefulWidget {
  const CaretakerHome({super.key, required String caretakerId});

  @override
  State<CaretakerHome> createState() => _CaretakerHomeState();
}

class _CaretakerHomeState extends State<CaretakerHome> {
  final supabase = Supabase.instance.client;

  String? caretakerName;
  String? caretakerId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCaretakerData();
  }

  Future<void> _loadCaretakerData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final profile = await supabase
          .from('user_profiles')
          .select('full_name')
          .eq('user_id', user.id)
          .single();

      setState(() {
        caretakerName = profile['full_name'];
        caretakerId = user.id;
        loading = false;
      });
    } catch (e) {
      setState(() {
        caretakerName = 'Caretaker';
        caretakerId = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caretaker Dashboard'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: Colors.blue[50],
                    child: ListTile(
                      leading: const Icon(
                        Icons.medical_services,
                        size: 36,
                        color: Color(0xFF1976D2),
                      ),
                      title: Text(
                        'Welcome, ${caretakerName ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Manage patients and daily activities',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _actionButton(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Appointments',
                        onTap: () {
                          if (caretakerId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CaretakerAppointments(
                                  caretakerId: caretakerId!,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      _actionButton(
                        context,
                        icon: Icons.note_alt,
                        label: 'Notes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaretakerAppointments(
                                caretakerId: caretakerId!,
                              ),
                            ),
                          );
                        },
                      ),
                      _actionButton(
                        context,
                        icon: Icons.people,
                        label: 'Patients',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientListScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Column(
            children: [
              Icon(icon, size: 22),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
