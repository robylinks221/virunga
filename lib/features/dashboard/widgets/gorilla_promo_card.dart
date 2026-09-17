import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class GorillaPromoCard extends StatelessWidget {
  const GorillaPromoCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryDeep,
        borderRadius: BorderRadius.circular(AppRadii.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: .18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 160,
            child: Image.asset(
              'assets/images/login_gorilla.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryDeep,
                  AppColors.primaryDeep.withValues(alpha: .94),
                  AppColors.primaryDeep.withValues(alpha: .22),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stronger together',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 38,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'Building better communities\nfor a brighter tomorrow.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppTypography.small,
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentLight,
                      foregroundColor: AppColors.primaryDeep,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Learn More',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(width: 7),
                        Icon(Icons.arrow_forward_rounded, size: 17),
                      ],
                    ),
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
