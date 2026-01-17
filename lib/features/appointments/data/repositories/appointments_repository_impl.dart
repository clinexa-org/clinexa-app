import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointment_remote_data_source.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments() async {
    try {
      final response = await remoteDataSource.getMyAppointments();
      if (response.success) {
        return Right(response.data ?? []);
      } else {
        return Left(Failure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(DioErrorMapper.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment({
    required String date,
    required String time,
    required String reason,
    String? notes,
  }) async {
    try {
      final response = await remoteDataSource.createAppointment(
        date: date,
        time: time,
        reason: reason,
        notes: notes,
      );
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(Failure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(DioErrorMapper.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment({
    required String id,
    required String date,
    required String time,
  }) async {
    try {
      final response = await remoteDataSource.rescheduleAppointment(
        id: id,
        date: date,
        time: time,
      );
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(Failure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(DioErrorMapper.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
