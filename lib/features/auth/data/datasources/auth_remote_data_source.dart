// features/auth/data/datasources/auth_remote_data_source.dart
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/response_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_data_model.dart';

abstract class AuthRemoteDataSource {
  Future<ResponseModel<AuthDataModel>> login({
    required String email,
    required String password,
  });

  Future<ResponseModel<AuthDataModel>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<ResponseModel<int>> forgotPassword({
    required String email,
  });

  Future<ResponseModel<bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ResponseModel<AuthDataModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return ResponseModel.fromMap(
      response.data,
      (data) => AuthDataModel.fromMap(data),
    );
  }

  @override
  Future<ResponseModel<AuthDataModel>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    return ResponseModel.fromMap(
      response.data,
      (data) => AuthDataModel.fromMap(data),
    );
  }

  @override
  Future<ResponseModel<int>> forgotPassword({
    required String email,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );

    return ResponseModel.fromMap(
      response.data,
      (data) => data['expiresIn'] as int? ?? 600,
    );
  }

  @override
  Future<ResponseModel<bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      },
    );

    return ResponseModel.fromMap(
      response.data,
      (data) => true,
    );
  }
}
