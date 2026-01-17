// features/profile/data/repositories/patient_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_remote_data_source.dart';

import '../../../../features/auth/data/datasources/auth_local_data_source.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remote;
  final AuthLocalDataSource local;

  const PatientRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, PatientEntity>> getMyProfile() async {
    try {
      final response = await remote.getMyProfile();
      if (response.success && response.data != null) {
        final patient = response.data!.patient;
        if (patient.user != null) {
          await local.saveUser(
            id: patient.user!.id!,
            name: patient.user!.name!,
            avatar: patient.user!.avatar,
          );
        }
        return right(patient.toEntity());
      }
      return left(Failure(
          message: response.message.isNotEmpty
              ? response.message
              : 'Failed to get profile'));
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (e) {
      return left(Failure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> createOrUpdateProfile({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    try {
      final response = await remote.createOrUpdateProfile(
        name: name,
        age: age,
        gender: gender,
        phone: phone,
        address: address,
        avatar: avatar,
      );
      if (response.success && response.data != null) {
        final patient = response.data!.patient;
        if (patient.user != null) {
          await local.saveUser(
            id: patient.user!.id!,
            name: patient.user!.name!,
            avatar: patient.user!.avatar,
          );
        }
        return right(patient.toEntity());
      }
      return left(Failure(
          message: response.message.isNotEmpty
              ? response.message
              : 'Failed to update profile'));
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (e) {
      return left(Failure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
