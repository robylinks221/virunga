import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PremiumMetricCard extends StatelessWidget {
  const PremiumMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.78)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.north_east_rounded,
                size: 15,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.tiny,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 23,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: 5),
            Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.success,
                fontSize: AppTypography.tiny,
                fontWeight: FontWeight.w700,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
