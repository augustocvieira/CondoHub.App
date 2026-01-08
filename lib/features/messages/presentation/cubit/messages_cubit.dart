import 'dart:async';
import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/features/messages/domain/entities/message.dart';
import 'package:condo_hub_app/features/messages/domain/repositories/message_repository.dart';
import 'package:condo_hub_app/features/messages/domain/usecases/get_messages.dart';
import 'package:condo_hub_app/features/messages/domain/usecases/send_message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final MessageRepository repository;
  StreamSubscription<List<Message>>? _messagesSubscription;

  MessagesCubit({
    required this.getMessages,
    required this.sendMessage,
    required this.repository,
  }) : super(MessagesInitial());

  Future<void> loadMessages() async {
    emit(MessagesLoading());

    final result = await getMessages(NoParams());

    result.fold(
      (failure) => emit(MessagesError(failure.message)),
      (messages) {
        emit(MessagesLoaded(messages));
        _watchMessages();
      },
    );
  }

  void _watchMessages() {
    _messagesSubscription?.cancel();
    _messagesSubscription = repository.watchMessages().listen((messages) {
      emit(MessagesLoaded(messages));
    });
  }

  Future<void> sendNewMessage(String content) async {
    if (content.trim().isEmpty) return;

    emit(MessagesSending());

    final result = await sendMessage(SendMessageParams(content));

    result.fold(
      (failure) => emit(MessagesError(failure.message)),
      (_) => loadMessages(),
    );
  }

  Future<void> markMessageAsRead(String messageId) async {
    if (state is MessagesLoaded) {
      await repository.markAsRead(messageId);
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
