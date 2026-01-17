import 'package:dio/dio.dart';

import '../config/env.dart';
import '../storage/cache_helper.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/dev_logger_interceptor.dart';
import 'interceptors/retry_interceptor_builder.dart';

class DioFactory {
  final CacheHelper cacheHelper;
  final bool isProd;
  final void Function()? onUnauthorized;

  DioFactory({
    required this.cacheHelper,
    required this.isProd,
    this.onUnauthorized,
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

    dio.interceptors.add(AuthInterceptor(
      cacheHelper,
      onUnauthorized: onUnauthorized,
    ));
    dio.interceptors.add(buildRetryInterceptor(dio: dio));

    if (!isProd) {
      dio.interceptors.add(buildDevLogger());
    }

    return dio;
  }
}
