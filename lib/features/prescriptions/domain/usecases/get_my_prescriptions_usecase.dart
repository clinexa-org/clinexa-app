import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import '../entities/prescription_entity.dart';

class GetMyPrescriptionsUseCase {
  final PrescriptionsRepository repository;

  GetMyPrescriptionsUseCase(this.repository);

  Future<Either<Failure, List<PrescriptionEntity>>> call() async {
    return await repository.getMyPrescriptions();
  }
}
