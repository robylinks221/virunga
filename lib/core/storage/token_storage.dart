import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessKey = 'virunga_access_token';
  static const _refreshKey = 'virunga_refresh_token';

  const TokenStorage();

  FlutterSecureStorage get _storage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  Future<void> saveAccessToken(String access) {
    return _storage.write(key: _accessKey, value: access);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessKey);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshKey);
  }

  Future<void> clear() {
    return _storage.deleteAll();
  }
}