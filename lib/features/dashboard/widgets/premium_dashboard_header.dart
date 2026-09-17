import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PremiumDashboardHeader extends StatelessWidget {
  const PremiumDashboardHeader({
    super.key,
    required this.name,
    required this.subtitle,
  });

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? 'V' : name.trim()[0].toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
            const Spacer(),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: AppColors.textPrimary,
                size: 21,
              ),
            ),
            const SizedBox(width: 8),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.textPrimary,
                    size: 21,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 7,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(7, 5, 8, 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 31,
                    height: 31,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          subtitle.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: AppTypography.tiny,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 34,
            height: 1,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Welcome back, $name',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppTypography.small,
          ),
        ),
      ],
    );
  }
}
