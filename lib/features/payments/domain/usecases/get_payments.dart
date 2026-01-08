import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/payments/domain/repositories/payment_repository.dart';

class GetPayments extends UseCase<Either, NoParams> {
  final PaymentRepository repository;

  GetPayments(this.repository);

  @override
  Future<Either> call(NoParams params) async {
    return await repository.getPayments();
  }
}
