import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/profile/domain/usecases/getprofile_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileCubit(this._getProfileUseCase) : super(const ProfileState.initial());

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());
    final result = await _getProfileUseCase.call(NoParams());
    result.fold(
      (failure) => emit(ProfileState.failure(failure)),
      (user) => emit(ProfileState.success(user)),
    );
  }
}
