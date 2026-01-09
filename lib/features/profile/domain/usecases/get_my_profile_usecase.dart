// features/profile/domain/usecases/get_my_profile_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/patient_entity.dart';
import '../repositories/patient_repository.dart';

class GetMyProfileUseCase {
  final PatientRepository repository;

  const GetMyProfileUseCase(this.repository);

  Future<Either<Failure, PatientEntity>> call() {
    return repository.getMyProfile();
  }
}