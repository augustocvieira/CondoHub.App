import 'package:condo_hub_app/features/messages/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.timestamp,
    super.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      sender: MessageSender.values.firstWhere(
        (e) => e.toString() == 'MessageSender.${json['sender']}',
        orElse: () => MessageSender.user,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      sender: entity.sender,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
    );
  }
}
