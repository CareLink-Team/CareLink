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

    int crossAxisCount = isDesktop
        ? 4
        : isTablet
        ? 3
        : 2;

    final double titleFont = isMobile
        ? 22
        : isTablet
        ? 24
        : 26;
    final double subtitleFont = isMobile ? 16 : 18;

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

      /// APPOINTMENTS
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
      backgroundColor: AppTheme.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
        centerTitle: true,
        title: const Text(
          "Doctor Dashboard",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // 🔹 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: isMobile ? 22 : 28,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.lightBlue],
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
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(color: Colors.white, fontSize: subtitleFont),
                ),
                const SizedBox(height: 6),
                Text(
                  doctorName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 GRID
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isMobile ? 1 : 1.1,
                ),
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  return dashboardItems[index];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
