import 'package:carelink/services/supabase_service.dart';

class HealthDataService {
  final _db = SupabaseService().supabase;

  Future<List<Map<String, dynamic>>> getHealthDataForPatient(
      String patientId) async {
    final response = await _db
        .from('health_data')
        .select()
        .eq('patient_id', patientId)
        .order('date_time', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
