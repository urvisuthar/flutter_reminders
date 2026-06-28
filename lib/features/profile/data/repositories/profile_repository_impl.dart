import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_reminders/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final LocalStorage localStorage;

  ProfileRepositoryImpl(this.profileRemoteDataSource, this.localStorage);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userModel = await profileRemoteDataSource.getProfile();

      await localStorage.saveUser(
        username: '${userModel.firstName} ${userModel.lastName}',
        email: userModel.email,
        profilePicture: userModel.profilePicture,
      );

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Unexpected error occurred'));
    }
  }
}
