import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<ResponseModel<List<PrescriptionModel>>> getMyPrescriptions();
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final ApiClient apiClient;

  PrescriptionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<List<PrescriptionModel>>> getMyPrescriptions() async {
    final response = await apiClient.get(
      ApiEndpoints.prescriptionsMy,
    );

    return ResponseModel<List<PrescriptionModel>>.fromJson(
      response.toString(),
      (data) {
        if (data['prescriptions'] != null) {
          return (data['prescriptions'] as List)
              .map((e) => PrescriptionModel.fromJson(e))
              .toList();
        }
        return [];
      },
    );
  }
}
