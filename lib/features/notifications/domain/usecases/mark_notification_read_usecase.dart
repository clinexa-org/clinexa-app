// features/notifications/domain/usecases/mark_notification_read_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<Either<Failure, void>> call({required String id}) async {
    return await repository.markNotificationRead(id: id);
  }
}
