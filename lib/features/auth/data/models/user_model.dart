import 'package:flutter_reminders/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final int socialMediaFlag;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.socialMediaFlag,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNo: json['phone_no'],
      socialMediaFlag: json['social_media_flag'],
      profilePicture: json['profile_picture'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
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
}