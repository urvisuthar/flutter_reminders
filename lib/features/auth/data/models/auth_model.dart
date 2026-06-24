import 'package:flutter_reminders/features/auth/data/models/user_model.dart';
import 'package:flutter_reminders/features/auth/domain/entities/auth_entity.dart';

class AuthModel {
  final UserModel user;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  AuthModel({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AuthModel(
      user: UserModel.fromJson(data['user']),
      accessToken: data['access_token'],
      tokenType: data['token_type'],
      expiresIn: data['expires_in'],
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      user: user.toEntity(),
      accessToken: accessToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
    );
  }
}