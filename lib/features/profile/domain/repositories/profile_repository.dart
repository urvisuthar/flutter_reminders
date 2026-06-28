import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile();
}
