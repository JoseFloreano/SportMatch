import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/message_model.dart';
import '../../../data/providers/supabase_provider.dart';

part 'chat_provider.g.dart';

/// Resumen de un chat para la bandeja.
class ChatSummary {
  final String chatId;
  final String sessionId;
  final String sport;
  final String zoneName;
  final DateTime scheduledAt;
  final bool isHost;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const ChatSummary({
    required this.chatId,
    required this.sessionId,
    required this.sport,
    required this.zoneName,
    required this.scheduledAt,
    required this.isHost,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatSummary.fromMap(Map<String, dynamic> m) => ChatSummary(
        chatId: m['chat_id'] as String,
        sessionId: m['session_id'] as String,
        sport: m['sport'] as String,
        zoneName: m['zone_name'] as String,
        scheduledAt: DateTime.parse(m['scheduled_at'] as String),
        isHost: m['is_host'] as bool? ?? false,
        lastMessage: m['last_message'] as String?,
        lastMessageAt: m['last_message_at'] != null
            ? DateTime.parse(m['last_message_at'] as String)
            : null,
      );
}

/// Bandeja de chats del usuario actual.
@riverpod
Future<List<ChatSummary>> myChats(Ref ref) async {
  final rows = await ref.watch(sessionRepositoryProvider).getMyChats();
  return rows.map(ChatSummary.fromMap).toList();
}

/// Stream Realtime de mensajes de un chat, ordenados cronológicamente.
/// (Sprint 2: la UI de chat consume este stream.)
@riverpod
Stream<List<MessageModel>> chatMessages(Ref ref, String chatId) {
  final client = ref.watch(supabaseClientProvider);
  return client
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('chat_id', chatId)
      .order('sent_at')
      .map((rows) => rows.map(MessageModel.fromMap).toList());
}

@riverpod
class ChatController extends _$ChatController {
  @override
  void build() {}

  /// Envía un mensaje al chat.
  Future<void> sendMessage({
    required String chatId,
    required String content,
  }) async {
    final client = ref.read(supabaseClientProvider);
    final senderId = client.auth.currentUser!.id;
    await client.from('messages').insert({
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
    });
  }
}
