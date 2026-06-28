import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';
import 'user_model.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AuthModel with _$AuthModel {
  const AuthModel._();

  const factory AuthModel({
    required UserModel user,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  AuthEntity toEntity() => AuthEntity(
    user: user.toEntity(),
    accessToken: accessToken,
    tokenType: tokenType,
    expiresIn: expiresIn,
  );
}
