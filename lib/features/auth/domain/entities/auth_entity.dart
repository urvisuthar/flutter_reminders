import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_entity.dart';

part 'auth_entity.freezed.dart';

@freezed
abstract class AuthEntity with _$AuthEntity {
  const factory AuthEntity({
    required UserEntity user,
    required String accessToken,
    required String tokenType,
    required int expiresIn,
  }) = _AuthEntity;
}
