import 'package:carelink/services/supabase_service.dart';

class AppointmentService {
  final _supabase = SupabaseService().supabase;

  /// 🔹 All appointments for logged-in doctor
  Future<List<Map<String, dynamic>>> getDoctorAppointments() async {
    final doctor = SupabaseService().currentUser;
    if (doctor == null) {
      throw Exception('Doctor not logged in');
    }

    final response = await _supabase
        .from('appointments')
        .select('''
          appointment_id,
          date_time,
          purpose,
          status,
          patient_profiles (
            user_profiles (
              full_name
            )
          ),
          caretaker_profiles (
            user_profiles (
              full_name
            )
          )
        ''')
        .eq('doctor_id', doctor.id)
        .order('date_time', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAppointmentsForPatient(
    String patientId,
  ) async {
    final doctor = SupabaseService().currentUser;
    if (doctor == null) {
      throw Exception('Doctor not logged in');
    }

    final response = await _supabase
        .from('appointments')
        .select('''
        appointment_id,
        date_time,
        purpose,
        status,
        caretaker_profiles (
          user_profiles (
            full_name
          )
        )
      ''')
        .eq('doctor_id', doctor.id)
        .eq('patient_id', patientId)
        .order('date_time', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
