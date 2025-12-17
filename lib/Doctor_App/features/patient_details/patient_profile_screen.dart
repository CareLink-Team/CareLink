import 'package:carelink/Doctor_App/features/patient_details/vitalsTab.dart';
import 'package:flutter/material.dart';
import 'package:carelink/core/theme/theme.dart';
import 'appointment.dart';
import 'overview.dart';
import 'prescription.dart';

class PatientProfileScreen extends StatelessWidget {
  final String patientId;

  const PatientProfileScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.lightBlue,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.primaryBlue,
          title: const Text(
            'Patient Profile',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Vitals'),
              Tab(text: 'Appointments'),
              Tab(text: 'Prescription'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OverviewTab(patientId: patientId), //pass patient's ID
            VitalsTab(patientId: patientId),
            AppointmentTab(patientId: patientId),
            PrescriptionTab(patientId: patientId),
          ],
        ),
      ),
    );
  }
}
