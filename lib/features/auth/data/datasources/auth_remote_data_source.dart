import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/error/exceptions.dart';
import 'package:flutter_reminders/core/network/api_endpoints.dart';
import 'package:flutter_reminders/core/network/dio_client.dart';
import 'package:flutter_reminders/features/auth/data/models/auth_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});

  Future<AuthModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNo,
    int socialMediaFlag = 0,
    String? token,
    File? profilePicture,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      return AuthModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<AuthModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNo,
    int socialMediaFlag = 0,
    String? token,
    File? profilePicture,
  }) async {
    try {
      final formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'phone_no': phoneNo,
        'social_media_flag': socialMediaFlag,
        if (token != null && token.isNotEmpty) 'token': token,
        if (profilePicture != null)
          'profile_picture': await MultipartFile.fromFile(
            profilePicture.path,
          ),
      });
      final response = await dioClient.dio.post(
        ApiEndpoints.signup,
        data: formData,
      );

      return AuthModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
