import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/appointment_model.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/usecases/get_my_appointments_usecase.dart';
import '../../domain/usecases/get_slots_usecase.dart';
import '../../domain/usecases/reschedule_appointment_usecase.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetMyAppointmentsUseCase getMyAppointmentsUseCase;
  final CreateAppointmentUseCase createAppointmentUseCase;
  final RescheduleAppointmentUseCase rescheduleAppointmentUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final GetSlotsUseCase getSlotsUseCase;

  AppointmentsCubit({
    required this.getMyAppointmentsUseCase,
    required this.createAppointmentUseCase,
    required this.rescheduleAppointmentUseCase,
    required this.cancelAppointmentUseCase,
    required this.getSlotsUseCase,
  }) : super(const AppointmentsState());

  Future<void> getMyAppointments() async {
    emit(state.copyWith(status: AppointmentsStatus.loading));

    final result = await getMyAppointmentsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentsStatus.failure,
        errorMessage: failure.message,
      )),
      (appointments) => emit(state.copyWith(
        status: AppointmentsStatus.success,
        appointments: appointments,
      )),
    );
  }

  Future<void> createAppointment({
    required String date,
    required String time,
    required String reason,
    String? notes,
  }) async {
    emit(state.copyWith(status: AppointmentsStatus.loading));

    final result = await createAppointmentUseCase(
      date: date,
      time: time,
      reason: reason,
      notes: notes,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentsStatus.failure,
        errorMessage: failure.message,
      )),
      (appointment) {
        // Optimistically add to list
        final currentList = List.of(state.appointments);
        currentList.add(appointment);

        emit(state.copyWith(
          status: AppointmentsStatus.success,
          lastCreatedAppointment: appointment,
          appointments: currentList,
        ));
      },
    );
  }

  Future<void> rescheduleAppointment({
    required String id,
    required String date,
    required String time,
  }) async {
    emit(state.copyWith(status: AppointmentsStatus.loading));

    final result = await rescheduleAppointmentUseCase(
      id: id,
      date: date,
      time: time,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentsStatus.failure,
        errorMessage: failure.message,
      )),
      (updatedAppointment) {
        final appointments = state.appointments.map((a) {
          return a.id == updatedAppointment.id ? updatedAppointment : a;
        }).toList();

        emit(state.copyWith(
          status: AppointmentsStatus.success,
          appointments: appointments,
        ));
      },
    );
  }

  Future<void> cancelAppointment({required String id}) async {
    emit(state.copyWith(status: AppointmentsStatus.loading));

    final result = await cancelAppointmentUseCase(id: id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentsStatus.failure,
        errorMessage: failure.message,
      )),
      (_) {
        // Update the appointment status locally using existing data
        // (API returns flat structure that can't be fully parsed)
        final appointments = state.appointments.map((a) {
          if (a.id == id) {
            return AppointmentModel(
              id: a.id,
              date: a.date,
              time: a.time,
              reason: a.reason,
              status: 'cancelled',
              doctorName: a.doctorName,
              doctorSpecialty: a.doctorSpecialty,
              doctorImage: a.doctorImage,
              clinicName: a.clinicName,
              clinicAddress: a.clinicAddress,
              latitude: a.latitude,
              longitude: a.longitude,
            );
          }
          return a;
        }).toList();

        emit(state.copyWith(
          status: AppointmentsStatus.success,
          appointments: appointments,
        ));
      },
    );
  }

  Future<void> getSlots({required String date}) async {
    emit(state.copyWith(slotsStatus: SlotsStatus.loading, slots: []));

    final result = await getSlotsUseCase(date: date);

    result.fold(
      (failure) => emit(state.copyWith(
        slotsStatus: SlotsStatus.failure,
        errorMessage: failure.message,
      )),
      (slots) => emit(state.copyWith(
        slotsStatus: SlotsStatus.success,
        slots: slots,
      )),
    );
  }
}
