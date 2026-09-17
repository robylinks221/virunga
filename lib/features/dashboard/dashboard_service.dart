import 'dart:convert';

import '../auth/auth_exception.dart';
import '../auth/auth_service.dart';
import 'dashboard_model.dart';

class DashboardService {
  const DashboardService({
    required this.authService,
  });

  final AuthService authService;

  Future<DashboardBundle> fetchBundle() async {
    final results = await Future.wait([
      _getJsonMap('/api/dashboard/stats/'),
      _getJsonMap('/api/auth/profile/'),
    ]);

    final dashboard = DashboardData.fromJson(results[0]);
    final profile = UserProfileData.fromJson(results[1]);

    CurrentUserData? currentUser;

    // /api/auth/me/ is the authoritative source for the user's role.
    // Keep this optional so a temporary problem with /me does not prevent the
    // rest of the dashboard from loading.
    try {
      final meResponse = await _getJsonMap('/api/auth/me/');
      final meJson = _unwrapUser(meResponse);
      currentUser = CurrentUserData.fromJson(meJson);
    } catch (_) {
      currentUser = null;
    }

    WalletData? wallet;
    List<LedgerEntryData> entries = const [];

    if (dashboard.scope != 'super_admin') {
      try {
        wallet = WalletData.fromJson(
          await _getJsonMap('/api/wallets/me/'),
        );
      } catch (_) {
        wallet = null;
      }

      try {
        final rawEntries = await _getJsonList('/api/wallets/me/entries/');
        entries = rawEntries
            .whereType<Map>()
            .map(
              (item) => LedgerEntryData.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      } catch (_) {
        entries = const [];
      }
    }

    return DashboardBundle(
      dashboard: dashboard,
      profile: profile,
      currentUser: currentUser,
      wallet: wallet,
      entries: entries,
    );
  }

  Map<String, dynamic> _unwrapUser(Map<String, dynamic> json) {
    final nested = json['user'];

    if (nested is Map) {
      return Map<String, dynamic>.from(nested);
    }

    final data = json['data'];

    if (data is Map) {
      final dataUser = data['user'];
      if (dataUser is Map) {
        return Map<String, dynamic>.from(dataUser);
      }

      // Some APIs use {"data": {...user fields...}}.
      if (data.containsKey('role')) {
        return Map<String, dynamic>.from(data);
      }
    }

    return json;
  }

  Future<Map<String, dynamic>> _getJsonMap(String path) async {
    final response = await authService.authenticatedGet(path);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        'Could not load $path (${response.statusCode}).',
      );
    }

    if (response.body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw AuthException('Unexpected response from $path.');
  }

  Future<List<dynamic>> _getJsonList(String path) async {
    final response = await authService.authenticatedGet(path);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        'Could not load $path (${response.statusCode}).',
      );
    }

    if (response.body.trim().isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final results = decoded['results'];
      if (results is List) return results;
    }

    throw AuthException('Unexpected response from $path.');
  }
}
