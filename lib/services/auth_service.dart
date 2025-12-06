import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final supabase = SupabaseService.client;

  Future<AuthResponse> register(
    String email,
    String password,
    String role,
    String name,
  ) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'role': role, 'name': name},
    );
    return response;
  }

  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
