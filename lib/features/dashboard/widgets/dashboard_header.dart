import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.scope,
    required this.onLogout,
  });

  final String scope;
  final VoidCallback onLogout;

  String get _scopeLabel {
    switch (scope) {
      case 'super_admin':
        return 'Super Admin';
      case 'leader':
        return 'Group Leader';
      default:
        return 'Member';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppTypography.small,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _scopeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppTypography.h3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onLogout,
                tooltip: 'Log out',
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(
                  _headlineForScope(scope),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppTypography.h1,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                ),
                child: const Icon(
                  Icons.eco_outlined,
                  color: AppColors.primaryDeep,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _headlineForScope(String value) {
    switch (value) {
      case 'super_admin':
        return 'Platform overview';
      case 'leader':
        return 'Your group at a glance';
      default:
        return 'Your Virunga overview';
    }
  }
}