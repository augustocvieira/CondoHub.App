import 'package:condo_hub_app/core/errors/failures.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/onboarding/domain/entities/condominium.dart';

abstract class CondominiumRepository {
  Future<Either<Failure, Condominium>> identifyByQRCode(String qrData);
  Future<Either<Failure, Condominium>> identifyByKey(String key);
  Future<Either<Failure, void>> saveSelectedCondominium(
      Condominium condominium);
  Future<Either<Failure, Condominium?>> getSelectedCondominium();
}
