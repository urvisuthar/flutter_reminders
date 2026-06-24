import 'package:equatable/equatable.dart';
import 'package:flutter_reminders/features/auth/domain/entities/user_entity.dart';

class AuthEntity extends Equatable {
  final UserEntity user;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  const AuthEntity({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  AuthEntity copyWith({
    UserEntity? user,
    String? accessToken,
    String? tokenType,
    int? expiresIn,
  }) {
    return AuthEntity(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  @override
  List<Object?> get props => [
    user,
    accessToken,
    tokenType,
    expiresIn,
  ];
}