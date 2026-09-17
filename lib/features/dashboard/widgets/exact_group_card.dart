import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExactGroupCard extends StatelessWidget {
  const ExactGroupCard({
    super.key,
    required this.groupName,
    required this.community,
    required this.leaderName,
    required this.memberCount,
  });

  final String groupName;
  final String community;
  final String leaderName;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Group',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppTypography.h3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  'View group',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: AppTypography.small,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryDeep,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppTypography.bodyLarge,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        community,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: AppTypography.small,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _Row('Group Leader', leaderName),
                _Row('Total Members', '$memberCount'),
                _Row('Community', community),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppTypography.small,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppTypography.small,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
}
