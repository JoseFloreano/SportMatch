import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper sobre Supabase Auth para login por OTP de SMS (México).
class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isAuthenticated => _client.auth.currentSession != null;

  /// Emite eventos al iniciar/cerrar sesión. El router lo escucha para redirigir.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Envía un OTP por SMS al teléfono en formato internacional (+52...).
  Future<void> sendOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  /// Verifica el código recibido por SMS. Devuelve la sesión creada.
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    return _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<void> signOut() async => _client.auth.signOut();
}
