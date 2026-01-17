import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<ResponseModel<List<DoctorModel>>> getDoctors();
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final ApiClient apiClient;

  DoctorRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<List<DoctorModel>>> getDoctors() async {
    final response = await apiClient.get(
      ApiEndpoints.doctors,
    );

    return ResponseModel<List<DoctorModel>>.fromJson(
      response.toString(),
      (data) {
        if (data['doctors'] != null) {
          return (data['doctors'] as List)
              .map((e) => DoctorModel.fromJson(e))
              .toList();
        }
        return [];
      },
    );
  }
}
