import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingStorage {
  OnboardingStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _completedKey = 'virunga_onboarding_completed';
  final FlutterSecureStorage _storage;

  Future<bool> isCompleted() async {
    return await _storage.read(key: _completedKey) == 'true';
  }

  Future<void> markCompleted() {
    return _storage.write(key: _completedKey, value: 'true');
  }
}
