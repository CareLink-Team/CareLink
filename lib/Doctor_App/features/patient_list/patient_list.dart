import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/patient_service.dart';
import '../patient_details/patient_profile_screen.dart';
import 'package:carelink/core/theme/theme.dart';

class PatientListScreen extends StatefulWidget {
  final String doctorId;

  const PatientListScreen({super.key, required this.doctorId});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late final String doctorId;
  late final PatientService service;

  @override
  void initState() {
    super.initState();
    doctorId = Supabase.instance.client.auth.currentUser?.id ?? widget.doctorId;
    service = PatientService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,

      // 🔹 SIMPLE APP BAR (NO TITLE)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          // 🔹 HEADER (CONSISTENT WITH DASHBOARD)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "My Patients",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "View and manage assigned patients",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 PATIENT LIST
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: service.getPatientsForDoctor(doctorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final patients = snapshot.data ?? [];

                if (patients.isEmpty) {
                  return const Center(
                    child: Text(
                      'No patients assigned',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final data = patients[index];

                    return AnimatedPatientCard(
                      index: index,
                      patientId: data['patient_id'],
                      fullName:
                          data['user_profiles']?['full_name'] ?? 'No name',
                      age: (data['age'] ?? 'N/A').toString(),
                      gender: data['gender'] ?? 'Unknown',
                      condition: data['medical_condition'] ?? 'Not specified',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== ANIMATED PATIENT CARD =====================

class AnimatedPatientCard extends StatefulWidget {
  final int index;
  final String patientId;
  final String fullName;
  final String age;
  final String gender;
  final String condition;

  const AnimatedPatientCard({
    super.key,
    required this.index,
    required this.patientId,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.condition,
  });

  @override
  State<AnimatedPatientCard> createState() => _AnimatedPatientCardState();
}

class _AnimatedPatientCardState extends State<AnimatedPatientCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PatientProfileScreen(patientId: widget.patientId),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppTheme.primaryBlue,
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.lightBlue,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.age} yrs • ${widget.gender}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_hospital,
                            size: 14,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.condition,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
