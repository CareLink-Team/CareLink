import 'package:carelink/services/supabase_service.dart';

class PatientService {
  final _db = SupabaseService().supabase;

  //fetch patients for patient_list
  Future<List<Map<String, dynamic>>> getPatientsForDoctor(
    String doctorID,
  ) async {
    try {
      final response = await _db
          .from('patient_profiles')
          .select('''
          *,
          user_profiles (
            full_name
          )
        ''')
          .eq('doctor_id', doctorID);

      return response;
    } catch (e) {
      throw Exception('Error fetching patients: $e');
    }
  }

  //fetch patient by id (for profile)
  Future<Map<String, dynamic>?> getPatientById(String patientId) async {
    final response = await _db
        .from('patient_profiles')
        .select('''
        *,
        user_profiles(
          full_name,
          email
        )
      ''')
        .eq('patient_id', patientId)
        .maybeSingle();

    return response;
  }

  //fetch caretaker by patient id (for profile)

  Future<Map<String, dynamic>?> getCaretakerByPatientId(
    String patientId,
  ) async {
    final response = await _db
        .from('caretaker_profiles')
        .select('''
        *,
        user_profiles(
          full_name,
          email
        )
      ''')
        .eq('patient_id', patientId)
        .maybeSingle();

    return response;
  }
}
