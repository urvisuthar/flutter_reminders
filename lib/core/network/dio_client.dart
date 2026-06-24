import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/config/app_config.dart';
import 'package:flutter_reminders/core/network/jwt_interceptor.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../init_dependency.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio dio;

  DioClient(TokenStorage tokenStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    // 🔐 JWT Interceptor
    dio.interceptors.add(
      JwtInterceptor(tokenStorage, () {
        serviceLocator<AuthBloc>().add(LogoutRequested());
      }),
    );

    // 📄 Logging (non-prod only)
    if (AppConfig.isDebugLoggingEnabled) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }
}
