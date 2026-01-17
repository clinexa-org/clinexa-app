// features/profile/domain/repositories/patient_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/patient_entity.dart';

abstract class PatientRepository {
  Future<Either<Failure, PatientEntity>> getMyProfile();

  Future<Either<Failure, PatientEntity>> createOrUpdateProfile({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String address,
    File? avatar,
  });
}
