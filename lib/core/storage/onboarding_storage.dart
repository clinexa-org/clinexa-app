// core/storage/onboarding_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingStorage {
  static const _key = 'has_seen_onboarding';
  final FlutterSecureStorage _storage;

  OnboardingStorage(this._storage);

  Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }

  Future<void> markOnboardingAsSeen() async {
    await _storage.write(key: _key, value: 'true');
  }

  Future<void> clearOnboardingFlag() async {
    await _storage.delete(key: _key);
  }
}
