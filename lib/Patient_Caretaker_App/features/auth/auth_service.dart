import 'package:supabase_flutter/supabase_flutter.dart';

class UserAuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> login({
    required String email,
    required String password,
    required String role, // patient | caretaker
  }) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Login failed');
    }

    // 1️⃣ Verify role from user_profiles
    final profile = await _client
        .from('user_profiles')
        .select('role')
        .eq('user_id', user.id)
        .maybeSingle();

    if (profile == null || profile['role'] != role) {
      await _client.auth.signOut();
      throw Exception('Role mismatch');
    }

    // 2️⃣ Verify role-specific profile exists
    final table = role == 'patient'
        ? 'patient_profiles'
        : 'caretaker_profiles';

    final idColumn =
        role == 'patient' ? 'patient_id' : 'caretaker_id';

    final exists = await _client
        .from(table)
        .select(idColumn)
        .eq(idColumn, user.id)
        .maybeSingle();

    if (exists == null) {
      await _client.auth.signOut();
      throw Exception('Not registered as $role');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
