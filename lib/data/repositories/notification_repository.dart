import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification_model.dart';

class NotificationRepository {
  final SupabaseClient _client;
  NotificationRepository(this._client);

  /// Sube/actualiza el token FCM del usuario (idempotente por upsert).
  Future<void> registerPushToken(String token, {String platform = 'android'}) {
    return _client.rpc(
      'register_push_token',
      params: {'p_token': token, 'p_platform': platform},
    );
  }

  /// Stream Realtime de las notificaciones del usuario actual.
  Stream<List<NotificationModel>> watchMine() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50)
        .map((rows) => rows.map(NotificationModel.fromMap).toList());
  }

  Future<void> markRead(List<String> ids) async {
    if (ids.isEmpty) return;
    await _client.rpc('mark_notifications_read', params: {'p_ids': ids});
  }

  Future<void> markAllRead() async {
    await _client.rpc('mark_all_notifications_read');
  }
}
