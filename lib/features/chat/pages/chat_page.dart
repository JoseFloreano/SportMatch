import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/message_model.dart';
import '../../../data/providers/supabase_provider.dart';
import '../providers/chat_provider.dart';

/// Chat protegido (Sprint 2). El botón "Confirmar punto de encuentro" se
/// habilita cuando hay al menos un mensaje de cada lado.
class ChatPage extends ConsumerStatefulWidget {
  final String chatId;
  const ChatPage({super.key, required this.chatId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await ref.read(chatControllerProvider.notifier).sendMessage(
          chatId: widget.chatId,
          content: text,
        );
  }

  Future<void> _confirmMeetingPoint() async {
    await ref.read(chatControllerProvider.notifier).sendMessage(
          chatId: widget.chatId,
          content: '📍 Punto de encuentro confirmado.',
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Punto de encuentro confirmado. ¡Nos vemos en la sesión!'),
      ),
    );
  }

  bool _bothPartiesMessaged(List<MessageModel> messages, String? myId) {
    if (myId == null) return false;
    var mine = false;
    var other = false;
    for (final m in messages) {
      if (m.senderId == myId) {
        mine = true;
      } else {
        other = true;
      }
      if (mine && other) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final myId = ref.watch(supabaseClientProvider).auth.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('CHAT', style: AppTextStyles.headline3),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.mist,
            padding: const EdgeInsets.all(10),
            child: Text(
              '🔒 La ubicación exacta se revela cuando ambos confirmen.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ),
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (messages) {
                final canConfirm = _bothPartiesMessaged(messages, myId);
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (_, i) {
                          final m = messages[i];
                          final mine = m.senderId == myId;
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    mine ? AppColors.ink : AppColors.mist,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                m.content,
                                style: AppTextStyles.body.copyWith(
                                  color:
                                      mine ? AppColors.white : AppColors.ink,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: canConfirm ? _confirmMeetingPoint : null,
                          icon: const Icon(Icons.location_on_outlined),
                          label: Text(
                            canConfirm
                                ? 'Confirmar punto de encuentro'
                                : 'Confirmar punto (espera respuesta del otro)',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                canConfirm ? AppColors.ink : AppColors.slate,
                            side: BorderSide(
                              color: canConfirm
                                  ? AppColors.ink
                                  : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje…',
                        filled: true,
                        fillColor: AppColors.mist,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppColors.ink),
                    onPressed: _send,
                    icon: const Icon(Icons.send, color: AppColors.volt),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
