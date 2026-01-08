import 'package:equatable/equatable.dart';

enum MessageSender { user, syndic }

class Message extends Equatable {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isRead;

  const Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
  });

  Message copyWith({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object> get props => [id, content, sender, timestamp, isRead];
}
