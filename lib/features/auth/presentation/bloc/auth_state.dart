part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSuccess extends AuthState {
  final AuthEntity authEntity;

  const AuthSuccess(this.authEntity);

  @override
  List<Object> get props => [authEntity];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthAuthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthUnauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}
