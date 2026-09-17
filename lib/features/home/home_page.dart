import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07100D),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 72,
                  color: Color(0xFFD7A845),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login Successful',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The app is now authenticated with the Virunga backend. '
                  'We will replace this temporary page with the correct role-based dashboard next.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB7BDBA),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () async {
                    await authService.logout();

                    if (!context.mounted) return;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => LoginPage(
                          authService: authService,
                        ),
                      ),
                      (_) => false,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD7A845),
                    foregroundColor: const Color(0xFF11130F),
                    minimumSize: const Size(180, 52),
                  ),
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}