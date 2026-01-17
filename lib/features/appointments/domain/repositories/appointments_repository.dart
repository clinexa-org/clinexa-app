import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments();
  Future<Either<Failure, AppointmentEntity>> createAppointment({
    required String date,
    required String time,
    required String reason,
    String? notes,
  });

  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment({
    required String id,
    required String date,
    required String time,
  });
}
