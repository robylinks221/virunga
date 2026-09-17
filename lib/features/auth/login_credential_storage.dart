import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginCredentialStorage {
  LoginCredentialStorage({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _rememberKey = 'virunga_remember_login';
  static const String _phoneKey = 'virunga_saved_phone';
  static const String _passwordKey = 'virunga_saved_password';
  static const String _countryKey = 'virunga_saved_country';

  Future<bool> shouldRemember() async {
    return await _storage.read(key: _rememberKey) == 'true';
  }

  Future<String?> getPhone() => _storage.read(key: _phoneKey);
  Future<String?> getPassword() => _storage.read(key: _passwordKey);
  Future<String?> getCountryCode() => _storage.read(key: _countryKey);

  Future<void> save({
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    await _storage.write(key: _rememberKey, value: 'true');
    await _storage.write(key: _phoneKey, value: phone);
    await _storage.write(key: _passwordKey, value: password);
    await _storage.write(key: _countryKey, value: countryCode);
  }

  Future<void> clear() async {
    await _storage.delete(key: _rememberKey);
    await _storage.delete(key: _phoneKey);
    await _storage.delete(key: _passwordKey);
    await _storage.delete(key: _countryKey);
  }
}
