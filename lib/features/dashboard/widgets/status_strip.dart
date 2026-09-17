import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StatusStrip extends StatelessWidget {
  const StatusStrip({
    super.key,
    required this.items,
  });

  final List<StatusStripItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 14,
                right: index == items.length - 1 ? 0 : 14,
              ),
              decoration: BoxDecoration(
                border: index == items.length - 1
                    ? null
                    : const Border(
                        right: BorderSide(color: AppColors.divider),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppTypography.tiny,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class StatusStripItem {
  const StatusStripItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
