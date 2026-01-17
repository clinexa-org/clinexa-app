import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment_entity.dart';

enum AppointmentsStatus { initial, loading, success, failure }

class AppointmentsState extends Equatable {
  final AppointmentsStatus status;
  final List<AppointmentEntity> appointments;
  final String? errorMessage;
  final AppointmentEntity? lastCreatedAppointment;

  const AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const [],
    this.errorMessage,
    this.lastCreatedAppointment,
  });

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<AppointmentEntity>? appointments,
    String? errorMessage,
    AppointmentEntity? lastCreatedAppointment,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
      lastCreatedAppointment:
          lastCreatedAppointment ?? this.lastCreatedAppointment,
    );
  }

  @override
  List<Object?> get props =>
      [status, appointments, errorMessage, lastCreatedAppointment];
}
