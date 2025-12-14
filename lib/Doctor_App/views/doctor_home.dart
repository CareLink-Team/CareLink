import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../../core/theme/theme.dart';
import '../features/patient_list/patient_list.dart';
import '../../services/supabase_service.dart';

class DoctorHome extends StatelessWidget {
  DoctorHome({super.key});

  final doctorId = SupabaseService().currentUser?.id;

  @override
  Widget build(BuildContext context) {
    final List<Widget> dashboardItems = [
      DashboardCard(
        icon: Icons.people_alt_rounded,
        title: "Patients",
        onTap: () {
          if (doctorId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientListScreen(doctorId: doctorId!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No doctor is logged in")),
            );
          }
        },
      ),
      DashboardCard(
        icon: Icons.calendar_month_outlined,
        title: "Appointments",
        onTap: () {},
      ),
      DashboardCard(
        icon: Icons.health_and_safety_rounded,
        title: "Reports",
        onTap: () {},
      ),
      DashboardCard(
        icon: Icons.feedback_outlined,
        title: "Feedback",
        onTap: () {},
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.lightBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome 👨‍⚕️",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 6),
                Text(
                  "Dr. CareLink",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 GRID (Responsive)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;

                  if (constraints.maxWidth >= 900) {
                    crossAxisCount = 4; // laptop/large screen
                  } else if (constraints.maxWidth >= 600) {
                    crossAxisCount = 3; // tablet
                  } else {
                    crossAxisCount = 2; // phone
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: dashboardItems.length,
                    itemBuilder: (context, index) {
                      return dashboardItems[index];
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
