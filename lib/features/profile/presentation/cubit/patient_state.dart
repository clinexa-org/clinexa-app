// features/profile/presentation/cubit/patient_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/patient_entity.dart';

enum PatientStatus {
  initial,
  loading,
  success,
  error,
}

class PatientState extends Equatable {
  final PatientStatus status;
  final PatientEntity? patient;
  final String? avatarUrl;
  final String? errorMessage;

  const PatientState({
    this.status = PatientStatus.initial,
    this.patient,
    this.avatarUrl,
    this.errorMessage,
  });

  bool get hasProfile => patient != null;
  bool get isProfileComplete => patient?.isComplete ?? false;

  PatientState copyWith({
    PatientStatus? status,
    PatientEntity? patient,
    String? avatarUrl,
    String? errorMessage,
    bool clearError = false,
    bool clearPatient = false,
    bool clearAvatar = false,
  }) {
    return PatientState(
      status: status ?? this.status,
      patient: clearPatient ? null : (patient ?? this.patient),
      avatarUrl: clearAvatar ? null : (avatarUrl ?? this.avatarUrl),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, patient, avatarUrl, errorMessage];
}
