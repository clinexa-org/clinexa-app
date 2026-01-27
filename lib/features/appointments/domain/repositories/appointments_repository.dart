import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/slot_entity.dart';

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

  Future<Either<Failure, bool>> cancelAppointment({
    required String id,
  });

  Future<Either<Failure, List<SlotEntity>>> getSlots({
    required String date,
  });
}
