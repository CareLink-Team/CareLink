import 'package:flutter/material.dart';
import '../../../models/patient.dart';
import '../../../models/userProfile.dart';
import '../../../services/patient_service.dart';
import '../patient_details/patient_profile_screen.dart';

class PatientListScreen extends StatefulWidget {
  final String doctorId;

  const PatientListScreen({super.key, required this.doctorId});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<Map<String, dynamic>>> _patientsFuture;

  @override
  void initState() {
    super.initState();
    _patientsFuture = PatientService().getPatientsForDoctor(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Patients'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final dataList = snapshot.data!;

          if (dataList.isEmpty) {
            return const Center(child: Text('No patients assigned'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];

              final patient = Patient.fromJson(data);
              final userProfile = UserProfile.fromJson(data['user_profiles']);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(userProfile.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: ${patient.age} | Gender: ${patient.gender}'),
                      Text('Condition: ${patient.medicalCondition}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientProfileScreen(
                          patient: patient,
                          userProfile: userProfile,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
