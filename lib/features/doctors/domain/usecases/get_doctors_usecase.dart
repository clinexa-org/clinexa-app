import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/doctors_repository.dart';
import '../entities/doctor_entity.dart';

class GetDoctorsUseCase {
  final DoctorsRepository repository;

  GetDoctorsUseCase(this.repository);

  Future<Either<Failure, List<DoctorEntity>>> call() async {
    return await repository.getDoctors();
  }
}
