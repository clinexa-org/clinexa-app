import 'package:dio/dio.dart';
import '../../storage/cache_helper.dart';

class AuthInterceptor extends Interceptor {
  final CacheHelper cacheHelper;

  AuthInterceptor(this.cacheHelper);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await cacheHelper.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
