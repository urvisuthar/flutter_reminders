import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_reminders/features/auth/domain/usecases/checkauthstatus_logout_usecase.dart';
import 'package:flutter_reminders/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_reminders/features/auth/domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final SignupUsecase _signupUsecase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required SignupUsecase signupUsecase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUsecase = loginUsecase,
       _signupUsecase = signupUsecase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState.initial()) {
    on<_LoginRequested>(_onLoginRequested);
    on<_SignupRequested>(_onSignupRequested);
    on<_CheckAuthStatus>(_onCheckAuthStatus);
    on<_LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    _LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _loginUsecase(
      AuthParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (authEntity) => emit(AuthState.success(authEntity)),
    );
  }

  Future<void> _onSignupRequested(
    _SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signupUsecase(
      SignupParams(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        phoneNo: event.phoneNo,
        socialMediaFlag: event.socialMediaFlag,
        token: event.token,
        profilePicture: event.profilePicture,
      ),
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure.message)),
      (authEntity) => emit(AuthState.success(authEntity)),
    );
  }

  Future<void> _onCheckAuthStatus(
    _CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final isLoggedIn = await _checkAuthStatusUseCase.call(NoParams());
    emit(
      isLoggedIn
          ? const AuthState.authenticated()
          : const AuthState.unauthenticated(),
    );
  }

  Future<void> _onLogoutRequested(
    _LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _logoutUseCase.call();
    emit(const AuthState.unauthenticated());
  }
}
