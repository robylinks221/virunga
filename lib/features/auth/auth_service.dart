import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';
import 'auth_exception.dart';
import 'auth_result.dart';

class AuthService {
  AuthService({
    required TokenStorage tokenStorage,
    http.Client? client,
  })  : _tokenStorage = tokenStorage,
        _client = client ?? http.Client();

  final TokenStorage _tokenStorage;
  final http.Client _client;

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            ApiConfig.uri(ApiConfig.login),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'phone_number': phoneNumber,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 25));

      final body = _decodeMap(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final result = AuthResult.fromJson(body);
        await _tokenStorage.saveTokens(
          access: result.access,
          refresh: result.refresh,
        );
        return;
      }

      throw AuthException(
        _messageFromResponse(
          statusCode: response.statusCode,
          body: body,
        ),
      );
    } on SocketException {
      throw const AuthException(
        'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException {
      throw const AuthException(
        'Could not connect to the server. Please try again.',
      );
    } on FormatException catch (error) {
      throw AuthException(error.message);
    }
  }

  Future<bool> restoreSession() async {
    final access = await _tokenStorage.getAccessToken();
    if (access != null && access.isNotEmpty) {
      return true;
    }

    final refresh = await _tokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return false;
    }

    return refreshAccessToken();
  }

  Future<bool> refreshAccessToken() async {
    final refresh = await _tokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return false;
    }

    try {
      final response = await _client
          .post(
            ApiConfig.uri(ApiConfig.refresh),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'refresh': refresh}),
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        await _tokenStorage.clear();
        return false;
      }

      final body = _decodeMap(response.body);
      final access = body['access']?.toString();
      if (access == null || access.isEmpty) {
        await _tokenStorage.clear();
        return false;
      }

      await _tokenStorage.saveAccessToken(access);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> getValidAccessToken() async {
    var token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return token;
    }

    final refreshed = await refreshAccessToken();
    if (!refreshed) {
      throw const AuthException(
        'Your session has expired. Please log in again.',
      );
    }

    token = await _tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      throw const AuthException(
        'Your session has expired. Please log in again.',
      );
    }

    return token;
  }

  Future<http.Response> authenticatedGet(String path) async {
    var token = await getValidAccessToken();

    var response = await _client.get(
      ApiConfig.uri(path),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        throw const AuthException(
          'Your session has expired. Please log in again.',
        );
      }

      token = await getValidAccessToken();
      response = await _client.get(
        ApiConfig.uri(path),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }

    return response;
  }

  Future<http.Response> authenticatedDelete(String path) async {
    var token = await getValidAccessToken();

    var response = await _client.delete(
      ApiConfig.uri(path),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        throw const AuthException(
          'Your session has expired. Please log in again.',
        );
      }

      token = await getValidAccessToken();
      response = await _client.delete(
        ApiConfig.uri(path),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }

    return response;
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
  }

  static Map<String, dynamic> _decodeMap(String raw) {
    if (raw.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{'detail': decoded.toString()};
  }

  static String _messageFromResponse({
    required int statusCode,
    required Map<String, dynamic> body,
  }) {
    String? pick(dynamic value) {
      if (value == null) return null;
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value is List && value.isNotEmpty) {
        return pick(value.first);
      }
      if (value is Map && value.isNotEmpty) {
        for (final item in value.values) {
          final result = pick(item);
          if (result != null) return result;
        }
      }
      return null;
    }

    final serverMessage =
        pick(body['detail']) ??
        pick(body['non_field_errors']) ??
        pick(body['phone_number']) ??
        pick(body['password']) ??
        pick(body);

    if (serverMessage != null) {
      return serverMessage;
    }
    if (statusCode == 400 || statusCode == 401) {
      return 'Incorrect phone number or password.';
    }
    if (statusCode == 403) {
      return 'Your account is not allowed to sign in.';
    }
    if (statusCode >= 500) {
      return 'The server is temporarily unavailable. Please try again shortly.';
    }
    return 'Login failed. Please try again.';
  }
}
