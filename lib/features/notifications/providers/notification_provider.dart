import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../../auth/providers/auth_provider.dart';

part 'notification_provider.g.dart';

/// Stream Realtime de mis notificaciones (50 más recientes).
@riverpod
Stream<List<NotificationModel>> myNotifications(Ref ref) {
  // Se rebuildea al iniciar/cerrar sesión.
  ref.watch(authStateStreamProvider);
  return ref.watch(notificationRepositoryProvider).watchMine();
}

/// Cantidad de notificaciones sin leer (derivada del stream anterior).
@riverpod
int unreadNotificationCount(Ref ref) {
  final list = ref.watch(myNotificationsProvider).value;
  if (list == null) return 0;
  return list.where((n) => n.isUnread).length;
}

@riverpod
class NotificationController extends _$NotificationController {
  @override
  FutureOr<void> build() {}

  Future<void> markRead(List<String> ids) async {
    if (ids.isEmpty) return;
    await ref.read(notificationRepositoryProvider).markRead(ids);
  }

  Future<void> markAllRead() async {
    await ref.read(notificationRepositoryProvider).markAllRead();
  }
}
