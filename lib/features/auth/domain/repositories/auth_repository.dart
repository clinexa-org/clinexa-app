// features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSessionEntity>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, String?>> getCachedToken();
}