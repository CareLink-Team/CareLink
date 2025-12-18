import 'package:carelink/services/supabase_service.dart';

Future<List<Map<String, dynamic>>> getPrescriptionsForMyPatients() async {
  final _db = SupabaseService().supabase;
  final response = await _db
      .from('prescriptions')
      .select('''
        prescription_id,
        notes,
        created_at,
        patient_profiles (
          user_profiles (
            full_name
          )
        ),
        prescription_items (
          medicine_name,
          dosage,
          frequency,
          duration
        )
      ''')
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(response);
}
