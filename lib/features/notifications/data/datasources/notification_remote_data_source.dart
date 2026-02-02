// features/notifications/data/datasources/notification_remote_data_source.dart
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<ResponseModel<List<NotificationModel>>> getMyNotifications();
  Future<ResponseModel<bool>> markNotificationRead({required String id});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<List<NotificationModel>>> getMyNotifications() async {
    final response = await apiClient.get(ApiEndpoints.notifications);
    return ResponseModel.fromMap(
      response.data,
      (data) {
        if (data['notifications'] == null) return [];
        return (data['notifications'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<ResponseModel<bool>> markNotificationRead({required String id}) async {
    final response = await apiClient.patch(
      ApiEndpoints.notificationMarkRead(id),
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => true,
    );
  }
}
