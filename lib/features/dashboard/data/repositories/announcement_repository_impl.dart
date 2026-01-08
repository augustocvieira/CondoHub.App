import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/dashboard/data/datasources/announcement_datasource.dart';
import 'package:condo_hub_app/features/dashboard/domain/entities/announcement.dart';
import 'package:condo_hub_app/features/dashboard/domain/repositories/announcement_repository.dart';
import 'package:flutter/foundation.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementDataSource dataSource;

  AnnouncementRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Announcement>>> getAnnouncements() async {
    try {
      final announcements = await dataSource.getAnnouncements();
      return Either.right(announcements);
    } catch (e) {
      debugPrint('Error getting announcements: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String announcementId) async {
    try {
      await dataSource.markAsRead(announcementId);
      return Either.right(null);
    } catch (e) {
      debugPrint('Error marking announcement as read: $e');
      return Either.left(CacheFailure(e.toString()));
    }
  }
}
