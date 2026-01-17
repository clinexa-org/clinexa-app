import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';

class GetMyAppointmentsUseCase {
  final AppointmentsRepository repository;

  GetMyAppointmentsUseCase(this.repository);

  Future<Either<Failure, List<AppointmentEntity>>> call() async {
    return await repository.getMyAppointments();
  }
}
