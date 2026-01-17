import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class RescheduleAppointmentUseCase {
  final AppointmentsRepository repository;

  RescheduleAppointmentUseCase(this.repository);

  Future<Either<Failure, AppointmentEntity>> call({
    required String id,
    required String date,
    required String time,
  }) async {
    return await repository.rescheduleAppointment(
      id: id,
      date: date,
      time: time,
    );
  }
}
