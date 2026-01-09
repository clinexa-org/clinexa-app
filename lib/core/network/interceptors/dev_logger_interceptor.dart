// core/network/interceptors/dev_logger_interceptor.dart
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

PrettyDioLogger buildDevLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
    compact: true,
    maxWidth: 120,
    logPrint: (object) {
      final raw = object.toString();

      /// Redact sensitive information
      var redacted = raw
      // Redact Authorization Bearer tokens
          .replaceAllMapped(
        RegExp(r'Authorization:\s*Bearer\s+[^\s]+', caseSensitive: false),
            (_) => 'Authorization: Bearer <redacted>',
      )
      // Redact passwords in request body
          .replaceAllMapped(
        RegExp(r'"password"\s*:\s*"[^"]*"', caseSensitive: false),
            (_) => '"password": "<redacted>"',
      )
      // Redact tokens in response body
          .replaceAllMapped(
        RegExp(r'"token"\s*:\s*"[^"]*"', caseSensitive: false),
            (_) => '"token": "<redacted>"',
      );

      debugPrint(redacted);
    },
  );
}