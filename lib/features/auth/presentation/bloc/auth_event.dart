part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginInRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class CheckAuthStatusRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}
