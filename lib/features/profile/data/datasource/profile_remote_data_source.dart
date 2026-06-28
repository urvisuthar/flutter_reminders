import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/network/api_endpoints.dart';
import 'package:flutter_reminders/core/network/dio_client.dart';
import 'package:flutter_reminders/features/auth/data/models/user_model.dart';

import '../../../../core/error/exceptions.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.profile);

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
