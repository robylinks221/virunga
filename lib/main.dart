import 'package:flutter/material.dart';

import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/login_page.dart';
import 'features/dashboard/dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final authService = AuthService(tokenStorage: tokenStorage);

  runApp(
    VirungaApp(
      authService: authService,
    ),
  );
}

class VirungaApp extends StatelessWidget {
  const VirungaApp({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virunga',
      theme: AppTheme.light,
      home: SessionGate(
        authService: authService,
      ),
    );
  }
}

class SessionGate extends StatefulWidget {
  const SessionGate({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late final Future<bool> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = widget.authService.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppColors.primaryDeep,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          return DashboardPage(
            authService: widget.authService,
          );
        }

        return LoginPage(
          authService: widget.authService,
        );
      },
    );
  }
}