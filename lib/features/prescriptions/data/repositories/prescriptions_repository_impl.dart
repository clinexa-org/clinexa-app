import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import '../datasources/prescription_remote_data_source.dart';

class PrescriptionsRepositoryImpl implements PrescriptionsRepository {
  final PrescriptionRemoteDataSource remoteDataSource;

  PrescriptionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PrescriptionEntity>>> getMyPrescriptions() async {
    try {
      final response = await remoteDataSource.getMyPrescriptions();
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
}
