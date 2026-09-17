import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PremiumHeroCard extends StatelessWidget {
  const PremiumHeroCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.value,
    required this.icon,
    this.badge,
    this.footer,
  });

  final String eyebrow;
  final String title;
  final String value;
  final IconData icon;
  final String? badge;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primarySoft,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -26,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: -34,
            child: Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.accentLight,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppTypography.tiny,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                eyebrow,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: AppTypography.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.bodyLarge,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              ),
              if (footer != null) ...[
                const SizedBox(height: 12),
                Text(
                  footer!,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: AppTypography.small,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
