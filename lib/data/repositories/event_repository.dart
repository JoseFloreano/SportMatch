import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event_model.dart';

class EventRepository {
  final SupabaseClient _client;
  EventRepository(this._client);

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const AuthException('Necesitas iniciar sesión para esta acción.');
    }
    return id;
  }

  /// Eventos abiertos cercanos vía función PostGIS get_nearby_events.
  Future<List<EventModel>> getNearbyEvents({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    final res = await _client.rpc(
      'get_nearby_events',
      params: {
        'user_lat': lat,
        'user_lng': lng,
        'radius_km': radiusKm,
      },
    );
    final rows = (res as List).cast<Map<String, dynamic>>();
    return rows.map(EventModel.fromMap).toList();
  }

  Future<EventModel> getEventById(String eventId) async {
    final row =
        await _client.from('events').select().eq('id', eventId).single();
    return EventModel.fromMap(row);
  }

  /// Todos los eventos abiertos próximos (sin filtro de distancia). Los eventos
  /// patrocinados son city-wide, así que la bandeja muestra todo CDMX.
  Future<List<EventModel>> getUpcomingEvents() async {
    final rows = await _client
        .from('events')
        .select()
        .eq('status', 'open')
        .gte('scheduled_at', DateTime.now().toUtc().toIso8601String())
        .order('scheduled_at');
    return rows.map(EventModel.fromMap).toList();
  }

  /// Inscribe al usuario en un evento eligiendo nivel (rx/scaled/beginner).
  Future<void> registerForEvent(String eventId, String level) async {
    await _client.from('event_registrations').insert({
      'event_id': eventId,
      'user_id': _uid,
      'level': level,
      'status': 'registered',
    });
  }

  Future<void> cancelEventRegistration(String eventId) async {
    await _client
        .from('event_registrations')
        .update({'status': 'cancelled'})
        .eq('event_id', eventId)
        .eq('user_id', _uid);
  }

  Future<List<Map<String, dynamic>>> getUserEventRegistrations() async {
    final rows = await _client
        .from('event_registrations')
        .select()
        .eq('user_id', _uid);
    return rows;
  }
}
