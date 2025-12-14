import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
// import 'core/utils/session_manager.dart';
import 'Patient_Caretaker_App/views/auth/login_screen.dart'; // adjust import paths

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService().init(); // initialize once

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink',
      home: const LoginScreen(), // your login screen
    );
  }
}
