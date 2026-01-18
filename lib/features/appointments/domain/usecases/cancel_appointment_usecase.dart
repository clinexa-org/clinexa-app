import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentsRepository repository;

  CancelAppointmentUseCase(this.repository);

  Future<Either<Failure, AppointmentEntity>> call({
    required String id,
  }) async {
    return await repository.cancelAppointment(id: id);
  }
}
