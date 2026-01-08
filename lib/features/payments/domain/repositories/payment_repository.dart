import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/payments/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<Payment>>> getPayments();
  Future<Either<Failure, String>> generateBankSlip(String paymentId);
  Future<Either<Failure, String>> generatePixKey(String paymentId);
  Future<Either<Failure, String>> generatePixQRCode(String paymentId);
}
