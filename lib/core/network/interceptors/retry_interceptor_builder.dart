import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

Interceptor buildRetryInterceptor({required Dio dio}) {
  return RetryInterceptor(
    dio: dio,
    retries: 3,
    retryDelays: const [
      Duration(milliseconds: 400),
      Duration(milliseconds: 900),
      Duration(milliseconds: 1500),
    ],
    retryEvaluator: (error, attempt) {
      final method = error.requestOptions.method.toUpperCase();
      if (method != 'GET') return false;

      final type = error.type;
      final isTimeout = type == DioExceptionType.connectionTimeout ||
          type == DioExceptionType.sendTimeout ||
          type == DioExceptionType.receiveTimeout;

      final isNetwork = type == DioExceptionType.connectionError;

      final status = error.response?.statusCode;
      final isServerError = status != null && status >= 500;

      return isTimeout || isNetwork || isServerError;
    },
  );
}
