// features/notifications/data/repositories/notifications_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getMyNotifications() async {
    try {
      final response = await remoteDataSource.getMyNotifications();
      if (response.success) {
        return Right(response.data!);
      }
      return Left(
          Failure(message: response.message ?? 'Failed to get notifications'));
    } on DioException catch (e) {
      return Left(Failure(
        message: e.response?.data?['message'] ?? 'Network error',
      ));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationRead(
      {required String id}) async {
    try {
      final response = await remoteDataSource.markNotificationRead(id: id);
      if (response.success) {
        return const Right(null);
      }
      return Left(Failure(
          message: response.message ?? 'Failed to mark notification as read'));
    } on DioException catch (e) {
      return Left(Failure(
        message: e.response?.data?['message'] ?? 'Network error',
      ));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
