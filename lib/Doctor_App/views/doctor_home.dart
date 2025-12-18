import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/theme.dart';
import '../widgets/dashboard_card.dart';
import '../features/patient_list/patient_list.dart';
import '../features/appointments/doc_appointments.dart';
import '../views/auth/login_screen.dart';

class DoctorHome extends StatefulWidget {
  final String doctorId; // doctor_profiles.doctor_id

  const DoctorHome({super.key, required this.doctorId});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final _supabase = Supabase.instance.client;

  late final String doctorId;

  String doctorName = "Doctor";
  int totalPatients = 0;
  int todayAppointments = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    doctorId = widget.doctorId;
    _loadDoctorAndStats();
  }

  // ---------------- LOAD DOCTOR + STATS ----------------

  Future<void> _loadDoctorAndStats() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      final profile = await _supabase
          .from('user_profiles')
          .select('full_name')
          .eq('user_id', user.id)
          .maybeSingle();

      doctorName = profile?['full_name'] ?? "Doctor";

      await _loadPatientCount();
      await _loadTodayAppointments();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // ---------------- PATIENT COUNT ----------------

  Future<void> _loadPatientCount() async {
    final res = await _supabase
        .from('patient_profiles')
        .select('patient_id')
        .eq('doctor_id', doctorId);

    totalPatients = res.length;
  }

  // ---------------- TODAY APPOINTMENTS ----------------

  Future<void> _loadTodayAppointments() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final res = await _supabase
        .from('appointments')
        .select('appointment_id')
        .eq('doctor_id', doctorId)
        .gte('date_time', start.toIso8601String())
        .lt('date_time', end.toIso8601String());

    todayAppointments = res.length;
  }

  // ---------------- LOGOUT ----------------

  Future<void> _logout(BuildContext context) async {
    await _supabase.auth.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 900
        ? 4
        : width >= 600
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          'Doctor Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryBlue, Color(0xFF5DB3FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.medical_services_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome back 👋",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctorName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= QUICK ACTIONS =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.85, // 🔥 FIX
                      ),
                      children: [
                        DashboardCard(
                          icon: Icons.people_alt_rounded,
                          title: "Patients",
                          subtitle: '',
                          description: "View and manage your assigned patients",
                          stat: totalPatients.toString(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PatientListScreen(doctorId: doctorId),
                              ),
                            );
                          },
                        ),
                        DashboardCard(
                          icon: Icons.calendar_month_rounded,
                          title: "Appointments",
                          subtitle: '',
                          description: "Manage today’s appointments",
                          stat: todayAppointments.toString(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DoctorAppointmentsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ================= OVERVIEW =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Your activity summary for today",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
