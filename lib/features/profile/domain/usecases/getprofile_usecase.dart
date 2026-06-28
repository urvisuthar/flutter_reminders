import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_reminders/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProfileUseCase implements Usecase<UserEntity, NoParams> {
  final ProfileRepository profileRepository;

  GetProfileUseCase(this.profileRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return profileRepository.getProfile();
  }
}
