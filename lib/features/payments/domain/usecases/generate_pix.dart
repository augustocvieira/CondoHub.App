import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/payments/domain/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';

class GeneratePixKey extends UseCase<Either, GeneratePixParams> {
  final PaymentRepository repository;

  GeneratePixKey(this.repository);

  @override
  Future<Either> call(GeneratePixParams params) async {
    return await repository.generatePixKey(params.paymentId);
  }
}

class GeneratePixQRCode extends UseCase<Either, GeneratePixParams> {
  final PaymentRepository repository;

  GeneratePixQRCode(this.repository);

  @override
  Future<Either> call(GeneratePixParams params) async {
    return await repository.generatePixQRCode(params.paymentId);
  }
}

class GeneratePixParams extends Equatable {
  final String paymentId;

  const GeneratePixParams(this.paymentId);

  @override
  List<Object> get props => [paymentId];
}
