import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorAuthService {
  final _client = Supabase.instance.client;

  /// Logs in user and ensures they are a doctor
  Future<void> loginDoctor({
    required String email,
    required String password,
  }) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Login failed');
    }

    final userId = user.id;

    // ✅ Check ONLY doctor_profiles
    final doctor = await _client
        .from('doctor_profiles')
        .select('doctor_id')
        .eq('doctor_id', userId)
        .maybeSingle();

    if (doctor == null) {
      await _client.auth.signOut();
      throw Exception('Access denied: not a doctor');
    }

    // ✔ Doctor authenticated successfully
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
