import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/prescription_entity.dart';

abstract class PrescriptionsRepository {
  Future<Either<Failure, List<PrescriptionEntity>>> getMyPrescriptions();
}
