import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/auth_service.dart';
import '../../auth/login_page.dart';

class AccountProfilePage extends StatefulWidget {
  const AccountProfilePage({
    super.key,
    required this.authService,
    required this.title,
  });

  final AuthService authService;
  final String title;

  @override
  State<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {
  bool _loggingOut = false;

  Future<void> _logout() async {
    if (_loggingOut) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'You will return to the login screen. Saved login details will remain available if you chose Remember me.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _loggingOut = true);

    await widget.authService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(
          authService: widget.authService,
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.h2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage your account and session.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.body,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.cardBorder,
              ),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accentSoft,
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    'Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    'Your Virunga account settings',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  onTap: _loggingOut ? null : _logout,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFEEEE),
                    child: Icon(
                      Icons.logout_rounded,
                      color: AppColors.danger,
                    ),
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: const Text(
                    'Sign out of this device',
                  ),
                  trailing: _loggingOut
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                          ),
                        )
                      : const Icon(
                          Icons.chevron_right_rounded,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
