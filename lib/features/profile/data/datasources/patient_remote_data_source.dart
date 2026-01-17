// features/profile/data/datasources/patient_remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<ResponseModel<PatientDataModel>> getMyProfile();

  Future<ResponseModel<PatientDataModel>> createOrUpdateProfile({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String address,
    File? avatar,
  });
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient apiClient;

  const PatientRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<PatientDataModel>> getMyProfile() async {
    final response = await apiClient.get(ApiEndpoints.patientMe);
    return ResponseModel.fromMap(
      response.data,
      (data) => PatientDataModel.fromMap(data),
    );
  }

  @override
  Future<ResponseModel<PatientDataModel>> createOrUpdateProfile({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    // Build form data
    final Map<String, dynamic> formMap = {
      'name': name,
      'age': age,
      'gender': gender,
      'phone': phone,
      'address': address,
    };

    // Add avatar if provided
    if (avatar != null) {
      final fileName = avatar.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      formMap['avatar'] = await MultipartFile.fromFile(
        avatar.path,
        filename: fileName,
        contentType: MediaType('image', extension == 'png' ? 'png' : 'jpeg'),
      );
    }

    final formData = FormData.fromMap(formMap);

    final response = await apiClient.post(
      ApiEndpoints.patients,
      data: formData,
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => PatientDataModel.fromMap(data),
    );
  }
}
