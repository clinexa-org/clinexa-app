// features/profile/domain/usecases/update_profile_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/patient_entity.dart';
import '../repositories/patient_repository.dart';

class UpdateProfileUseCase {
  final PatientRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<Either<Failure, PatientEntity>> call({
    required int age,
    required String gender,
    required String phone,
    required String address,
  }) {
    return repository.createOrUpdateProfile(
      age: age,
      gender: gender,
      phone: phone,
      address: address,
    );
  }
}