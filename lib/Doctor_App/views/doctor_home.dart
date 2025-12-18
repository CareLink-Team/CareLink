import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/dashboard_card.dart';
import '../../core/theme/theme.dart';
import '../features/patient_list/patient_list.dart';
import '../views/auth/login_screen.dart';
import '../features/appointments/doc_appointments.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key, required String doctorId});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  String? doctorId;
  String doctorName = "Doctor";

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  Future<void> _loadDoctor() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    doctorId = user.id;

    final response = await Supabase.instance.client
        .from('user_profiles')
        .select('full_name')
        .eq('user_id', doctorId!)
        .maybeSingle();

    if (response != null) {
      setState(() {
        doctorName = response['full_name'] ?? "Doctor";
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isMobile = size.width < 600;
    final bool isTablet = size.width >= 600 && size.width < 900;
    final bool isDesktop = size.width >= 900;

    final int crossAxisCount = isDesktop
        ? 4
        : isTablet
        ? 3
        : 2;

    /// 🔹 DASHBOARD ITEMS (LOGIC UNCHANGED)
    final List<Widget> dashboardItems = [
      DashboardCard(
        icon: Icons.people_alt_rounded,
        title: "Patients",
        onTap: () {
          if (doctorId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientListScreen(doctorId: doctorId!),
              ),
            );
          }
        },
      ),

      DashboardCard(
        icon: Icons.calendar_month_outlined,
        title: "Appointments",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoctorAppointmentsScreen()),
          );
        },
      ),

      DashboardCard(
        icon: Icons.logout_rounded,
        title: "Logout",
        onTap: () => _logout(context),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, Color(0xFF4FACFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Doctor Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: Column(
        children: [
          /// 🔹 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 26,
              vertical: isMobile ? 26 : 32,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, Color(0xFF4FACFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                /// Avatar
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),

                /// Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back 👋",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          /// 🔹 DASHBOARD GRID
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 20),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.05,
                ),
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  return _DashboardWrapper(child: dashboardItems[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 UI WRAPPER (NO LOGIC)
class _DashboardWrapper extends StatelessWidget {
  final Widget child;

  const _DashboardWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8FAFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
