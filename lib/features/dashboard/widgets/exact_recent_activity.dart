import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../dashboard_model.dart';

class ExactRecentActivity extends StatelessWidget {
  const ExactRecentActivity({
    super.key,
    required this.entries,
  });

  final List<LedgerEntryData> entries;

  @override
  Widget build(BuildContext context) {
    final visible = entries.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppTypography.h3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppTypography.small,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No wallet activity yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            for (final entry in visible)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (entry.isCredit
                                ? AppColors.success
                                : AppColors.warning)
                            .withValues(alpha: .12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        entry.isCredit
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        color: entry.isCredit
                            ? AppColors.success
                            : AppColors.warning,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.entryTypeDisplay.isNotEmpty
                                ? entry.entryTypeDisplay
                                : (entry.isCredit ? 'Deposit' : 'Withdrawal'),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppTypography.body,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            entry.description.isNotEmpty
                                ? entry.description
                                : 'Wallet transaction',
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
                    Text(
                      '${entry.isCredit ? '+' : '-'} UGX ${entry.amount.abs().toStringAsFixed(0)}',
                      style: TextStyle(
                        color: entry.isCredit
                            ? AppColors.success
                            : AppColors.danger,
                        fontSize: AppTypography.small,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mintSoft,
                foregroundColor: AppColors.primaryDeep,
              ),
              child: const Text(
                'View All Transactions',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
