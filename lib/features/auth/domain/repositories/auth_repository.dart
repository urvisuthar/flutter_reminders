import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<bool> checkAuthStatus();

  Future<void> logout();
}