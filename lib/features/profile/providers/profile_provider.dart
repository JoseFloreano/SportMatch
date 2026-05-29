import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/profile_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../auth/providers/auth_provider.dart';

part 'profile_provider.g.dart';

/// Perfil del usuario autenticado. Se refresca cuando cambia la sesión.
@riverpod
Future<ProfileModel?> currentProfile(Ref ref) {
  // Re-ejecuta al iniciar/cerrar sesión.
  ref.watch(authStateStreamProvider);
  return ref.watch(profileRepositoryProvider).getCurrentProfile();
}

/// Perfil de cualquier usuario por id.
@riverpod
Future<ProfileModel?> profileById(Ref ref, String userId) {
  return ref.watch(profileRepositoryProvider).getProfile(userId);
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {}

  /// Guarda el perfil e invalida el provider de perfil actual.
  Future<bool> save(ProfileModel profile) async {
    state = const AsyncLoading();
    try {
      await ref.read(profileRepositoryProvider).updateProfile(profile);
      ref.invalidate(currentProfileProvider);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
