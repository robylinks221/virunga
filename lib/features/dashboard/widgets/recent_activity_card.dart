import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../dashboard_model.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({
    super.key,
    required this.entries,
    this.onViewAll,
  });

  final List<LedgerEntryData> entries;
  final VoidCallback? onViewAll;

  String money(double value) {
    return value.abs().toStringAsFixed(0);
  }

  String date(DateTime? value) {
    if (value == null) return '';

    final local = value.toLocal();
    final now = DateTime.now();

    if (local.year == now.year &&
        local.month == now.month &&
        local.day == now.day) {
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final minute = local.minute.toString().padLeft(2, '0');
      final meridian = local.hour >= 12 ? 'PM' : 'AM';
      return 'Today, $hour:$minute $meridian';
    }

    return '${local.day}/${local.month}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final visible = entries.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.large),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppTypography.h3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No wallet activity yet.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppTypography.body,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(visible.length, (index) {
              final item = visible[index];
              final credit = item.isCredit;
              final label = item.entryTypeDisplay.trim().isNotEmpty
                  ? item.entryTypeDisplay
                  : (credit ? 'Deposit' : 'Withdrawal');
              final description = item.description.trim().isNotEmpty
                  ? item.description
                  : item.reference;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (credit
                                    ? AppColors.success
                                    : AppColors.warning)
                                .withValues(alpha: .12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            credit
                                ? Icons.south_rounded
                                : Icons.north_rounded,
                            color: credit
                                ? AppColors.success
                                : AppColors.warning,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: AppTypography.body,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                description.isEmpty
                                    ? 'Wallet transaction'
                                    : description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: AppTypography.tiny,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${credit ? '+' : '-'} UGX ${money(item.signedAmount == 0 ? item.amount : item.signedAmount)}',
                              style: TextStyle(
                                color: credit
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                                fontSize: AppTypography.small,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              date(item.createdAt),
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: AppTypography.tiny,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index != visible.length - 1)
                    const Divider(height: 1),
                ],
              );
            }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: onViewAll,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mintSoft,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View All Transactions',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
