import '../storage/cache_helper.dart';

class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

class LanguageManager {
  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
    LanguageModel(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
  ];

  static LanguageModel? getLanguageByCode(String code) {
    try {
      return supportedLanguages.firstWhere((lang) => lang.code == code);
    } catch (_) {
      return null;
    }
  }

  static final _cacheHelper = CacheHelper();

  static Future<String> getSavedLanguage() async {
    final lang = await _cacheHelper.getCachedLanguageCode();
    return lang ?? 'en';
  }

  static Future<void> saveLanguage(String code) async {
    await _cacheHelper.saveUserLang(code);
  }
}
