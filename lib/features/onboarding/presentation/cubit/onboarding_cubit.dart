import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/features/onboarding/domain/entities/condominium.dart';
import 'package:condo_hub_app/features/onboarding/domain/repositories/condominium_repository.dart';
import 'package:condo_hub_app/features/onboarding/domain/usecases/identify_condominium.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IdentifyCondominium identifyCondominium;
  final CondominiumRepository repository;

  OnboardingCubit({
    required this.identifyCondominium,
    required this.repository,
  }) : super(OnboardingInitial());

  Future<void> identifyByQRCode(String qrData) async {
    emit(OnboardingLoading());

    final result = await identifyCondominium(
      IdentifyCondominiumParams(data: qrData, isQRCode: true),
    );

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (condominium) async {
        await repository.saveSelectedCondominium(condominium);
        emit(OnboardingSuccess(condominium));
      },
    );
  }

  Future<void> identifyByKey(String key) async {
    emit(OnboardingLoading());

    final result = await identifyCondominium(
      IdentifyCondominiumParams(data: key, isQRCode: false),
    );

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (condominium) async {
        await repository.saveSelectedCondominium(condominium);
        emit(OnboardingSuccess(condominium));
      },
    );
  }

  Future<void> checkExistingCondominium() async {
    final result = await repository.getSelectedCondominium();
    result.fold(
      (failure) => emit(OnboardingInitial()),
      (condominium) {
        if (condominium != null) {
          emit(OnboardingSuccess(condominium));
        } else {
          emit(OnboardingInitial());
        }
      },
    );
  }
}
