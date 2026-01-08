import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isBiometricAvailable();
  Future<Either<Failure, bool>> authenticateWithBiometric();
  Future<Either<Failure, void>> enableBiometric(String userId);
  Future<Either<Failure, void>> disableBiometric(String userId);
}
