import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../dashboard_model.dart';
import '../widgets/exact_group_card.dart';
import '../widgets/exact_header.dart';
import '../widgets/exact_overview_card.dart';
import '../widgets/exact_promo_card.dart';
import '../widgets/exact_quick_actions.dart';
import '../widgets/exact_recent_activity.dart';
import '../widgets/exact_wallet_card.dart';

class MemberDashboardHome extends StatelessWidget {
  const MemberDashboardHome({
    super.key,
    required this.data,
  });

  final DashboardBundle data;

  String _date(DateTime? value) {
    if (value == null) return '--';
    final d = value.toLocal();
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dash = data.dashboard;
    final wallet = data.wallet;

    final groupName =
        dash.stringValue(['group_name', 'group']) ?? 'My Group';
    final community =
        dash.stringValue(['community_name', 'community']) ?? 'Community';
    final role =
        dash.stringValue(['role_name', 'role']) ?? 'Community Member';
    final leader =
        dash.stringValue(['leader_name', 'group_leader', 'leader']) ?? '--';
    final memberCount =
        dash.intValue(['member_count', 'members', 'group_members']) ?? 0;

    final memberId = wallet?.userId == null
        ? (dash.stringValue(['member_id', 'user_id']) ?? '--')
        : 'VRG-MEM-${wallet!.userId.toString().padLeft(5, '0')}';

    final credits = data.entries
        .where((e) => e.isCredit)
        .fold<double>(0, (sum, e) => sum + e.amount.abs());

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {},
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ExactDashboardHeader(
              name: data.profile.fullName,
              roleLabel: 'Virunga $role',
            ),
          ),
          SliverToBoxAdapter(
            child: ExactWalletCard(
              balance: wallet?.balance ?? 0,
              memberId: memberId,
              phone: wallet?.phoneNumber.isNotEmpty == true
                  ? wallet!.phoneNumber
                  : '--',
              accountSince: _date(wallet?.createdAt),
              active: wallet?.isFrozen != true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              118,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const _OverviewHeading(),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: .92,
                    children: [
                      ExactOverviewCard(
                        icon: Icons.groups_rounded,
                        iconBg: AppColors.mintSoft,
                        iconColor: AppColors.success,
                        title: 'My Group',
                        subtitle: groupName,
                        value: '$memberCount',
                        caption: 'Members',
                        lineColor: AppColors.success,
                      ),
                      ExactOverviewCard(
                        icon: Icons.account_balance_wallet_rounded,
                        iconBg: AppColors.accentSoft,
                        iconColor: AppColors.warning,
                        title: 'Total Savings',
                        value: 'UGX ${credits.toStringAsFixed(0)}',
                        caption: 'All Time',
                        lineColor: AppColors.warning,
                      ),
                      ExactOverviewCard(
                        icon: Icons.swap_vert_rounded,
                        iconBg: AppColors.blueSoft,
                        iconColor: AppColors.blue,
                        title: 'Transactions',
                        value: '${data.entries.length}',
                        caption: 'Wallet entries',
                        lineColor: AppColors.blue,
                      ),
                      ExactOverviewCard(
                        icon: Icons.calendar_month_rounded,
                        iconBg: AppColors.purpleSoft,
                        iconColor: AppColors.purple,
                        title: 'Member Since',
                        value: _date(wallet?.createdAt),
                        caption: 'Account created',
                        lineColor: AppColors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ExactRecentActivity(entries: data.entries),
                  const SizedBox(height: AppSpacing.lg),
                  ExactGroupCard(
                    groupName: groupName,
                    community: community,
                    leaderName: leader,
                    memberCount: memberCount,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const ExactPromoCard(),
                  const SizedBox(height: AppSpacing.lg),
                  const ExactQuickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewHeading extends StatelessWidget {
  const _OverviewHeading();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppTypography.h2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              SizedBox(width: 6),
              Text(
                'This Month',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppTypography.tiny,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 17,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
