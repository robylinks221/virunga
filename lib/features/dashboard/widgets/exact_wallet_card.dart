import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExactWalletCard extends StatelessWidget {
  const ExactWalletCard({
    super.key,
    required this.balance,
    required this.memberId,
    required this.phone,
    required this.accountSince,
    required this.active,
  });

  final double balance;
  final String memberId;
  final String phone;
  final String accountSince;
  final bool active;

  String money(double value) {
    return value.round().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.primarySoft,
              AppColors.primaryDeep,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeep.withValues(alpha: 0.22),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Total Wallet Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTypography.body,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.visibility_outlined,
                  color: AppColors.accentLight,
                  size: 18,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'UGX ${money(balance)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.9,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  AppRadii.pill,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.success
                          : AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    active
                        ? 'Active Account'
                        : 'Frozen Account',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.small,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Divider(
              color: Colors.white.withValues(alpha: 0.12),
              height: 1,
            ),

            const SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Info(
                    icon: Icons.badge_outlined,
                    label: 'Member ID',
                    value: memberId,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Info(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: phone,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            _Info(
              icon: Icons.calendar_month_outlined,
              label: 'Account Since',
              value: accountSince,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accentLight,
                  foregroundColor: AppColors.primaryDeep,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppRadii.pill,
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'View Wallet',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: AppTypography.body,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.accentLight,
            size: 18,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: AppTypography.tiny,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.small,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}