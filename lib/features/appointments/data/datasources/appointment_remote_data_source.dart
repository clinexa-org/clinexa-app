import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<ResponseModel<List<AppointmentModel>>> getMyAppointments();
  Future<ResponseModel<AppointmentModel>> createAppointment({
    required String date,
    required String time,
    required String reason,
    String? notes,
  });

  Future<ResponseModel<AppointmentModel>> rescheduleAppointment({
    required String id,
    required String date,
    required String time,
  });

  Future<ResponseModel<bool>> cancelAppointment({
    required String id,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final ApiClient apiClient;

  AppointmentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<List<AppointmentModel>>> getMyAppointments() async {
    final response = await apiClient.get(ApiEndpoints.appointmentsMy);
    return ResponseModel.fromMap(
      response.data,
      (data) {
        if (data['appointments'] == null) return [];
        return (data['appointments'] as List)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<ResponseModel<AppointmentModel>> createAppointment({
    required String date,
    required String time,
    required String reason,
    String? notes,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.appointments,
      data: {
        'date': date,
        'time': time,
        'reason': reason,
        'notes': notes,
      },
    );

    return ResponseModel.fromMap(
      response.data,
      (data) => AppointmentModel.fromJson(data['appointment']),
    );
  }

  @override
  Future<ResponseModel<AppointmentModel>> rescheduleAppointment({
    required String id,
    required String date,
    required String time,
  }) async {
    final response = await apiClient.patch(
      ApiEndpoints.appointmentReschedule(id),
      data: {
        'date': date,
        'time': time,
      },
    );

    return ResponseModel.fromMap(
      response.data,
      (data) => AppointmentModel.fromJson(data['appointment']),
    );
  }

  @override
  Future<ResponseModel<bool>> cancelAppointment({
    required String id,
  }) async {
    final response = await apiClient.patch(
      ApiEndpoints.appointmentCancel(id),
    );

    return ResponseModel.fromMap(
      response.data,
      (data) => true, // Just return success, don't parse flat response
    );
  }
}
