import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required int socialMediaFlag,
    String? profilePicture,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserEntity;
}
