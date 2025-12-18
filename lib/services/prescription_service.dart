import 'package:carelink/services/supabase_service.dart';

class PrescriptionService {
  final _supabase = SupabaseService().supabase;

  /// Fetch prescriptions for a patient (doctor-scoped)
  Future<List<Map<String, dynamic>>> getPrescriptionsForPatient(
    String patientId,
  ) async {
    final doctor = SupabaseService().currentUser;
    if (doctor == null) {
      throw Exception('Doctor not logged in');
    }

    final response = await _supabase
        .from('prescriptions')
        .select('''
          prescription_id,
          notes,
          created_at,
          prescription_items (
            medicine_name,
            dosage,
            frequency,
            duration
          )
        ''')
        .eq('doctor_id', doctor.id)
        .eq('patient_id', patientId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Create prescription with medicines
  Future<void> createPrescription({
    required String patientId,
    String? appointmentId,
    required String notes,
    required List<Map<String, String>> medicines,
  }) async {
    final doctor = SupabaseService().currentUser;
    if (doctor == null) {
      throw Exception('Doctor not logged in');
    }

    // 1️⃣ Insert prescription
    final prescription = await _supabase
        .from('prescriptions')
        .insert({
          'doctor_id': doctor.id,
          'patient_id': patientId,
          'appointment_id': appointmentId,
          'notes': notes,
        })
        .select()
        .single();

    // 2️⃣ Insert medicines
    final items = medicines.map((med) {
      return {
        'prescription_id': prescription['prescription_id'],
        'medicine_name': med['medicine_name'],
        'dosage': med['dosage'],
        'frequency': med['frequency'],
        'duration': med['duration'],
      };
    }).toList();

    await _supabase.from('prescription_items').insert(items);
  }
}
