import 'dart:io';

import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNo,
    int socialMediaFlag = 0,
    String? token,
    File? profilePicture,
  });

  Future<bool> checkAuthStatus();

  Future<void> logout();
}
