// features/notifications/presentation/cubit/notifications_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notification_model.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(const NotificationsState());

  Future<void> getNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final result = await getNotificationsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationsStatus.failure,
        errorMessage: failure.message,
      )),
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await markNotificationReadUseCase(id: id);

    result.fold(
      (failure) => null, // Silently fail
      (_) {
        // Update local state
        final notifications = state.notifications.map((n) {
          if (n.id == id) {
            return NotificationModel(
              id: n.id,
              title: n.title,
              body: n.body,
              type: n.type,
              isRead: true,
              createdAt: n.createdAt,
              relatedId: n.relatedId,
            );
          }
          return n;
        }).toList();

        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(state.copyWith(
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
    );
  }

  /// Add a new notification locally (from socket event)
  void addNotification(Map<String, dynamic> data) {
    final notification = NotificationModel.fromJson(data);
    final notifications = [notification, ...state.notifications];
    final unreadCount = notifications.where((n) => !n.isRead).length;
    emit(state.copyWith(
      notifications: notifications,
      unreadCount: unreadCount,
    ));
  }
}
