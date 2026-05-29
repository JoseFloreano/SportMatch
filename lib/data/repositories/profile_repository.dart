import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient _client;
  ProfileRepository(this._client);

  /// Perfil por id. Devuelve null si no existe.
  Future<ProfileModel?> getProfile(String userId) async {
    final row =
        await _client.from('profiles').select().eq('id', userId).maybeSingle();
    if (row == null) return null;
    return ProfileModel.fromMap(row);
  }

  /// Perfil del usuario autenticado actual.
  Future<ProfileModel?> getCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return getProfile(user.id);
  }

  /// Actualiza campos editables del perfil y devuelve la versión persistida.
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final payload = {
      ...profile.toMap(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
    final row = await _client
        .from('profiles')
        .update(payload)
        .eq('id', profile.id)
        .select()
        .single();
    return ProfileModel.fromMap(row);
  }

  /// Sube el avatar al bucket `avatars` y devuelve su URL pública.
  /// Requiere crear el bucket público `avatars` en Supabase Storage.
  Future<String> uploadAvatar(File file) async {
    final userId = _client.auth.currentUser!.id;
    final ext = file.path.contains('.') ? file.path.split('.').last : 'jpg';
    final path = '$userId/avatar.$ext';
    await _client.storage.from('avatars').upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return _client.storage.from('avatars').getPublicUrl(path);
  }

  /// Varios perfiles por id (para listas de participantes, etc.).
  Future<List<ProfileModel>> getProfilesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows = await _client.from('profiles').select().inFilter('id', ids);
    return rows.map(ProfileModel.fromMap).toList();
  }

  /// Guarda la última ubicación conocida del usuario en su perfil. Usado por
  /// match-users para filtrar por proximidad. Llama a la RPC set_my_location.
  Future<void> setMyLocation(double lat, double lng) async {
    await _client.rpc(
      'set_my_location',
      params: {'p_lat': lat, 'p_lng': lng},
    );
  }
}
