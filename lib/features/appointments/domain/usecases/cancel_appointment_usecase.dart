import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/appointments_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentsRepository repository;

  CancelAppointmentUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String id,
  }) async {
    return await repository.cancelAppointment(id: id);
  }
}
