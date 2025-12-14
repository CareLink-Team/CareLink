import 'package:flutter/material.dart';
import '../patient/patient_home.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy patients list
    final List<String> patients = [
      'Sarah Ahmed',
      'Ali Raza',
      'Ayesha Khan',
      'Usman Malik',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: patients.length,
        itemBuilder: (context, index) {
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
                patients[index],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Tap to view health details'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientHome(),
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
