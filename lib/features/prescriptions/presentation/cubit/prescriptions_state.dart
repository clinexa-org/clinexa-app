import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription_entity.dart';

enum PrescriptionsStatus { initial, loading, success, failure }

class PrescriptionsState extends Equatable {
  final PrescriptionsStatus status;
  final List<PrescriptionEntity> prescriptions;
  final String? errorMessage;

  const PrescriptionsState({
    this.status = PrescriptionsStatus.initial,
    this.prescriptions = const [],
    this.errorMessage,
  });

  PrescriptionsState copyWith({
    PrescriptionsStatus? status,
    List<PrescriptionEntity>? prescriptions,
    String? errorMessage,
  }) {
    return PrescriptionsState(
      status: status ?? this.status,
      prescriptions: prescriptions ?? this.prescriptions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, prescriptions, errorMessage];
}
