import '../../../../core/storage/cache_helper.dart';

class AuthLocalDataSource {
  final CacheHelper cacheHelper;

  const AuthLocalDataSource(this.cacheHelper);

  Future<void> saveToken(String token) => cacheHelper.saveToken(token);

  Future<String?> readToken() => cacheHelper.readToken();

  Future<void> clearToken() => cacheHelper.clearToken();

  Future<void> saveUser({required String id, required String name}) =>
      cacheHelper.saveUser(id: id, name: name);

  Future<String?> readUserId() => cacheHelper.readUserId();

  Future<String?> readUserName() => cacheHelper.readUserName();

  Future<void> clearUser() => cacheHelper.clearUser();
}
