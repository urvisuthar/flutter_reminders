import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';
import 'package:flutter_reminders/core/storage/token_storage.dart';
import 'package:flutter_reminders/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_reminders/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/error/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;
  final LocalStorage localStorage;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.tokenStorage,
    this.localStorage,
  );

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save access token to secure storage
      await tokenStorage.saveTokens(
        accessToken: authModel.accessToken,
        expiresIn: authModel.expiresIn,
      );

      // Save user data to local storage
      await localStorage.saveUser(
        userId: authModel.user.id,
        username: '${authModel.user.firstName} ${authModel.user.lastName}',
        email: authModel.user.email,
      );

      return Right(authModel.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Unexpected error occurred'));
    }
  }

  Future<bool> checkAuthStatus() async {
    return await tokenStorage.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    return await tokenStorage.clear();
  }
}
