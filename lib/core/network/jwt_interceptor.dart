import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/network/api_endpoints.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';
import 'package:flutter_reminders/core/storage/token_storage.dart';

class JwtInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final LocalStorage _localStorage;
  final VoidCallback? onUnauthorized;

  bool _isHandlingUnauthorized = false;

  JwtInterceptor(this._tokenStorage, this._localStorage, this.onUnauthorized);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip login API
    if (options.path != ApiEndpoints.login) {
      final token = await _tokenStorage.getAccessToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if ((statusCode == 401 || statusCode == 403) && !_isHandlingUnauthorized) {
      _isHandlingUnauthorized = true;
      print(
        '[Auth] Session expired (HTTP $statusCode) — auto logout at ${DateTime.now()}',
      );
      await _tokenStorage.clear();
      await _localStorage.clear();

      onUnauthorized?.call();
    }

    return handler.next(err);
  }
}
