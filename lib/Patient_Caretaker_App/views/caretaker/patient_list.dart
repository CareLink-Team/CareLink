import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../patient/patient_home.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  List<Map<String, dynamic>> patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('caretaker_patients')
          .select('patient_id, user_profiles!caretaker_patients_patient_id_fkey(full_name)')
          .eq('caretaker_id', user.id);

      setState(() {
        patients = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : patients.isEmpty
              ? const Center(child: Text('No patients assigned'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    final patientName =
                        patient['user_profiles']['full_name'];

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF1976D2),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          patientName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle:
                            const Text('Tap to view health details'),
                        trailing:
                            const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientHome(
                                patientId: patient['patient_id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
