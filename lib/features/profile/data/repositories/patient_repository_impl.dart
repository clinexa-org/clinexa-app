// features/profile/data/repositories/patient_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_remote_data_source.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remote;

  const PatientRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, PatientEntity>> getMyProfile() async {
    try {
      final model = await remote.getMyProfile();
      return right(model.toEntity());
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (e) {
      return left(Failure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> createOrUpdateProfile({
    required int age,
    required String gender,
    required String phone,
    required String address,
  }) async {
    try {
      final model = await remote.createOrUpdateProfile(
        age: age,
        gender: gender,
        phone: phone,
        address: address,
      );
      return right(model.toEntity());
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (e) {
      return left(Failure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}