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
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 26, 25, 25)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "My Patients",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    ),
    body: Column(
      children: [
        // 🔹 HEADER SECTION (can keep it or remove AppBar title duplication)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "View and manage your assigned patients",
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

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

                  final patientId = data['patient_id'];
                  final fullName =
                      data['user_profiles']?['full_name'] ?? 'No name';
                  final age = data['age'] ?? 'N/A';
                  final gender = data['gender'] ?? 'Unknown';
                  final condition =
                      data['medical_condition'] ?? 'Not specified';

                  return AnimatedPatientCard(
                    index: index,
                    patientId: patientId,
                    fullName: fullName,
                    age: age.toString(),
                    gender: gender,
                    condition: condition,
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

// --------------------- ANIMATED PATIENT CARD ---------------------

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
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Staggered animation
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
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
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: widget.patientId.isNotEmpty
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PatientProfileScreen(
                        patientId: widget.patientId,
                      ),
                    ),
                  );
                }
              : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
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

                  // Patient Info
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
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}