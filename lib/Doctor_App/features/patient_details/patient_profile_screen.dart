import 'package:flutter/material.dart';
import '../../../models/patient.dart';
import '../../../models/userProfile.dart';

import 'overviewTab.dart';
import 'vitalsTab.dart';
import 'feedbackTab.dart';

class PatientProfileScreen extends StatelessWidget {
  final Patient patient;
  final UserProfile userProfile;

  const PatientProfileScreen({
    super.key,
    required this.patient,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(userProfile.fullName), // ✅ name from user_profiles
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Vitals'),
              Tab(text: 'Reports'),
              Tab(text: 'Feedback'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OverviewTab(patient: patient), // ✅ unchanged
            VitalsTab(patientId: patient.patientId),
            const Center(child: Text('Reports coming soon')),
            FeedbackTab(patientId: patient.patientId),
          ],
        ),
      ),
    );
  }
}
