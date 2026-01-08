import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LoginUser extends UseCase<Either, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
