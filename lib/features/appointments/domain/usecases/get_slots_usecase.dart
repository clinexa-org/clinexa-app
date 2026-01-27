import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/slot_entity.dart';
import '../../domain/repositories/appointments_repository.dart';

class GetSlotsUseCase {
  final AppointmentsRepository repository;

  GetSlotsUseCase(this.repository);

  Future<Either<Failure, List<SlotEntity>>> call({required String date}) {
    return repository.getSlots(date: date);
  }
}
