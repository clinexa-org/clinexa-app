// features/auth/data/datasources/auth_remote_data_source.dart
import '../../../../core/network/api_client.dart';
import '../models/auth_session_model.dart';

class AuthRemoteDataSource {
  final ApiClient api;

  const AuthRemoteDataSource(this.api);

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final res = await api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final json = res.data ?? <String, dynamic>{};
    return AuthSessionModel.fromJson(json);
  }

  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await api.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    final json = res.data ?? <String, dynamic>{};
    return AuthSessionModel.fromJson(json);
  }
}