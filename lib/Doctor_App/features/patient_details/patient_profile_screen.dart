import 'package:flutter/material.dart';
import '../../../models/patient.dart';
import '../patient_details/overviewTab.dart';
import '../patient_details/vitalsTab.dart';

import '../patient_details/feedbackTab.dart';

class PatientProfileScreen extends StatelessWidget {
  final Patient patient;

  const PatientProfileScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient Profile'),
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
            OverviewTab(patient: patient),
            VitalsTab(patientId: patient.patientId),
            FeedbackTab(patientId: patient.patientId),
          ],
        ),
      ),
    );
  }
}
