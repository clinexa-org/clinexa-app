import 'package:dio/dio.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/dev_logger_interceptor.dart';
import 'interceptors/retry_interceptor_builder.dart';

class DioFactory {
  final TokenStorage tokenStorage;
  final bool isProd;

  DioFactory({
    required this.tokenStorage,
    required this.isProd,
  });

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(tokenStorage));
    dio.interceptors.add(buildRetryInterceptor(dio: dio));

    if (!isProd) {
      dio.interceptors.add(buildDevLogger());
    }

    return dio;
  }
}
