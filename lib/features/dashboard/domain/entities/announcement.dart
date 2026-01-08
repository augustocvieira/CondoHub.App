import 'package:equatable/equatable.dart';

enum AnnouncementType { notice, warning, info, maintenance }

class Announcement extends Equatable {
  final String id;
  final String title;
  final String content;
  final AnnouncementType type;
  final DateTime createdAt;
  final String authorName;
  final bool isRead;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.authorName,
    this.isRead = false,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    AnnouncementType? type,
    DateTime? createdAt,
    String? authorName,
    bool? isRead,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object> get props =>
      [id, title, content, type, createdAt, authorName, isRead];
}
