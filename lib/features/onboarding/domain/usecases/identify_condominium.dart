import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/core/utils/either.dart';
import 'package:condo_hub_app/features/onboarding/domain/entities/condominium.dart';
import 'package:condo_hub_app/features/onboarding/domain/repositories/condominium_repository.dart';
import 'package:equatable/equatable.dart';

class IdentifyCondominium extends UseCase<Either, IdentifyCondominiumParams> {
  final CondominiumRepository repository;

  IdentifyCondominium(this.repository);

  @override
  Future<Either> call(IdentifyCondominiumParams params) async {
    if (params.isQRCode) {
      return await repository.identifyByQRCode(params.data);
    } else {
      return await repository.identifyByKey(params.data);
    }
  }
}

class IdentifyCondominiumParams extends Equatable {
  final String data;
  final bool isQRCode;

  const IdentifyCondominiumParams({
    required this.data,
    required this.isQRCode,
  });

  @override
  List<Object> get props => [data, isQRCode];
}
