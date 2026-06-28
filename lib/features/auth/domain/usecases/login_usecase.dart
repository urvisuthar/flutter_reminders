import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_reminders/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase implements Usecase<AuthEntity, AuthParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(AuthParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class AuthParams {
  final String email;
  final String password;

  const AuthParams({required this.email, required this.password});
}
