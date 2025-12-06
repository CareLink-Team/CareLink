// lib/core/utils/session_manager.dart
import 'package:flutter/widgets.dart';
import '../../Doctor_App/views/doctor_home.dart';
import '../../Patient_Caretaker_App/views/patient_home.dart';
import '../../Patient_Caretaker_App/views/caretaker_home.dart';
import '../widgets/loading_screen.dart';

class SessionManager {
  /// Return the widget for the user's role.
  /// You can call this after login when you have the user's role string.
  static Widget redirectUser(String role) {
    switch (role) {
      case 'patient':
        return PatientHome();
      case 'caretaker':
        return CaretakerHome();
      case 'doctor':
        return DoctorHome();
      default:
        return const LoadingScreen();
    }
  }
}
