import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'premium_sparkline.dart';

class OverviewMetricCard extends StatelessWidget {
  const OverviewMetricCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.caption,
    required this.sparkline,
    required this.sparkColor,
    this.secondary,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String value;
  final String caption;
  final String? secondary;
  final List<double> sparkline;
  final Color sparkColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 11),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.tiny,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (secondary != null) ...[
            const SizedBox(height: 2),
            Text(
              secondary!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: iconColor,
                fontSize: AppTypography.small,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppTypography.tiny,
            ),
          ),
          const Spacer(),
          PremiumSparkline(
            values: sparkline,
            color: sparkColor,
            height: 35,
          ),
        ],
      ),
    );
  }
}
