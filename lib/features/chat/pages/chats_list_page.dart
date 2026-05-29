import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../providers/chat_provider.dart';

/// Bandeja de chats: sesiones donde soy host o participante aceptado.
class ChatsListPage extends ConsumerWidget {
  const ChatsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(myChatsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('CHATS', style: AppTextStyles.headline3),
      ),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No pudimos cargar tus chats.\n$e',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ),
        data: (chats) {
          if (chats.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 48, color: AppColors.slate),
                    const SizedBox(height: 12),
                    Text('Aún no tienes chats',
                        style: AppTextStyles.headline3,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      'Cuando te unas a una sesión y te acepten, el chat aparece aquí.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myChatsProvider),
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = chats[i];
                final emoji = AppConstants.sportEmoji(c.sport);
                final sportLabel = AppConstants.sportLabel(c.sport);
                final preview = c.lastMessage ??
                    '${DateFormatter.dayAndTime(c.scheduledAt)} · ${c.zoneName}';
                return ListTile(
                  onTap: () => context.push('/chat/${c.chatId}'),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.tealLight,
                    child: Text(emoji, style: const TextStyle(fontSize: 18)),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text('$sportLabel · ${c.zoneName}',
                            style: AppTextStyles.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (c.isHost)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('HOST',
                              style: AppTextStyles.labelUppercase.copyWith(
                                  fontSize: 9, color: AppColors.volt)),
                        ),
                    ],
                  ),
                  subtitle: Text(preview,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
