import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/session_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../../data/repositories/session_repository.dart';

part 'session_provider.g.dart';

/// Una sesión individual por id (con host embebido).
@riverpod
Future<SessionModel> sessionById(Ref ref, String id) {
  return ref.watch(sessionRepositoryProvider).getSessionById(id);
}

/// Participantes de una sesión (con estado).
@riverpod
Future<List<SessionParticipant>> sessionParticipants(Ref ref, String id) {
  return ref.watch(sessionRepositoryProvider).getSessionParticipants(id);
}

/// Estado de mi participación en la sesión (null si no me uní).
@riverpod
Future<String?> myParticipationStatus(Ref ref, String sessionId) {
  return ref
      .watch(sessionRepositoryProvider)
      .myParticipationStatus(sessionId);
}

/// chat_id de la sesión (lo crea si no existe).
@riverpod
Future<String> chatIdForSession(Ref ref, String sessionId) {
  return ref
      .watch(sessionRepositoryProvider)
      .getOrCreateChatForSession(sessionId);
}

/// Controla publicar / unirse / aceptar / rechazar / completar sesiones.
/// Estado `AsyncValue` para la UI.
@riverpod
class SessionController extends _$SessionController {
  @override
  FutureOr<void> build() {}

  /// Publica una sesión. Devuelve la sesión creada o null si hubo error.
  Future<SessionModel?> create({
    required String sport,
    required String level,
    required DateTime scheduledAt,
    required int durationMin,
    required int maxSpots,
    required String zoneName,
    required double lat,
    required double lng,
    String? notes,
    required bool womenOnly,
  }) async {
    state = const AsyncLoading();
    try {
      final session = await ref.read(sessionRepositoryProvider).createSession(
            sport: sport,
            level: level,
            scheduledAt: scheduledAt,
            durationMin: durationMin,
            maxSpots: maxSpots,
            zoneName: zoneName,
            lat: lat,
            lng: lng,
            notes: notes,
            womenOnly: womenOnly,
          );
      state = const AsyncData(null);
      return session;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<bool> join(String sessionId) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(sessionRepositoryProvider).joinSession(sessionId),
    );
    state = res;
    if (!res.hasError) {
      ref.invalidate(myParticipationStatusProvider(sessionId));
      ref.invalidate(sessionParticipantsProvider(sessionId));
    }
    return !res.hasError;
  }

  Future<bool> accept({
    required String sessionId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref
          .read(sessionRepositoryProvider)
          .acceptParticipant(sessionId, userId),
    );
    state = res;
    if (!res.hasError) {
      ref.invalidate(sessionParticipantsProvider(sessionId));
      ref.invalidate(sessionByIdProvider(sessionId));
    }
    return !res.hasError;
  }

  Future<bool> reject({
    required String sessionId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref
          .read(sessionRepositoryProvider)
          .rejectParticipant(sessionId, userId),
    );
    state = res;
    if (!res.hasError) {
      ref.invalidate(sessionParticipantsProvider(sessionId));
    }
    return !res.hasError;
  }

  Future<bool> complete(String sessionId) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(sessionRepositoryProvider).completeSession(sessionId),
    );
    state = res;
    if (!res.hasError) {
      ref.invalidate(sessionByIdProvider(sessionId));
    }
    return !res.hasError;
  }

  /// Edita una sesión existente (solo el host).
  Future<bool> edit({
    required String sessionId,
    required String sport,
    required String level,
    required DateTime scheduledAt,
    required String zoneName,
    required double lat,
    required double lng,
    String? notes,
    required bool womenOnly,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(sessionRepositoryProvider).updateSession(
            sessionId: sessionId,
            sport: sport,
            level: level,
            scheduledAt: scheduledAt,
            zoneName: zoneName,
            lat: lat,
            lng: lng,
            notes: notes,
            womenOnly: womenOnly,
          ),
    );
    state = res;
    if (!res.hasError) {
      ref.invalidate(sessionByIdProvider(sessionId));
    }
    return !res.hasError;
  }

  /// Elimina (soft-delete → cancelada) una sesión del host.
  Future<bool> remove(String sessionId) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(
      () => ref.read(sessionRepositoryProvider).cancelSession(sessionId),
    );
    state = res;
    return !res.hasError;
  }
}
