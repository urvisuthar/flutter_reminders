import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/error/exceptions.dart';
import 'package:flutter_reminders/core/network/api_endpoints.dart';
import 'package:flutter_reminders/core/network/dio_client.dart';
import 'package:flutter_reminders/features/auth/data/models/auth_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
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
}
