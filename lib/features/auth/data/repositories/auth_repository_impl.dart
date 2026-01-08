import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:condo_hub_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:condo_hub_app/features/auth/data/models/user_model.dart';
import 'package:condo_hub_app/features/auth/domain/entities/user.dart';
import 'package:condo_hub_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:condo_hub_app/features/onboarding/domain/repositories/condominium_repository.dart';
import 'package:flutter/foundation.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return Either.right(user);
    } catch (e) {
      debugPrint('Error during login: $e');
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return Either.right(null);
    } catch (e) {
      debugPrint('Error during logout: $e');
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      return Either.right(user);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() async {
    try {
      final isAvailable = await localDataSource.isBiometricAvailable();
      return Either.right(isAvailable);
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return Either.left(BiometricFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometric() async {
    try {
      final authenticated = await localDataSource.authenticateWithBiometric();
      return Either.right(authenticated);
    } catch (e) {
      debugPrint('Error authenticating with biometric: $e');
      return Either.left(BiometricFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometric(String userId) async {
    try {
      await localDataSource.enableBiometric(userId);
      final user = await localDataSource.getCurrentUser();
      if (user != null) {
        final updatedUser = UserModel.fromEntity(
          user.copyWith(biometricEnabled: true),
        );
        await localDataSource.cacheUser(updatedUser);
      }
      return Either.right(null);
    } catch (e) {
      debugPrint('Error enabling biometric: $e');
      return Either.left(BiometricFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometric(String userId) async {
    try {
      await localDataSource.disableBiometric(userId);
      final user = await localDataSource.getCurrentUser();
      if (user != null) {
        final updatedUser = UserModel.fromEntity(
          user.copyWith(biometricEnabled: false),
        );
        await localDataSource.cacheUser(updatedUser);
      }
      return Either.right(null);
    } catch (e) {
      debugPrint('Error disabling biometric: $e');
      return Either.left(BiometricFailure(e.toString()));
    }
  }
}
