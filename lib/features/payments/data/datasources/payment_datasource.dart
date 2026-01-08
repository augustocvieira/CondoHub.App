import 'dart:convert';
import 'package:condo_hub_app/features/payments/data/models/payment_model.dart';
import 'package:condo_hub_app/features/payments/domain/entities/payment.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PaymentDataSource {
  Future<List<PaymentModel>> getPayments();
  Future<String> generateBankSlip(String paymentId);
  Future<String> generatePixKey(String paymentId);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final SharedPreferences sharedPreferences;
  static const paymentsKey = 'CACHED_PAYMENTS';

  PaymentDataSourceImpl({required this.sharedPreferences});

  List<PaymentModel> get _mockPayments => [
        PaymentModel(
          id: 'pay-1',
          description: 'Taxa de Condomínio - Janeiro 2024',
          amount: 850.00,
          dueDate: DateTime.now().add(const Duration(days: 5)),
          status: PaymentStatus.pending,
          type: PaymentType.monthly,
          barcode: '23793.38128 60000.123456 78901.234567 8 12340000085000',
          pixKey: 'condo.sunset@banco.com',
        ),
        PaymentModel(
          id: 'pay-2',
          description: 'Taxa Extra - Reparo do Telhado',
          amount: 320.00,
          dueDate: DateTime.now().add(const Duration(days: 15)),
          status: PaymentStatus.pending,
          type: PaymentType.oneTime,
          barcode: '23793.38128 60000.654321 78901.234567 9 12340000032000',
          pixKey: 'condo.sunset@banco.com',
        ),
        PaymentModel(
          id: 'pay-3',
          description: 'Taxa de Condomínio - Dezembro 2023',
          amount: 850.00,
          dueDate: DateTime.now().subtract(const Duration(days: 45)),
          status: PaymentStatus.paid,
          type: PaymentType.monthly,
          barcode: '23793.38128 60000.789012 78901.234567 7 12340000085000',
          pixKey: 'condo.sunset@banco.com',
        ),
        PaymentModel(
          id: 'pay-4',
          description: 'Taxa de Condomínio - Novembro 2023',
          amount: 850.00,
          dueDate: DateTime.now().subtract(const Duration(days: 75)),
          status: PaymentStatus.paid,
          type: PaymentType.monthly,
          barcode: '23793.38128 60000.345678 78901.234567 6 12340000085000',
          pixKey: 'condo.sunset@banco.com',
        ),
      ];

  @override
  Future<List<PaymentModel>> getPayments() async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final jsonString = sharedPreferences.getString(paymentsKey);
      if (jsonString != null) {
        final List<dynamic> decoded = json.decode(jsonString);
        return decoded.map((item) => PaymentModel.fromJson(item)).toList();
      }
      await _cachePayments(_mockPayments);
      return _mockPayments;
    } catch (e) {
      debugPrint('Erro ao carregar pagamentos: $e');
      return _mockPayments;
    }
  }

  @override
  Future<String> generateBankSlip(String paymentId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final payments = await getPayments();
    final payment = payments.firstWhere(
      (p) => p.id == paymentId,
      orElse: () => throw Exception('Pagamento não encontrado'),
    );

    return payment.barcode ??
        '23793.38128 60000.000000 78901.234567 0 12340000000000';
  }

  @override
  Future<String> generatePixKey(String paymentId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final payments = await getPayments();
    final payment = payments.firstWhere(
      (p) => p.id == paymentId,
      orElse: () => throw Exception('Pagamento não encontrado'),
    );

    return payment.pixKey ?? 'condo.default@banco.com';
  }

  Future<void> _cachePayments(List<PaymentModel> payments) async {
    try {
      final jsonList = payments.map((pay) => pay.toJson()).toList();
      await sharedPreferences.setString(paymentsKey, json.encode(jsonList));
    } catch (e) {
      debugPrint('Erro ao salvar pagamentos em cache: $e');
    }
  }
}
