import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/config/app_config.dart';
import 'package:flutter_reminders/core/network/jwt_interceptor.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../init_dependency.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio dio;

  DioClient(TokenStorage tokenStorage, LocalStorage localStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    // 🔐 JWT Interceptor
    dio.interceptors.add(
      JwtInterceptor(tokenStorage, localStorage, () {
        serviceLocator<AuthBloc>().add(const AuthEvent.logoutRequested());
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
