import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/auth/domain/repositories/auth_repository.dart';

class AuthenticateBiometric extends UseCase<Either, NoParams> {
  final AuthRepository repository;

  AuthenticateBiometric(this.repository);

  @override
  Future<Either> call(NoParams params) async {
    return await repository.authenticateWithBiometric();
  }
}
