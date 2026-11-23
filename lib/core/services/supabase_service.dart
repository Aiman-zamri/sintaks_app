import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static bool get isInitialized => client != null;

  /// Authenticate user via Supabase or fallback demo logic
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    if (isInitialized) {
      final response = await client!.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } else {
      // Demo delay for offline/testing mode
      await Future.delayed(const Duration(seconds: 1));
      if (email.contains('@') && password.length >= 6) {
        return true;
      }
      throw Exception('Invalid credentials. Password must be at least 6 characters.');
    }
  }

  /// Register user via Supabase or fallback demo logic
  static Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    if (isInitialized) {
      final response = await client!.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
      return response.user != null;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      if (email.contains('@') && password.length >= 6) {
        return true;
      }
      throw Exception('Registration failed. Please enter a valid email and password.');
    }
  }
}
