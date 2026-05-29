import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/providers/supabase_provider.dart';

part 'auth_provider.g.dart';

/// Stream de cambios de sesión. El router lo escucha para redirigir entre
/// las rutas autenticadas y el flujo de login.
@riverpod
Stream<AuthState> authStateStream(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

/// Controla el flujo de login por OTP. Expone estado loading/error a la UI.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  /// Envía el código por SMS. Devuelve true si se envió sin error.
  Future<bool> sendOtp(String phone) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendOtp(phone),
    );
    state = res;
    return !res.hasError;
  }

  /// Verifica el código. Devuelve true si la sesión se creó correctamente.
  Future<bool> verifyOtp({required String phone, required String token}) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .verifyOtp(phone: phone, token: token),
    );
    state = res.whenData((_) {});
    return !res.hasError;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
