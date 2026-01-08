import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/dashboard/domain/repositories/announcement_repository.dart';

class GetAnnouncements extends UseCase<Either, NoParams> {
  final AnnouncementRepository repository;

  GetAnnouncements(this.repository);

  @override
  Future<Either> call(NoParams params) async {
    return await repository.getAnnouncements();
  }
}
