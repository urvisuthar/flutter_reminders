part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = _LoginRequested;

  const factory AuthEvent.signupRequested({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNo,
    @Default(0) int socialMediaFlag,
    String? token,
    File? profilePicture,
  }) = _SignupRequested;

  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;

  const factory AuthEvent.logoutRequested() = _LogoutRequested;
}
