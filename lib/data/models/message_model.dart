import 'profile_model.dart';

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final ProfileModel? sender; // JOIN con profiles (nullable)

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.sender,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        id: map['id'] as String,
        chatId: map['chat_id'] as String,
        senderId: map['sender_id'] as String,
        content: map['content'] as String,
        sentAt: map['sent_at'] != null
            ? DateTime.parse(map['sent_at'] as String)
            : DateTime.now(),
        sender: map['sender'] != null
            ? ProfileModel.fromMap(map['sender'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'sender_id': senderId,
        'content': content,
      };
}
