import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';

class CreateAppointmentUseCase {
  final AppointmentsRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<Either<Failure, AppointmentEntity>> call({
    required String date,
    required String time,
    required String reason,
    String? notes,
  }) async {
    return await repository.createAppointment(
      date: date,
      time: time,
      reason: reason,
      notes: notes,
    );
  }
}
