import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/rating_model.dart';

class RatingRepository {
  final SupabaseClient _client;
  RatingRepository(this._client);

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) {
      throw const AuthException('Necesitas iniciar sesión para calificar.');
    }
    return id;
  }

  /// Inserta una calificación. La columna `overall` se calcula en la DB
  /// (GENERATED) y un trigger recalcula el rating promedio del usuario.
  Future<void> rateUser({
    String? sessionId,
    String? eventId,
    required String ratedId,
    required int punctuality,
    required int levelAccuracy,
    required int respect,
    String? comment,
  }) async {
    assert(
      sessionId != null || eventId != null,
      'Una calificación necesita sessionId o eventId.',
    );
    await _client.from('ratings').insert({
      'session_id': sessionId,
      'event_id': eventId,
      'rater_id': _uid,
      'rated_id': ratedId,
      'punctuality': punctuality,
      'level_accuracy': levelAccuracy,
      'respect': respect,
      'comment': comment,
    });
  }

  Future<List<RatingModel>> getSessionRatings(String sessionId) async {
    final rows =
        await _client.from('ratings').select().eq('session_id', sessionId);
    return rows.map(RatingModel.fromMap).toList();
  }

  Future<List<RatingModel>> getUserRatings(String userId) async {
    final rows = await _client
        .from('ratings')
        .select()
        .eq('rated_id', userId)
        .order('created_at', ascending: false);
    return rows.map(RatingModel.fromMap).toList();
  }

  /// True si el usuario actual aún NO ha calificado esta sesión.
  Future<bool> hasPendingRating(String sessionId) async {
    final row = await _client
        .from('ratings')
        .select('id')
        .eq('session_id', sessionId)
        .eq('rater_id', _uid)
        .maybeSingle();
    return row == null;
  }
}
