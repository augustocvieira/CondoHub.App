import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/messages/domain/repositories/message_repository.dart';
import 'package:equatable/equatable.dart';

class SendMessage extends UseCase<Either, SendMessageParams> {
  final MessageRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either> call(SendMessageParams params) async {
    return await repository.sendMessage(params.content);
  }
}

class SendMessageParams extends Equatable {
  final String content;

  const SendMessageParams(this.content);

  @override
  List<Object> get props => [content];
}
