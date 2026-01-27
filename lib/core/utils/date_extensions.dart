import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Converts the current DateTime to Cairo time (UTC+2).
  /// Note: This is a fixed offset for UTC+2.
  DateTime get toCairoTime {
    return toUtc().add(const Duration(hours: 2));
  }

  /// Formats the date to a localized string using Cairo time.
  String toCairoString(String pattern) {
    return DateFormat(pattern).format(toCairoTime);
  }
}
