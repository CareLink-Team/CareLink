import 'package:supabase_flutter/supabase_flutter.dart';

class UserAuthService {
  final _client = Supabase.instance.client;

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
    if (user == null) throw Exception('Login failed');

    final table = role == 'patient' ? 'patient_profiles' : 'caretaker_profiles';

    final exists = await _client
        .from(table)
        .select()
        .eq('${role}_id', user.id)
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
