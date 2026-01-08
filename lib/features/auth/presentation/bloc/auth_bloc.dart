import 'package:condo_hub_app/core/usecases/usecase.dart';
import 'package:condo_hub_app/features/auth/domain/entities/user.dart';
import 'package:condo_hub_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:condo_hub_app/features/auth/domain/usecases/authenticate_biometric.dart';
import 'package:condo_hub_app/features/auth/domain/usecases/login_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final AuthenticateBiometric authenticateBiometric;
  final AuthRepository repository;

  AuthBloc({
    required this.loginUser,
    required this.authenticateBiometric,
    required this.repository,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<BiometricSetupRequested>(_onBiometricSetupRequested);
    on<BiometricSetupSkipped>(_onBiometricSetupSkipped);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );

    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (user) async {
        final biometricAvailable = await repository.isBiometricAvailable();
        final shouldPromptBiometric = biometricAvailable.fold(
          (failure) => false,
          (isAvailable) => isAvailable && !user.biometricEnabled,
        );

        if (shouldPromptBiometric) {
          emit(AuthBiometricSetupRequired(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final userResult = await repository.getCurrentUser();
    final user = userResult.fold(
      (failure) => null,
      (user) => user,
    );

    if (user == null) {
      emit(const AuthError('No saved user found'));
      return;
    }

    final result = await authenticateBiometric(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authenticated) {
        if (authenticated) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError('Biometric authentication failed'));
        }
      },
    );
  }

  Future<void> _onBiometricSetupRequested(
    BiometricSetupRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await repository.enableBiometric(event.userId);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) async {
        final userResult = await repository.getCurrentUser();
        userResult.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user!)),
        );
      },
    );
  }

  Future<void> _onBiometricSetupSkipped(
    BiometricSetupSkipped event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthAuthenticated(event.user));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await repository.getCurrentUser();

    result.fold(
      (failure) => emit(AuthInitial()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthInitial());
        }
      },
    );
  }
}
