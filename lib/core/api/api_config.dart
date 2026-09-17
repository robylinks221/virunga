class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://backend.redrocksafrica.com';

  static const String login = '/api/auth/login/';
  static const String refresh = '/api/auth/token/refresh/';
  static const String me = '/api/auth/me/';
  static const String profile = '/api/auth/profile/';
  static const String forgotPassword = '/api/auth/forgot-password/';
  static const String dashboardStats = '/api/dashboard/stats/';

  static Uri uri(String path) => Uri.parse('$baseUrl$path');
}