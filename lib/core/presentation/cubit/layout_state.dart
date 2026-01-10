// core/presentation/cubit/layout_state.dart
import 'package:equatable/equatable.dart';

enum LayoutStatus {
  initial,
  loading,
  ready,
}

class LayoutState extends Equatable {
  final LayoutStatus status;
  final String? initialRoute;

  const LayoutState({
    this.status = LayoutStatus.initial,
    this.initialRoute,
  });

  LayoutState copyWith({
    LayoutStatus? status,
    String? initialRoute,
  }) {
    return LayoutState(
      status: status ?? this.status,
      initialRoute: initialRoute ?? this.initialRoute,
    );
  }

  @override
  List<Object?> get props => [status, initialRoute];
}
