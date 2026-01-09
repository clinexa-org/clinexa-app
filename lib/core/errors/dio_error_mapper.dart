import 'dart:io';

import 'package:dio/dio.dart';

import 'failures.dart';

class DioErrorMapper {
  static Failure map(DioException e) {
    final status = e.response?.statusCode;

    if (status != null) {
      final serverMessage = _extractServerMessage(e.response?.data);
      return Failure(
        message: serverMessage ?? 'Request failed with status $status',
        statusCode: status,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure(message: 'Request timeout. Please try again.');

      case DioExceptionType.connectionError:
      /// connectionError often wraps SocketException.
        if (e.error is SocketException) {
          return Failure(message: 'No internet connection.');
        }
        return Failure(message: 'Network connection error.');

      case DioExceptionType.cancel:
        return Failure(message: 'Request canceled.');

      case DioExceptionType.badCertificate:
        return Failure(message: 'Bad SSL certificate.');

      case DioExceptionType.unknown:
      /// unknown may wrap SocketException/HandshakeException.
        if (e.error is SocketException) {
          return Failure(message: 'No internet connection.');
        }
        if (e.error is HandshakeException) {
          return Failure(message: 'Secure connection failed (SSL handshake).');
        }
        return Failure(message: 'Unexpected network error.');

      case DioExceptionType.badResponse:
      /// If we got here, response might be null or malformed.
        return Failure(message: 'Server error. Please try again.');
    }
  }

  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final msg = data['message'] ?? data['error'] ?? data['msg'];
      if (msg is String && msg.trim().isNotEmpty) return msg.trim();

      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is String && first.trim().isNotEmpty) return first.trim();
        if (first is Map<String, dynamic>) {
          final m = first['msg'] ?? first['message'];
          if (m is String && m.trim().isNotEmpty) return m.trim();
        }
      }
    }
    return null;
  }
}
