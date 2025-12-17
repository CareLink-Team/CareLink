// lib/core/utils/session_manager.dart
import 'package:flutter/widgets.dart';
import '../../services/supabase_service.dart';

import '../../Doctor_App/views/doctor_home.dart';
import '../../Patient_Caretaker_App/views/patient/patient_home.dart';
import '../../Patient_Caretaker_App/views/caretaker/caretaker_home.dart';
import '../widgets/loading_screen.dart';

class SessionManager {
  static Widget redirectUser(String role) {
    final user = SupabaseService().currentUser;

    if (user == null) {
      return const LoadingScreen();
    }

    final userId = user.id;

    switch (role) {
      case 'patient':
        return PatientHome(patientId: userId);

      case 'caretaker':
        return CaretakerHome(caretakerId: userId);

      case 'doctor':
        return DoctorHome(doctorId: userId);

      default:
        return const LoadingScreen();
    }
  }
}
