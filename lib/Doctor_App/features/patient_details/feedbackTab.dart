// TODO Implement this library.
import 'package:carelink/services/profile_service.dart';
import 'package:flutter/material.dart';
import '../../../models/doctorfeedback.dart';

class FeedbackTab extends StatelessWidget {
  final String patientId;
  const FeedbackTab({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoctorFeedback>>(
      future: ProfileService().getFeedbackForPatient(patientId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final feedbacks = snapshot.data!;
        if (feedbacks.isEmpty) {
          return const Center(child: Text('No feedback yet'));
        }

        return ListView.builder(
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            final fb = feedbacks[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(fb.advicePrescription),
                subtitle: Text(
                  'Next Checkup: ${fb.nextCheckupDate}',
                ),
                trailing: Text(fb.status),
              ),
            );
          },
        );
      },
    );
  }
}