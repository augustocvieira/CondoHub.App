import 'dart:convert';
import 'package:condo_hub_app/features/dashboard/data/models/announcement_model.dart';
import 'package:condo_hub_app/features/dashboard/domain/entities/announcement.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AnnouncementDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
  Future<void> markAsRead(String announcementId);
}

class AnnouncementDataSourceImpl implements AnnouncementDataSource {
  final SharedPreferences sharedPreferences;
  static const announcementsKey = 'CACHED_ANNOUNCEMENTS';

  AnnouncementDataSourceImpl({required this.sharedPreferences});

  List<AnnouncementModel> get _mockAnnouncements => [
        AnnouncementModel(
          id: 'ann-1',
          title: 'Manutenção da Piscina Neste Fim de Semana',
          content:
              'Prezados moradores, a piscina estará fechada para manutenção de rotina neste sábado e domingo. Pedimos desculpas pelo inconveniente.',
          type: AnnouncementType.maintenance,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          authorName: 'Administração',
          isRead: false,
        ),
        AnnouncementModel(
          id: 'ann-2',
          title: 'Atualização sobre Entregas de Encomendas',
          content:
              'A partir da próxima semana, todas as encomendas serão entregues na nova sala de correspondências no térreo. Retire suas encomendas no horário comercial: 9h às 18h.',
          type: AnnouncementType.info,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          authorName: 'Portaria',
          isRead: false,
        ),
        AnnouncementModel(
          id: 'ann-3',
          title: 'Importante: Inspeção do Elevador',
          content:
              'O elevador norte estará fora de serviço na sexta-feira das 8h às 14h para inspeção de segurança obrigatória. Por favor, utilize o elevador sul durante este período.',
          type: AnnouncementType.warning,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          authorName: 'Equipe de Manutenção',
          isRead: false,
        ),
        AnnouncementModel(
          id: 'ann-4',
          title: 'Assembleia do Condomínio no Próximo Mês',
          content:
              'A assembleia anual será realizada no dia 15 do próximo mês às 19h no salão de festas. Todos os moradores são convidados a participar.',
          type: AnnouncementType.notice,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          authorName: 'Conselho do Condomínio',
          isRead: false,
        ),
        AnnouncementModel(
          id: 'ann-5',
          title: 'Regras para Decorações de Festas',
          content:
              'Os moradores podem colocar decorações nas varandas e portas de entrada. Certifique-se de que as decorações estejam de acordo com as normas do condomínio e sejam removidas em até duas semanas após a data da festividade.',
          type: AnnouncementType.info,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          authorName: 'Administração',
          isRead: false,
        ),
      ];

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final jsonString = sharedPreferences.getString(announcementsKey);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString);
        return decoded.map((item) => AnnouncementModel.fromJson(item)).toList();
      }
      await _cacheAnnouncements(_mockAnnouncements);
      return _mockAnnouncements;
    } catch (e) {
      debugPrint('Erro ao carregar comunicados: $e');
      return _mockAnnouncements;
    }
  }

  @override
  Future<void> markAsRead(String announcementId) async {
    try {
      final announcements = await getAnnouncements();
      final updatedAnnouncements = announcements.map((ann) {
        if (ann.id == announcementId) {
          return AnnouncementModel.fromEntity(ann.copyWith(isRead: true));
        }
        return ann;
      }).toList();
      await _cacheAnnouncements(updatedAnnouncements);
    } catch (e) {
      debugPrint('Erro ao marcar comunicado como lido: $e');
      throw Exception('Falha ao marcar comunicado como lido');
    }
  }

  Future<void> _cacheAnnouncements(
      List<AnnouncementModel> announcements) async {
    try {
      final jsonList = announcements.map((ann) => ann.toJson()).toList();
      await sharedPreferences.setString(
          announcementsKey, json.encode(jsonList));
    } catch (e) {
      debugPrint('Erro ao salvar comunicados em cache: $e');
    }
  }
}
