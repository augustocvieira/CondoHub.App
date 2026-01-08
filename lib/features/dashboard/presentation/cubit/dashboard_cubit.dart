import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/features/dashboard/domain/entities/announcement.dart';
import 'package:condo_hub_app/features/dashboard/domain/repositories/announcement_repository.dart';
import 'package:condo_hub_app/features/dashboard/domain/usecases/get_announcements.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetAnnouncements getAnnouncements;
  final AnnouncementRepository repository;

  DashboardCubit({
    required this.getAnnouncements,
    required this.repository,
  }) : super(DashboardInitial());

  Future<void> loadAnnouncements() async {
    emit(DashboardLoading());

    final result = await getAnnouncements(NoParams());

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (announcements) => emit(DashboardLoaded(announcements)),
    );
  }

  Future<void> markAnnouncementAsRead(String announcementId) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final result = await repository.markAsRead(announcementId);

      result.fold(
        (failure) => null,
        (_) {
          final updatedAnnouncements = currentState.announcements.map((ann) {
            if (ann.id == announcementId) {
              return ann.copyWith(isRead: true);
            }
            return ann;
          }).toList();
          emit(DashboardLoaded(updatedAnnouncements));
        },
      );
    }
  }
}
