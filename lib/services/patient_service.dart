import 'package:carelink/services/supabase_service.dart';
import '../models/patient.dart';

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
  Future<Patient?> getPatientById(String patientId) async {
    try {
      final response = await _db
          .from('patients')
          .select()
          .eq('patient_id', patientId)
          .maybeSingle();

      if (response == null) return null;

      return Patient.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load patient: $e');
    }
  }
}
