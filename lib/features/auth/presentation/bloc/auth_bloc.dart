import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_reminders/features/auth/domain/usecases/checkauthstatus_logout_usecase.dart';
import 'package:flutter_reminders/features/auth/domain/usecases/login_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final LoginUsecase _loginUsecase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUsecase = loginUsecase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _logoutUseCase = logoutUseCase,
       super(AuthInitial()) {
    // on<AuthEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<LoginInRequested>(_onLoginRequested);
    on<CheckAuthStatusRequested>(_checkAuthStatusRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(
    LoginInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginUsecase(
      AuthParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (authEntity) => emit(AuthSuccess(authEntity)),
    );
  }

  void _checkAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _checkAuthStatusUseCase.call(NoParams());

    if (result) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _logoutUseCase.call();
    emit(AuthUnauthenticated());
  }
}
