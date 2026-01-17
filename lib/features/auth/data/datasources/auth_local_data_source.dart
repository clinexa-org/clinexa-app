import '../../../../core/storage/cache_helper.dart';

class AuthLocalDataSource {
  final CacheHelper cacheHelper;

  const AuthLocalDataSource(this.cacheHelper);

  Future<void> saveToken(String token) => cacheHelper.saveToken(token);

  Future<String?> readToken() => cacheHelper.readToken();

  Future<void> clearToken() => cacheHelper.clearToken();

  Future<void> saveUser({
    required String id,
    required String name,
    String? role,
    String? avatar,
  }) =>
      cacheHelper.saveUser(id: id, name: name, role: role, avatar: avatar);

  Future<String?> readUserId() => cacheHelper.readUserId();

  Future<String?> readUserName() => cacheHelper.readUserName();

  Future<String?> readUserRole() => cacheHelper.readUserRole();

  Future<String?> readUserAvatar() => cacheHelper.readUserAvatar();

  Future<void> clearUser() => cacheHelper.clearUser();
}
