import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

/// 🔐 Session Gate for Doctor App
class DoctorSessionGate extends StatelessWidget {
  const DoctorSessionGate({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;

    // ❌ No session → Doctor Login
    if (session == null) {
      return const LoginScreen();
    }

    // ✅ Session exists → Doctor Home
    return DoctorHome();
  }
}
