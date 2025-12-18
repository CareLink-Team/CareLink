import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'health_form.dart';
import 'health_list.dart';

class PatientHome extends StatefulWidget {
  final String patientId;

  const PatientHome({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final supabase = Supabase.instance.client;

  String patientName = '';
  String bloodPressure = '-- / --';
  String appointmentText = 'No upcoming appointments';

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
  try {
    // 1️⃣ Get patient full name from user_profiles
    final patient = await supabase
        .from('user_profiles')
        .select('full_name')
        .eq('user_id', widget.patientId)
        .single();

    // 2️⃣ Latest health record
    final health = await supabase
        .from('health_data')
        .select('blood_pressure_systolic, blood_pressure_diastolic')
        .eq('patient_id', widget.patientId)
        .order('date_time', ascending: false)
        .limit(1)
        .maybeSingle();

    // 3️⃣ Upcoming appointment
    final appointment = await supabase
        .from('appointments')
        .select('date_time')
        .eq('patient_id', widget.patientId)
        .gte('date_time', DateTime.now().toIso8601String())
        .order('date_time')
        .limit(1)
        .maybeSingle();

    setState(() {
      patientName = patient['full_name']; // use full_name column

      if (health != null) {
        bloodPressure =
            '${health['blood_pressure_systolic']} / ${health['blood_pressure_diastolic']}';
      }

      if (appointment != null) {
        final date = DateTime.parse(appointment['date_time']).toLocal();
        appointmentText = 'Next appointment on ${date.toString().split(' ')[0]}';
      }

      loading = false;
    });
  } catch (e) {
    debugPrint(e.toString());
    setState(() => loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi $patientName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Here’s a quick look at your health today',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Summary',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  _infoCard(
                    icon: Icons.favorite,
                    title: 'Blood Pressure',
                    value: bloodPressure,
                    status: bloodPressure == '-- / --'
                        ? 'No data'
                        : 'Recorded',
                    statusColor: Colors.green,
                  ),

                  const SizedBox(height: 18),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(Icons.event_note,
                              color: Color(0xFF1976D2)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              appointmentText,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  _actionTile(
                    context,
                    icon: Icons.add_circle_outline,
                    title: 'Add health data',
                    subtitle: 'Update your latest readings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HealthForm(patientId: widget.patientId),
                      ),
                    ),
                  ),

                  _actionTile(
                    context,
                    icon: Icons.folder_open,
                    title: 'Health records',
                    subtitle: 'View previous entries',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HealthList(patientId: widget.patientId),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1976D2)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 13,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1976D2)),
        title:
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.black45),
        onTap: onTap,
      ),
    );
  }
}
