import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
// import '../core/utils/session_manager.dart';
import 'views/auth/role_selection_screen.dart'; // adjust import paths

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
      home: const RoleSelectionScreen(), // your login screen
    );
  }
}
