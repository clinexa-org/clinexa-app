// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  const AuthRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, AuthSessionEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await remote.login(email: email, password: password);

      if (model.token.isEmpty) {
        return left(Failure(message: 'Token not found in response.'));
      }

      await local.saveToken(model.token);
      return right(model.toEntity());
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final model = await remote.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      if (model.token.isEmpty) {
        return left(Failure(message: 'Token not found in response.'));
      }

      await local.saveToken(model.token);
      return right(model.toEntity());
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await local.clearToken();
      return right(unit);
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }

  @override
  Future<Either<Failure, String?>> getCachedToken() async {
    try {
      final token = await local.readToken();
      return right(token);
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }
}