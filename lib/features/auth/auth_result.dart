class AuthResult {
  const AuthResult({
    required this.access,
    required this.refresh,
  });

  final String access;
  final String refresh;

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final access = json['access']?.toString();
    final refresh = json['refresh']?.toString();

    if (access == null ||
        access.isEmpty ||
        refresh == null ||
        refresh.isEmpty) {
      throw const FormatException(
        'The server authenticated the request but did not return the expected access and refresh tokens.',
      );
    }

    return AuthResult(
      access: access,
      refresh: refresh,
    );
  }
}