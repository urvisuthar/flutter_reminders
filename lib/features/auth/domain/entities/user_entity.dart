import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final int socialMediaFlag;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
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

  UserEntity copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNo,
    int? socialMediaFlag,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      socialMediaFlag: socialMediaFlag ?? this.socialMediaFlag,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phoneNo,
    socialMediaFlag,
    profilePicture,
    createdAt,
    updatedAt,
  ];
}