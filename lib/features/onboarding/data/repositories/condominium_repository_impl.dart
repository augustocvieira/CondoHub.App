import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/onboarding/data/datasources/condominium_local_datasource.dart';
import 'package:condo_hub_app/features/onboarding/data/datasources/condominium_remote_datasource.dart';
import 'package:condo_hub_app/features/onboarding/data/models/condominium_model.dart';
import 'package:condo_hub_app/features/onboarding/domain/entities/condominium.dart';
import 'package:condo_hub_app/features/onboarding/domain/repositories/condominium_repository.dart';
import 'package:flutter/foundation.dart';

class CondominiumRepositoryImpl implements CondominiumRepository {
  final CondominiumRemoteDataSource remoteDataSource;
  final CondominiumLocalDataSource localDataSource;

  CondominiumRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Condominium>> identifyByQRCode(String qrData) async {
    try {
      final condominium = await remoteDataSource.identifyByQRCode(qrData);
      return Either.right(condominium);
    } catch (e) {
      debugPrint('Error identifying by QR code: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Condominium>> identifyByKey(String key) async {
    try {
      final condominium = await remoteDataSource.identifyByKey(key);
      return Either.right(condominium);
    } catch (e) {
      debugPrint('Error identifying by key: $e');
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSelectedCondominium(
      Condominium condominium) async {
    try {
      await localDataSource.cacheCondominium(
        CondominiumModel.fromEntity(condominium),
      );
      return Either.right(null);
    } catch (e) {
      debugPrint('Error saving condominium: $e');
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Condominium?>> getSelectedCondominium() async {
    try {
      final condominium = await localDataSource.getSelectedCondominium();
      return Either.right(condominium);
    } catch (e) {
      debugPrint('Error getting selected condominium: $e');
      return Either.left(CacheFailure(e.toString()));
    }
  }
}
