import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/date_formatter.dart';
import '../models/profile_model.dart';
import '../models/session_model.dart';

class SessionRepository {
  final SupabaseClient _client;
  SessionRepository(this._client);

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const AuthException('Necesitas iniciar sesión para esta acción.');
    }
    return id;
  }

  // ── Read ───────────────────────────────────────────────────

  /// Sesiones abiertas cercanas. Usa la función PostGIS get_nearby_sessions
  /// que calcula distancia con ST_DWithin sobre la columna `location`.
  Future<List<SessionModel>> getNearbySessions({
    required double lat,
    required double lng,
    double radiusKm = 3.0,
    String? sport,
  }) async {
    final res = await _client.rpc(
      'get_nearby_sessions',
      params: {
        'user_lat': lat,
        'user_lng': lng,
        'radius_km': radiusKm,
        'sport_filter': sport,
      },
    );
    final rows = (res as List).cast<Map<String, dynamic>>();
    return rows.map(SessionModel.fromMap).toList();
  }

  /// Sesión individual con el host embebido (JOIN a profiles vía host_id).
  Future<SessionModel> getSessionById(String sessionId) async {
    final row = await _client
        .from('sessions')
        .select('*, host:profiles!host_id(*)')
        .eq('id', sessionId)
        .single();
    return SessionModel.fromMap(row);
  }

  /// Participantes de una sesión con su estado.
  /// Devuelve una lista de (profile, status) para que el host vea pendientes/aceptados.
  Future<List<SessionParticipant>> getSessionParticipants(
      String sessionId) async {
    final rows = await _client
        .from('session_participants')
        .select('status, profiles:profiles!user_id(*)')
        .eq('session_id', sessionId)
        .neq('status', 'cancelled');
    return rows
        .map((r) {
          final profile = r['profiles'] as Map<String, dynamic>?;
          if (profile == null) return null;
          return SessionParticipant(
            status: r['status'] as String,
            profile: ProfileModel.fromMap(profile),
          );
        })
        .whereType<SessionParticipant>()
        .toList();
  }

  /// Sesiones donde el usuario es host (las que organiza).
  Future<List<SessionModel>> getUserSessions(String userId) async {
    final rows = await _client
        .from('sessions')
        .select('*, host:profiles!host_id(*)')
        .eq('host_id', userId)
        .order('scheduled_at', ascending: false);
    return rows.map(SessionModel.fromMap).toList();
  }

  /// Estado de mi participación en una sesión (null si no me uní).
  Future<String?> myParticipationStatus(String sessionId) async {
    final row = await _client
        .from('session_participants')
        .select('status')
        .eq('session_id', sessionId)
        .eq('user_id', _uid)
        .maybeSingle();
    return row?['status'] as String?;
  }

  /// Devuelve (o crea si no existe) el chat asociado a la sesión.
  Future<String> getOrCreateChatForSession(String sessionId) async {
    final res = await _client.rpc(
      'get_or_create_chat_for_session',
      params: {'p_session_id': sessionId},
    );
    return res as String;
  }

  // ── Write ──────────────────────────────────────────────────

  /// Publica una nueva sesión y dispara `match-users` para avisar a usuarios
  /// compatibles por WhatsApp (fire-and-forget).
  Future<SessionModel> createSession({
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
    final payload = {
      'host_id': _uid,
      'sport': sport,
      'level': level,
      'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      'duration_min': durationMin,
      'max_spots': maxSpots,
      'spots_available': maxSpots,
      'zone_name': zoneName,
      'location': 'SRID=4326;POINT($lng $lat)',
      'lat': lat,
      'lng': lng,
      'notes': notes,
      'women_only': womenOnly,
      'status': 'open',
    };
    final row =
        await _client.from('sessions').insert(payload).select().single();
    final session = SessionModel.fromMap(row);

    // Notifica a usuarios compatibles. No bloqueamos la publicación si falla.
    unawaited(_invokeFnSilent('match-users', {'session_id': session.id}));

    return session;
  }

  /// Unirse a una sesión: inserta participante en 'pending' y notifica al host.
  Future<void> joinSession(String sessionId) async {
    await _client.from('session_participants').insert({
      'session_id': sessionId,
      'user_id': _uid,
      'status': 'pending',
    });

    unawaited(_notifyHostOnJoin(sessionId));
  }

  /// El host acepta a un participante → el trigger decrementa spots_available.
  /// Notifica al usuario aceptado por WhatsApp.
  Future<void> acceptParticipant(String sessionId, String userId) async {
    await _client
        .from('session_participants')
        .update({'status': 'accepted'})
        .eq('session_id', sessionId)
        .eq('user_id', userId);

    unawaited(_notifyParticipantOnAccept(sessionId, userId));
  }

  /// El host rechaza a un participante.
  Future<void> rejectParticipant(String sessionId, String userId) async {
    await _client
        .from('session_participants')
        .update({'status': 'rejected'})
        .eq('session_id', sessionId)
        .eq('user_id', userId);
  }

  /// Cancela mi propia participación.
  Future<void> cancelParticipation(String sessionId) async {
    await _client
        .from('session_participants')
        .update({'status': 'cancelled'})
        .eq('session_id', sessionId)
        .eq('user_id', _uid);
  }

  /// Marca la sesión como completada (solo el host por RLS).
  Future<void> completeSession(String sessionId) async {
    await _client
        .from('sessions')
        .update({'status': 'completed'})
        .eq('id', sessionId);
  }

  /// Edita campos de una sesión (solo el host por RLS). No toca el cupo para
  /// no romper la contabilidad de spots_available.
  Future<SessionModel> updateSession({
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
    final row = await _client
        .from('sessions')
        .update({
          'sport': sport,
          'level': level,
          'scheduled_at': scheduledAt.toUtc().toIso8601String(),
          'zone_name': zoneName,
          'location': 'SRID=4326;POINT($lng $lat)',
          'lat': lat,
          'lng': lng,
          'notes': notes,
          'women_only': womenOnly,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', sessionId)
        .select()
        .single();
    return SessionModel.fromMap(row);
  }

  /// "Elimina" una sesión marcándola como cancelada (soft delete). Las RLS de
  /// lectura excluyen 'cancelled', así que desaparece del mapa para todos, y
  /// preservamos integridad con chats/ratings/participantes.
  Future<void> cancelSession(String sessionId) async {
    await _client
        .from('sessions')
        .update({'status': 'cancelled'})
        .eq('id', sessionId);
  }

  /// Bandeja de chats del usuario (host o participante aceptado) vía RPC.
  Future<List<Map<String, dynamic>>> getMyChats() async {
    final res = await _client.rpc('my_chats');
    return (res as List).cast<Map<String, dynamic>>();
  }

  /// Stream Realtime de sesiones abiertas. Realtime no soporta filtros
  /// PostGIS, así que escuchamos todas las abiertas y el provider re-consulta
  /// get_nearby_sessions cuando detecta cambios.
  Stream<List<Map<String, dynamic>>> watchSessionsInZone({
    required double lat,
    required double lng,
  }) {
    return _client
        .from('sessions')
        .stream(primaryKey: ['id'])
        .eq('status', 'open')
        .order('scheduled_at');
  }

  // ── WhatsApp notifications (fire-and-forget) ───────────────

  Future<void> _notifyHostOnJoin(String sessionId) async {
    try {
      final session = await getSessionById(sessionId);
      final hostId = session.host?.id ?? session.hostId;
      final myProfileRow = await _client
          .from('profiles')
          .select('display_name')
          .eq('id', _uid)
          .maybeSingle();
      final myName = (myProfileRow?['display_name'] as String?) ?? 'Alguien';
      await _invokeFnSilent('notify-push', {
        'user_id': hostId,
        'type': 'someone_joined',
        'title': 'Nueva solicitud para tu sesión',
        'body':
            '$myName quiere unirse a ${session.sportLabel} · ${DateFormatter.time(session.scheduledAt)}',
        'data': {
          'session_id': sessionId,
          'route': '/session/$sessionId',
        },
      });
    } catch (e) {
      debugPrint('notify host on join failed: $e');
    }
  }

  Future<void> _notifyParticipantOnAccept(
    String sessionId,
    String userId,
  ) async {
    try {
      final session = await getSessionById(sessionId);
      await _invokeFnSilent('notify-push', {
        'user_id': userId,
        'type': 'accepted',
        'title': '¡Tu solicitud fue aceptada!',
        'body':
            '${session.host?.displayName ?? 'El host'} confirmó tu ${session.sportLabel} '
                '${DateFormatter.dayAndTime(session.scheduledAt)} en ${session.zoneName}',
        'data': {
          'session_id': sessionId,
          'route': '/session/$sessionId',
        },
      });
    } catch (e) {
      debugPrint('notify participant on accept failed: $e');
    }
  }

  /// Invoca una Edge Function sin lanzar excepciones. Cualquier fallo va a logs.
  Future<void> _invokeFnSilent(
    String name,
    Map<String, dynamic> body,
  ) async {
    try {
      await _client.functions.invoke(name, body: body);
    } catch (e) {
      debugPrint('Edge function $name failed: $e');
    }
  }
}

/// Tupla útil para listas de participantes en la UI.
class SessionParticipant {
  final String status; // 'pending' | 'accepted' | 'rejected' | 'cancelled'
  final ProfileModel profile;
  const SessionParticipant({required this.status, required this.profile});
}
