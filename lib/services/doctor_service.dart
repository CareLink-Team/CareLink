import 'package:carelink/services/supabase_service.dart';

class DoctorService {
  final _db = SupabaseService().supabase;

  Future<List<Map<String, dynamic>>> getDoctorFeedback(String doctorId) async {
    final response = await _db
        .from('doctor_feedback')
        .select()
        .eq('doctor_id', doctorId);

    return response;
  }
}
