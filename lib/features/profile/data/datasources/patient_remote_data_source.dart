// features/profile/data/datasources/patient_remote_data_source.dart
import '../../../../core/network/api_client.dart';
import '../models/patient_model.dart';

class PatientRemoteDataSource {
  final ApiClient api;

  const PatientRemoteDataSource(this.api);

  Future<PatientModel> getMyProfile() async {
    final res = await api.get<Map<String, dynamic>>('/patients/me');

    final json = res.data ?? <String, dynamic>{};
    
    // Backend returns: { success: true, data: { patient: {...} } }
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final patientJson = data['patient'];
      if (patientJson is Map<String, dynamic>) {
        return PatientModel.fromJson(patientJson);
      }
    }

    throw Exception('Invalid response format');
  }

  Future<PatientModel> createOrUpdateProfile({
    required int age,
    required String gender,
    required String phone,
    required String address,
  }) async {
    final res = await api.post<Map<String, dynamic>>(
      '/patients',
      data: {
        'age': age,
        'gender': gender,
        'phone': phone,
        'address': address,
      },
    );

    final json = res.data ?? <String, dynamic>{};
    
    // Backend returns: { success: true, data: { patient: {...} } }
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final patientJson = data['patient'];
      if (patientJson is Map<String, dynamic>) {
        return PatientModel.fromJson(patientJson);
      }
    }

    throw Exception('Invalid response format');
  }
}