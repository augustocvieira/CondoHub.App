import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/messages/domain/repositories/message_repository.dart';

class GetMessages extends UseCase<Either, NoParams> {
  final MessageRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either> call(NoParams params) async {
    return await repository.getMessages();
  }
}
