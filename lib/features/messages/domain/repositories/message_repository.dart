import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/messages/domain/entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<Message>>> getMessages();
  Future<Either<Failure, void>> sendMessage(String content);
  Future<Either<Failure, void>> markAsRead(String messageId);
  Stream<List<Message>> watchMessages();
}
