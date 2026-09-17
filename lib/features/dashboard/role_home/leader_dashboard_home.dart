import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../dashboard_model.dart';
import '../widgets/exact_group_card.dart';
import '../widgets/exact_header.dart';
import '../widgets/exact_overview_card.dart';
import '../widgets/exact_promo_card.dart';
import '../widgets/exact_recent_activity.dart';
import '../widgets/exact_wallet_card.dart';

class LeaderDashboardHome extends StatelessWidget {
  const LeaderDashboardHome({
    super.key,
    required this.data,
    required this.onRefresh,
  });

  final DashboardBundle data;
  final Future<void> Function() onRefresh;

  String _date(DateTime? value) {
    if (value == null) return '--';

    final d = value.toLocal();

    return '${d.day}/${d.month}/${d.year}';
  }

  String _count(List<String> keys) {
    final value = data.dashboard.intValue(keys);

    return value?.toString() ?? '--';
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = data.dashboard;
    final wallet = data.wallet;

    final groupName =
        dashboard.stringValue(['group_name', 'group']) ?? 'My Group';

    final community =
        dashboard.stringValue(['community_name', 'community']) ??
            'Virunga Community';

    final memberCount =
        dashboard.intValue([
          'member_count',
          'members',
          'group_members',
          'total_members',
        ]) ??
            0;

    final memberId = wallet?.userId == null
        ? dashboard.stringValue(['member_id', 'user_id']) ?? '--'
        : 'VRG-LDR-${wallet!.userId.toString().padLeft(5, '0')}';

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ExactDashboardHeader(
              name: data.profile.fullName,
              roleLabel: 'Virunga Group Leader',
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
              16,
              22,
              16,
              36,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const _LeaderSectionHeading(
                    title: 'Leader Overview',
                    subtitle: 'Your group at a glance',
                  ),
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
                        icon: Icons.groups_2_rounded,
                        iconBg: AppColors.mintSoft,
                        iconColor: AppColors.success,
                        title: 'Group Members',
                        value: '$memberCount',
                        caption: groupName,
                        lineColor: AppColors.success,
                      ),
                      ExactOverviewCard(
                        icon: Icons.account_balance_wallet_rounded,
                        iconBg: AppColors.accentSoft,
                        iconColor: AppColors.warning,
                        title: 'Wallet Balance',
                        value:
                            'UGX ${(wallet?.balance ?? 0).toStringAsFixed(0)}',
                        caption: 'Leader wallet',
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
                        icon: Icons.public_rounded,
                        iconBg: AppColors.purpleSoft,
                        iconColor: AppColors.purple,
                        title: 'Community',
                        value: community,
                        caption: 'Assigned community',
                        lineColor: AppColors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _LeaderManagementCard(
                    groupName: groupName,
                    community: community,
                    memberCount: memberCount,
                    activeMembers: _count([
                      'active_members',
                      'active_member_count',
                    ]),
                    pendingMembers: _count([
                      'pending_members',
                      'pending_member_count',
                    ]),
                  ),
                  const SizedBox(height: 22),
                  ExactRecentActivity(
                    entries: data.entries,
                  ),
                  const SizedBox(height: 22),
                  ExactGroupCard(
                    groupName: groupName,
                    community: community,
                    leaderName: data.profile.fullName,
                    memberCount: memberCount,
                  ),
                  const SizedBox(height: 22),
                  const ExactPromoCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderSectionHeading extends StatelessWidget {
  const _LeaderSectionHeading({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppTypography.h2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppTypography.small,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              AppRadii.pill,
            ),
            border: Border.all(
              color: AppColors.cardBorder,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.admin_panel_settings_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              SizedBox(width: 6),
              Text(
                'Leader',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppTypography.tiny,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderManagementCard extends StatelessWidget {
  const _LeaderManagementCard({
    required this.groupName,
    required this.community,
    required this.memberCount,
    required this.activeMembers,
    required this.pendingMembers,
  });

  final String groupName;
  final String community;
  final int memberCount;
  final String activeMembers;
  final String pendingMembers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: .05),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.mintSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.manage_accounts_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Management',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppTypography.h3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Your leadership workspace',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppTypography.small,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _LeaderRow(
            label: 'Group',
            value: groupName,
          ),
          const Divider(height: 24),
          _LeaderRow(
            label: 'Community',
            value: community,
          ),
          const Divider(height: 24),
          _LeaderRow(
            label: 'Total members',
            value: '$memberCount',
          ),
          if (activeMembers != '--') ...[
            const Divider(height: 24),
            _LeaderRow(
              label: 'Active members',
              value: activeMembers,
            ),
          ],
          if (pendingMembers != '--') ...[
            const Divider(height: 24),
            _LeaderRow(
              label: 'Pending members',
              value: pendingMembers,
            ),
          ],
        ],
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  const _LeaderRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.body,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
