import 'package:dio/dio.dart';
import '../../storage/cache_helper.dart';

class AuthInterceptor extends Interceptor {
  final CacheHelper cacheHelper;
  final void Function()? onUnauthorized;

  AuthInterceptor(this.cacheHelper, {this.onUnauthorized});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await cacheHelper.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Invalid Token
    if (err.response?.statusCode == 401) {
      // Clear all cached data
      await CacheHelper.clearData();

      // Trigger callback for logout/navigation
      onUnauthorized?.call();
    }

    handler.next(err);
  }
}
