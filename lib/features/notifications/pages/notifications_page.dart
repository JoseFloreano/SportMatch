import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  IconData _iconFor(String type) {
    switch (type) {
      case 'session_match':
        return Icons.location_on_outlined;
      case 'someone_joined':
        return Icons.person_add_outlined;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'rate_request':
        return Icons.star_border;
      default:
        return Icons.notifications_none;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(myNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('NOTIFICACIONES', style: AppTextStyles.headline3),
        actions: [
          TextButton(
            onPressed: () => ref
                .read(notificationControllerProvider.notifier)
                .markAllRead(),
            child: const Text('Marcar todas'),
          ),
        ],
      ),
      body: notifsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No pudimos cargar tus notificaciones.\n$e',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.notifications_none,
                        size: 48, color: AppColors.slate),
                    const SizedBox(height: 12),
                    Text(
                      'Sin notificaciones por ahora',
                      style: AppTextStyles.headline3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Te avisaremos cuando alguien publique cerca o se una a tu sesión.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final n = items[i];
              return _NotificationTile(
                notification: n,
                icon: _iconFor(n.type),
                onTap: () async {
                  if (n.isUnread) {
                    await ref
                        .read(notificationControllerProvider.notifier)
                        .markRead([n.id]);
                  }
                  if (!context.mounted) return;
                  final route = n.route;
                  if (route != null) context.push(route);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final IconData icon;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unread = notification.isUnread;
    return ListTile(
      onTap: onTap,
      tileColor: unread
          ? AppColors.volt.withValues(alpha: 0.08)
          : AppColors.white,
      leading: CircleAvatar(
        backgroundColor: unread ? AppColors.ink : AppColors.mist,
        child: Icon(icon, color: unread ? AppColors.volt : AppColors.slate),
      ),
      title: Text(
        notification.title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: Text(
        notification.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySmall,
      ),
      trailing: Text(
        DateFormatter.relativeDay(notification.createdAt),
        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
      ),
    );
  }
}
