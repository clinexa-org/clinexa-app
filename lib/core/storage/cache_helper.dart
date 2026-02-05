import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static const _secureStorage = FlutterSecureStorage();

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> clearData() async {
    await _secureStorage.deleteAll();
    return sharedPreferences!.clear();
  }

  Future<String?> getCachedLanguageCode() async {
    final cachedLanguageCode = sharedPreferences!.getString('LANGUAGE_CODE');
    // Simplified logic as we don't have AppLocalizations setup visibly here yet
    return cachedLanguageCode;
  }

  Future<bool> saveUserLang(String lang) async {
    return await sharedPreferences!.setString('LANGUAGE_CODE', lang);
  }

  Future<bool> saveData({required String key, dynamic value}) async {
    if (value is String) return sharedPreferences!.setString(key, value);
    if (value is bool) return sharedPreferences!.setBool(key, value);
    if (value is int) return sharedPreferences!.setInt(key, value);
    if (value is double) return sharedPreferences!.setDouble(key, value);
    return false;
  }

  dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  int? getDataint({required String key}) {
    return sharedPreferences!.getInt(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }

  // --- Adapter Methods for Application Compatibility ---
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'auth_user_id';
  static const _keyUserName = 'auth_user_name';
  static const _keyUserRole = 'auth_user_role';
  static const _keyUserAvatar = 'auth_user_avatar';
  static const _keyOnboarding = 'has_seen_onboarding';

  // Secure Storage for Sensitive Data
  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _keyToken, value: token);
  Future<String?> readToken() => _secureStorage.read(key: _keyToken);
  Future<void> clearToken() => _secureStorage.delete(key: _keyToken);

  Future<void> saveUser({
    required String id,
    required String name,
    String? role,
    String? avatar,
  }) async {
    await _secureStorage.write(key: _keyUserId, value: id);
    await _secureStorage.write(key: _keyUserName, value: name);
    if (role != null)
      await _secureStorage.write(key: _keyUserRole, value: role);
    if (avatar != null) {
      await _secureStorage.write(key: _keyUserAvatar, value: avatar);
    }
  }

  Future<String?> readUserId() => _secureStorage.read(key: _keyUserId);
  Future<String?> getUserId() => readUserId();
  Future<String?> readUserName() => _secureStorage.read(key: _keyUserName);
  Future<String?> readUserRole() => _secureStorage.read(key: _keyUserRole);
  Future<String?> readUserAvatar() => _secureStorage.read(key: _keyUserAvatar);

  Future<void> clearUser() async {
    await _secureStorage.delete(key: _keyUserId);
    await _secureStorage.delete(key: _keyUserName);
    await _secureStorage.delete(key: _keyUserRole);
    await _secureStorage.delete(key: _keyUserAvatar);
  }

  // Shared Preferences for Non-Sensitive Data
  Future<bool> hasSeenOnboarding() async {
    final value = getData(key: _keyOnboarding);
    return value == true ||
        value == 'true'; // Handle bool or string persistence
  }

  Future<void> markOnboardingAsSeen() async {
    await saveData(key: _keyOnboarding, value: true);
  }

  Future<void> clearOnboardingFlag() async {
    await removeData(key: _keyOnboarding);
  }
}
