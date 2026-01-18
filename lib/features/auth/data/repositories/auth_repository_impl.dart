// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/dio_error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/user_entity.dart';
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
      final response = await remote.login(email: email, password: password);

      if (!response.success) {
        return left(Failure(message: response.message));
      }

      if (response.data == null || response.data!.token.isEmpty) {
        return left(Failure(message: 'Token not found in response.'));
      }

      await local.saveToken(response.data!.token);
      await local.saveUser(
        id: response.data!.user.id,
        name: response.data!.user.name,
        role: response.data!.user.role,
        avatar: response.data!.user.avatar,
      );
      return right(response.data!.toEntity());
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
      final response = await remote.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      if (!response.success) {
        return left(Failure(message: response.message));
      }

      if (response.data == null || response.data!.token.isEmpty) {
        return left(Failure(message: 'Token not found in response.'));
      }

      await local.saveToken(response.data!.token);
      await local.saveUser(
        id: response.data!.user.id,
        name: response.data!.user.name,
        role: response.data!.user.role,
        avatar: response.data!.user.avatar,
      );
      return right(response.data!.toEntity());
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
      await local.clearUser();
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

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final id = await local.readUserId();
      final name = await local.readUserName();
      final role = await local.readUserRole();
      final avatar = await local.readUserAvatar();

      if (id != null && name != null) {
        return right(UserEntity(
          id: id,
          name: name,
          email: '', // Not cached yet
          role: role ?? '',
          avatar: avatar,
          isActive: true,
        ));
      }
      return right(null);
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }

  @override
  Future<Either<Failure, int>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await remote.forgotPassword(email: email);

      if (!response.success) {
        return left(Failure(message: response.message));
      }

      return right(response.data ?? 600);
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await remote.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      if (!response.success) {
        return left(Failure(message: response.message));
      }

      return right(unit);
    } on DioException catch (e) {
      return left(DioErrorMapper.map(e));
    } catch (_) {
      return left(Failure(message: 'Unexpected error.'));
    }
  }
}
