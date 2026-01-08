import 'dart:async';
import 'dart:convert';
import 'package:condo_hub_app/features/messages/data/models/message_model.dart';
import 'package:condo_hub_app/features/messages/domain/entities/message.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MessageDataSource {
  Future<List<MessageModel>> getMessages();
  Future<void> sendMessage(String content);
  Future<void> markAsRead(String messageId);
  Stream<List<MessageModel>> watchMessages();
}

class MessageDataSourceImpl implements MessageDataSource {
  final SharedPreferences sharedPreferences;
  static const messagesKey = 'CACHED_MESSAGES';
  final _messagesController = StreamController<List<MessageModel>>.broadcast();

  MessageDataSourceImpl({required this.sharedPreferences});

  List<MessageModel> get _mockMessages => [
        MessageModel(
          id: 'msg-1',
          content:
              'Bem-vindo ao sistema de mensagens do condomínio! Fique à vontade para entrar em contato caso tenha alguma dúvida.',
          sender: MessageSender.syndic,
          timestamp: DateTime.now().subtract(const Duration(days: 30)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg-2',
          content:
              'Olá, percebi que os equipamentos da academia precisam de manutenção. Podem verificar, por favor?',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg-3',
          content:
              'Obrigado por nos informar. Agendamos uma visita de manutenção para esta sexta-feira.',
          sender: MessageSender.syndic,
          timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg-4',
          content:
              'Ótimo! Além disso, há alguma novidade sobre a distribuição das vagas de estacionamento?',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg-5',
          content:
              'Estamos revisando todas as solicitações de vagas e enviaremos as designações até o final desta semana.',
          sender: MessageSender.syndic,
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          isRead: false,
        ),
      ];

  @override
  Future<List<MessageModel>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final jsonString = sharedPreferences.getString(messagesKey);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString);
        return decoded.map((item) => MessageModel.fromJson(item)).toList();
      }
      await _cacheMessages(_mockMessages);
      return _mockMessages;
    } catch (e) {
      debugPrint('Erro ao carregar mensagens: $e');
      return _mockMessages;
    }
  }

  @override
  Future<void> sendMessage(String content) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final messages = await getMessages();
      final newMessage = MessageModel(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        content: content,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
        isRead: true,
      );

      messages.add(newMessage);
      await _cacheMessages(messages);
      _messagesController.add(messages);

      await Future.delayed(const Duration(seconds: 3));
      await _simulateSyndicReply(messages, content);
    } catch (e) {
      debugPrint('Erro ao enviar mensagem: $e');
      throw Exception('Falha ao enviar mensagem');
    }
  }

  Future<void> _simulateSyndicReply(
      List<MessageModel> messages, String userMessage) async {
    final replies = [
      'Obrigado pela sua mensagem. Vamos analisar este assunto.',
      'Anotei sua solicitação e retornarei em breve.',
      'Agradecemos seu feedback. Nossa equipe irá avaliar.',
      'Sua preocupação foi registrada. Resolveremos o mais rápido possível.',
    ];

    final syndicReply = MessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      content: replies[DateTime.now().second % replies.length],
      sender: MessageSender.syndic,
      timestamp: DateTime.now(),
      isRead: false,
    );

    messages.add(syndicReply);
    await _cacheMessages(messages);
    _messagesController.add(messages);
  }

  @override
  Future<void> markAsRead(String messageId) async {
    try {
      final messages = await getMessages();
      final updatedMessages = messages.map((msg) {
        if (msg.id == messageId) {
          return MessageModel.fromEntity(msg.copyWith(isRead: true));
        }
        return msg;
      }).toList();
      await _cacheMessages(updatedMessages);
      _messagesController.add(updatedMessages);
    } catch (e) {
      debugPrint('Erro ao marcar mensagem como lida: $e');
      throw Exception('Falha ao marcar mensagem como lida');
    }
  }

  @override
  Stream<List<MessageModel>> watchMessages() {
    getMessages().then((messages) => _messagesController.add(messages));
    return _messagesController.stream;
  }

  Future<void> _cacheMessages(List<MessageModel> messages) async {
    try {
      final jsonList = messages.map((msg) => msg.toJson()).toList();
      await sharedPreferences.setString(messagesKey, json.encode(jsonList));
    } catch (e) {
      debugPrint('Erro ao salvar mensagens em cache: $e');
    }
  }

  void dispose() {
    _messagesController.close();
  }
}
