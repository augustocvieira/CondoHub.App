import 'package:condo_hub_app/core/utils/date_formatter.dart';
import 'package:condo_hub_app/features/dashboard/domain/entities/announcement.dart';
import 'package:condo_hub_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:condo_hub_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: AppSpacing.md),
                Text(state.message, style: context.textStyles.bodyLarge),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () =>
                      context.read<DashboardCubit>().loadAnnouncements(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoaded) {
          if (state.announcements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.announcement_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: AppSpacing.md),
                  Text('Nenhum comunicado ainda',
                      style: context.textStyles.bodyLarge),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<DashboardCubit>().loadAnnouncements(),
            child: ListView.separated(
              padding: AppSpacing.paddingMd,
              itemCount: state.announcements.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final announcement = state.announcements[index];
                return AnnouncementCard(announcement: announcement);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context
              .read<DashboardCubit>()
              .markAnnouncementAsRead(announcement.id);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(announcement.title),
              content: SingleChildScrollView(
                child: Text(announcement.content),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(context, announcement.type)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeIcon(announcement.type),
                          size: 14,
                          color: _getTypeColor(context, announcement.type),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTypeLabel(announcement.type),
                          style: context.textStyles.labelSmall?.copyWith(
                            color: _getTypeColor(context, announcement.type),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!announcement.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    DateFormatter.formatRelativeTime(announcement.createdAt),
                    style: context.textStyles.bodySmall?.withColor(
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                announcement.title,
                style: context.textStyles.titleMedium?.semiBold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                announcement.content,
                style: context.textStyles.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    announcement.authorName,
                    style: context.textStyles.bodySmall?.withColor(
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.notice:
        return Icons.info_outline;
      case AnnouncementType.warning:
        return Icons.warning_amber_outlined;
      case AnnouncementType.info:
        return Icons.lightbulb_outline;
      case AnnouncementType.maintenance:
        return Icons.build_outlined;
    }
  }

  String _getTypeLabel(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.notice:
        return 'AVISO';
      case AnnouncementType.warning:
        return 'ALERTA';
      case AnnouncementType.info:
        return 'INFO';
      case AnnouncementType.maintenance:
        return 'MANUTENÇÃO';
    }
  }

  Color _getTypeColor(BuildContext context, AnnouncementType type) {
    switch (type) {
      case AnnouncementType.notice:
        return Theme.of(context).colorScheme.primary;
      case AnnouncementType.warning:
        return Colors.orange;
      case AnnouncementType.info:
        return Colors.blue;
      case AnnouncementType.maintenance:
        return Colors.purple;
    }
  }
}
