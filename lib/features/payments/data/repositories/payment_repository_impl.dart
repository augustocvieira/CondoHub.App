import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/payments/data/datasources/payment_datasource.dart';
import 'package:condo_hub_app/features/payments/domain/entities/payment.dart';
import 'package:condo_hub_app/features/payments/domain/repositories/payment_repository.dart';
import 'package:flutter/foundation.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource dataSource;

  PaymentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Payment>>> getPayments() async {
    try {
      final payments = await dataSource.getPayments();
      return Either.right(payments);
    } catch (e) {
      debugPrint('Error getting payments: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateBankSlip(String paymentId) async {
    try {
      final barcode = await dataSource.generateBankSlip(paymentId);
      return Either.right(barcode);
    } catch (e) {
      debugPrint('Error generating bank slip: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generatePixKey(String paymentId) async {
    try {
      final pixKey = await dataSource.generatePixKey(paymentId);
      return Either.right(pixKey);
    } catch (e) {
      debugPrint('Error generating PIX key: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generatePixQRCode(String paymentId) async {
    try {
      final pixKey = await dataSource.generatePixKey(paymentId);
      return Either.right(pixKey);
    } catch (e) {
      debugPrint('Error generating PIX QR code: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
