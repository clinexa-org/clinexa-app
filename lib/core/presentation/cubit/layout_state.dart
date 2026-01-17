// core/presentation/cubit/layout_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum LayoutStatus {
  initial,
  loading,
  ready,
}

class LayoutState extends Equatable {
  final LayoutStatus status;
  final String? initialRoute;
  final Locale locale;

  const LayoutState({
    this.status = LayoutStatus.initial,
    this.initialRoute,
    this.locale = const Locale('en'),
  });

  bool get isRTL => locale.languageCode == 'ar';

  LayoutState copyWith({
    LayoutStatus? status,
    String? initialRoute,
    Locale? locale,
  }) {
    return LayoutState(
      status: status ?? this.status,
      initialRoute: initialRoute ?? this.initialRoute,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [status, initialRoute, locale];
}
