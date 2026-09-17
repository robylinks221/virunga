import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExactQuickActions extends StatelessWidget {
  const ExactQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _Item(Icons.account_balance_wallet_outlined, 'Quick Deposit', 'Add money'),
      _Item(Icons.send_rounded, 'Send Money', 'To member'),
      _Item(Icons.description_outlined, 'Statements', 'View history'),
      _Item(Icons.headset_mic_outlined, 'Support', 'Get help'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.mintSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppTypography.tiny,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 9.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Item {
  const _Item(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}
