import 'package:carelink/services/supabase_service.dart';
import '../models/caretaker.dart';
import '../models/healthdata.dart';
import '../models/doctorfeedback.dart';

class ProfileService {
  final _db = SupabaseService().supabase;

  /// Fetch caretaker assigned to a patient(for patient_profile)
  Future<Caretaker?> getCaretakerById(String patientId) async {
    try {
      final response = await _db
          .from('caretaker_profiles')
          .select()
          .eq('patient_id', patientId)
          .maybeSingle();

      if (response == null) return null;

      return Caretaker.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load caretaker: $e');
    }
  }

  //health data for profile
  Stream<List<HealthData>> vitalsStream(String patientId) {
    return _db
        .from('health_data')
        .stream(primaryKey: ['record_id'])
        .eq('patient_id', patientId)
        .order('date_time', ascending: false)
        .map((data) => data.map((e) => HealthData.fromJson(e)).toList());
  }

  /// Get all feedback given to a specific patient
  Future<List<DoctorFeedback>> getFeedbackForPatient(String patientId) async {
    try {
      final response = await _db
          .from('doctor_feedback')
          .select()
          .eq('patient_id', patientId)
          .order('date_time', ascending: false);

      return (response as List)
          .map((json) => DoctorFeedback.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch feedback: $e');
    }
  }
}
