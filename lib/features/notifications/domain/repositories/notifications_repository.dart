// features/notifications/domain/repositories/notifications_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getMyNotifications();
  Future<Either<Failure, void>> markNotificationRead({required String id});
}
