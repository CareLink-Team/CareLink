import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  SupabaseService._internal();

  late final SupabaseClient client;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: 'https://coxlqecyrfvmiqeomyqq.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNveGxxZWN5cmZ2bWlxZW9teXFxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMDU2NTksImV4cCI6MjA4MDU4MTY1OX0.IRt22sRgFdJZiq2ZVaZJoSUSn8bY4tvcU2TnNfGDdW4',
      debug: true,
    );

    client = Supabase.instance.client;
    _initialized = true;
  }

  SupabaseClient get supabase => client;

  // AUTH HELPERS
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;
}
