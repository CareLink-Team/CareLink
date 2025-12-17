import 'package:flutter/material.dart';

import '../services/supabase_service.dart';
import 'views/auth/login_screen.dart';
import 'views/doctor_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase ONCE
  await SupabaseService().init();

  runApp(const DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink Doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
      ),
      home: const DoctorSessionGate(),
    );
  }
}

class DoctorSessionGate extends StatelessWidget {
  const DoctorSessionGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService().currentUser;

    // ❌ Not logged in
    if (user == null) {
      return const LoginScreen();
    }

    // ✅ Logged in → pass doctorId
    return DoctorHome(doctorId: user.id);
  }
}
