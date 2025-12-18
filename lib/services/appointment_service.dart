import 'package:carelink/services/supabase_service.dart';

class AppointmentService {
  final _db = SupabaseService().supabase;

  String get _doctorId {
    final user = SupabaseService().currentUser;
    if (user == null) {
      throw Exception('Doctor not logged in');
    }
    return user.id;
  }

  // ===============================
  // Doctor – Pending / Requested
  // ===============================
  Future<List<Map<String, dynamic>>> getPendingAppointments() async {
    final res = await _db
        .from('appointments')
        .select('''
      appointment_id,
      date_time,
      purpose,
      status,
      patient_profiles(
        user_profiles(full_name)
      ),
      caretaker_profiles(
        user_profiles(full_name)
      )
    ''')
        .eq('doctor_id', _doctorId)
        .eq('status', 'pending')
        .order('date_time');

    return List<Map<String, dynamic>>.from(res);
  }

  // ===============================
  // Doctor – All appointments (History)
  // ===============================
  Future<List<Map<String, dynamic>>> getDoctorAppointments() async {
    final res = await _db
        .from('appointments')
        .select('''
          appointment_id,
          date_time,
          purpose,
          status,
          patient_profiles(
            user_profiles(full_name)
          ),
          caretaker_profiles(
            user_profiles(full_name)
          )
        ''')
        .eq('doctor_id', _doctorId)
        .order('date_time', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  // ===============================
  // Doctor – Patient specific
  // ===============================
  Future<List<Map<String, dynamic>>> getAppointmentsForPatient(
    String patientId,
  ) async {
    final res = await _db
        .from('appointments')
        .select('''
          appointment_id,
          date_time,
          purpose,
          status,
          caretaker_profiles(
            user_profiles(full_name)
          )
        ''')
        .eq('doctor_id', _doctorId)
        .eq('patient_id', patientId)
        .order('date_time', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  // ===============================
  // Doctor – Approve
  // ===============================
  Future<void> approveAppointment({
    required String appointmentId,
    required DateTime finalDateTime,
  }) async {
    await _db
        .from('appointments')
        .update({
          'date_time': finalDateTime.toIso8601String(),
          'status': 'confirmed',
        })
        .eq('appointment_id', appointmentId);
  }

  // ===============================
  // Doctor – Reject
  // ===============================
  Future<void> rejectAppointment(String appointmentId) async {
    await _db
        .from('appointments')
        .update({'status': 'cancelled'})
        .eq('appointment_id', appointmentId);
  }
}
