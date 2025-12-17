import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../services/appointment_service.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppointmentService service = AppointmentService();

    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          'My Appointments',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: service.getDoctorAppointments(),
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
            return const Center(
              child: Text(
                'No appointments found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final data = appointments[index];

              final patientName =
                  data['patient_profiles']?['user_profiles']?['full_name'] ??
                  'Unknown Patient';

              final caretakerName =
                  data['caretaker_profiles']?['user_profiles']?['full_name'] ??
                  'No caretaker';

              final dateTime = DateTime.parse(data['date_time']);

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryBlue,
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    patientName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Caretaker: $caretakerName'),
                        Text('Purpose: ${data['purpose'] ?? 'N/A'}'),
                        Text(
                          'Status: ${data['status']}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
