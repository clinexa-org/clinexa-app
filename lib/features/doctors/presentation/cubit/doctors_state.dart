import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_entity.dart';

enum DoctorsStatus { initial, loading, success, failure }

class DoctorsState extends Equatable {
  final DoctorsStatus status;
  final List<DoctorEntity> doctors;
  final String? errorMessage;
  final DoctorEntity? selectedDoctor;

  const DoctorsState({
    this.status = DoctorsStatus.initial,
    this.doctors = const [],
    this.errorMessage,
    this.selectedDoctor,
  });

  DoctorsState copyWith({
    DoctorsStatus? status,
    List<DoctorEntity>? doctors,
    String? errorMessage,
    DoctorEntity? selectedDoctor,
  }) {
    return DoctorsState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
    );
  }

  @override
  List<Object?> get props => [status, doctors, errorMessage, selectedDoctor];
}
