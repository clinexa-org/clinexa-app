// features/profile/domain/usecases/update_profile_usecase.dart
import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/patient_entity.dart';
import '../repositories/patient_repository.dart';

class UpdateProfileUseCase {
  final PatientRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<Either<Failure, PatientEntity>> call({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    return await repository.createOrUpdateProfile(
      name: name,
      age: age,
      gender: gender,
      phone: phone,
      address: address,
      avatar: avatar,
    );
  }
}
