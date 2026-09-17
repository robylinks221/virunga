import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MemberWalletHero extends StatefulWidget {
  const MemberWalletHero({
    super.key,
    required this.balance,
    required this.memberId,
    required this.phone,
    required this.accountSince,
    required this.isFrozen,
    this.onViewWallet,
  });

  final double balance;
  final String memberId;
  final String phone;
  final String accountSince;
  final bool isFrozen;
  final VoidCallback? onViewWallet;

  @override
  State<MemberWalletHero> createState() => _MemberWalletHeroState();
}

class _MemberWalletHeroState extends State<MemberWalletHero> {
  bool showBalance = true;

  String money(double value) {
    final integer = value.round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < integer.length; i++) {
      final reverseIndex = integer.length - i;
      buffer.write(integer[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primarySoft,
            AppColors.primaryDeep,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.large),
        border: Border.all(
          color: Colors.white.withValues(alpha: .14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: .22),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            bottom: -40,
            child: Icon(
              Icons.landscape_rounded,
              size: 180,
              color: Colors.white.withValues(alpha: .035),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Total Wallet Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: AppTypography.small,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => showBalance = !showBalance),
                    child: Icon(
                      showBalance
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.accentLight,
                    ),
                  ),
                  const Spacer(),
                  _StatusPill(isFrozen: widget.isFrozen),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                showBalance
                    ? 'UGX ${money(widget.balance)}'
                    : 'UGX ••••••',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Available Balance',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: AppTypography.small,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.badge_outlined,
                      label: 'Member ID',
                      value: widget.memberId,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryItem(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: widget.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _SummaryItem(
                icon: Icons.calendar_month_outlined,
                label: 'Account Since',
                value: widget.accountSince,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: widget.onViewWallet,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentLight,
                    foregroundColor: AppColors.primaryDeep,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Wallet',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 9),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isFrozen});
  final bool isFrozen;

  @override
  Widget build(BuildContext context) {
    final color = isFrozen ? AppColors.danger : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .17),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isFrozen ? 'Frozen' : 'Active',
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppTypography.tiny,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
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
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppColors.accentLight, size: 18),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: AppTypography.tiny,
                ),
              ),
              const SizedBox(height: 2),
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
