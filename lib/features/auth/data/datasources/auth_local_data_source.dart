import '../../../../core/storage/token_storage.dart';

class AuthLocalDataSource {
  final TokenStorage tokenStorage;

  const AuthLocalDataSource(this.tokenStorage);

  Future<void> saveToken(String token) => tokenStorage.saveToken(token);

  Future<String?> readToken() => tokenStorage.readToken();

  Future<void> clearToken() => tokenStorage.clearToken();
}
