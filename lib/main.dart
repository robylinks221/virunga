import 'package:flutter/material.dart';

import 'core/storage/onboarding_storage.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/login_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/onboarding/onboarding_page.dart';

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
  late final Future<_StartupState> _startupFuture;

  @override
  void initState() {
    super.initState();
    _startupFuture = _resolveStartup();
  }

  Future<_StartupState> _resolveStartup() async {
    final hasSession = await widget.authService.restoreSession();

    if (hasSession) {
      return _StartupState.authenticated;
    }

    final onboardingCompleted = await OnboardingStorage().isCompleted();

    return onboardingCompleted
        ? _StartupState.login
        : _StartupState.onboarding;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StartupState>(
      future: _startupFuture,
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

        switch (snapshot.data) {
          case _StartupState.authenticated:
            return DashboardPage(authService: widget.authService);
          case _StartupState.login:
            return LoginPage(authService: widget.authService);
          case _StartupState.onboarding:
          default:
            return OnboardingPage(authService: widget.authService);
        }
      },
    );
  }
}

enum _StartupState {
  onboarding,
  login,
  authenticated,
}
