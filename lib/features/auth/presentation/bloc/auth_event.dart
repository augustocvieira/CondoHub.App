part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class BiometricLoginRequested extends AuthEvent {
  const BiometricLoginRequested();
}

class BiometricSetupRequested extends AuthEvent {
  final String userId;

  const BiometricSetupRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class BiometricSetupSkipped extends AuthEvent {
  final User user;

  const BiometricSetupSkipped(this.user);

  @override
  List<Object> get props => [user];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}
