import 'package:flutter/material.dart';
import '../../../services/appointment_service.dart';

class AppointmentTab extends StatelessWidget {
  final String patientId;

  AppointmentTab({super.key, required this.patientId});

  final AppointmentService service = AppointmentService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: service.getAppointmentsForPatient(patientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return const Center(child: Text('No appointments found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final data = appointments[index];

            final caretakerName =
                data['caretaker_profiles']?['user_profiles']?['full_name'] ??
                'No caretaker';

            final dateTime = DateTime.parse(data['date_time']);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(
                  data['purpose'] ?? 'Appointment',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Caretaker: $caretakerName'),
                    Text('Status: ${data['status']}'),
                  ],
                ),
                trailing: Text(
                  "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
