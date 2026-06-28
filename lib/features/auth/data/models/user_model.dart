import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    @JsonKey(name: 'phone_no') required String phoneNo,
    @JsonKey(name: 'social_media_flag') required int socialMediaFlag,
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserEntity toEntity() => UserEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phoneNo: phoneNo,
    socialMediaFlag: socialMediaFlag,
    profilePicture: profilePicture,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
