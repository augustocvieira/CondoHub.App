import 'package:condo_hub_app/features/dashboard/domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.type,
    required super.createdAt,
    required super.authorName,
    super.isRead,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: AnnouncementType.values.firstWhere(
        (e) => e.toString() == 'AnnouncementType.${json['type']}',
        orElse: () => AnnouncementType.notice,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: json['authorName'] as String,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'authorName': authorName,
      'isRead': isRead,
    };
  }

  factory AnnouncementModel.fromEntity(Announcement entity) {
    return AnnouncementModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      type: entity.type,
      createdAt: entity.createdAt,
      authorName: entity.authorName,
      isRead: entity.isRead,
    );
  }
}
