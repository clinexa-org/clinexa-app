import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/slot_entity.dart';

enum AppointmentsStatus { initial, loading, success, failure }

enum SlotsStatus { initial, loading, success, failure }

class AppointmentsState extends Equatable {
  final AppointmentsStatus status;
  final List<AppointmentEntity> appointments;
  final String? errorMessage;
  final AppointmentEntity? lastCreatedAppointment;
  final List<SlotEntity> slots;
  final SlotsStatus slotsStatus;

  const AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const [],
    this.errorMessage,
    this.lastCreatedAppointment,
    this.slots = const [],
    this.slotsStatus = SlotsStatus.initial,
  });

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<AppointmentEntity>? appointments,
    String? errorMessage,
    AppointmentEntity? lastCreatedAppointment,
    List<SlotEntity>? slots,
    SlotsStatus? slotsStatus,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
      lastCreatedAppointment:
          lastCreatedAppointment ?? this.lastCreatedAppointment,
      slots: slots ?? this.slots,
      slotsStatus: slotsStatus ?? this.slotsStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        appointments,
        errorMessage,
        lastCreatedAppointment,
        slots,
        slotsStatus,
      ];
}
