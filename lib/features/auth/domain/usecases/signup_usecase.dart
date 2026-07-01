import 'dart:io';

import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_reminders/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignupUsecase implements Usecase<AuthEntity, SignupParams> {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(SignupParams params) async {
    return await repository.signup(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      phoneNo: params.phoneNo,
      socialMediaFlag: params.socialMediaFlag,
      token: params.token,
      profilePicture: params.profilePicture,
    );
  }
}

class SignupParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNo;
  final int socialMediaFlag;
  final String? token;
  final File? profilePicture;

  const SignupParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNo,
    this.socialMediaFlag = 0,
    this.token,
    this.profilePicture,
  });
}
