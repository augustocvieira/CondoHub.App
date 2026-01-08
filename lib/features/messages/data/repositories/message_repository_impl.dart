import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/messages/data/datasources/message_datasource.dart';
import 'package:condo_hub_app/features/messages/domain/entities/message.dart';
import 'package:condo_hub_app/features/messages/domain/repositories/message_repository.dart';
import 'package:flutter/foundation.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource dataSource;

  MessageRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Message>>> getMessages() async {
    try {
      final messages = await dataSource.getMessages();
      return Either.right(messages);
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String content) async {
    try {
      await dataSource.sendMessage(content);
      return Either.right(null);
    } catch (e) {
      debugPrint('Error sending message: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    try {
      await dataSource.markAsRead(messageId);
      return Either.right(null);
    } catch (e) {
      debugPrint('Error marking message as read: $e');
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<List<Message>> watchMessages() {
    return dataSource.watchMessages();
  }
}
