import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/config/app_config.dart';
import 'package:flutter_reminders/core/network/jwt_interceptor.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
      // PrettyDioLogger prints FormData fields via a Map, which silently
      // drops duplicate keys (e.g. repeated 'deleted_image_ids[]' entries).
      // We log the request body ourselves so nothing gets hidden, and turn
      // off PrettyDioLogger's own body printing below to avoid double logs.
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final data = options.data;
            if (data is FormData) {
              print('╔ Form Data (raw fields, duplicates preserved)');
              for (final field in data.fields) {
                print('║ ${field.key}: ${field.value}');
              }
              for (final file in data.files) {
                print('║ ${file.key}: ${file.value.filename}');
              }
              print('╚══');
            } else if (data != null) {
              print('╔ Request Body');
              print('║ $data');
              print('╚══');
            }
            handler.next(options);
          },
        ),
      );

      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: false,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
        ),
      );
    }
  }
}
