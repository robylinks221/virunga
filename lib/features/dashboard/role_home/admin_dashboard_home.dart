import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../dashboard_model.dart';
import '../widgets/exact_header.dart';
import '../widgets/exact_overview_card.dart';
import '../widgets/exact_promo_card.dart';

class AdminDashboardHome extends StatelessWidget {
  const AdminDashboardHome({
    super.key,
    required this.data,
    required this.onRefresh,
  });

  final DashboardBundle data;
  final Future<void> Function() onRefresh;

  String _metric(List<String> keys) {
    final number = data.dashboard.numberValue(keys);

    if (number != null) {
      if (number % 1 == 0) {
        return number.toInt().toString();
      }

      return number.toStringAsFixed(2);
    }

    return data.dashboard.stringValue(keys) ?? '--';
  }

  @override
  Widget build(BuildContext context) {
    final totalUsers = _metric([
      'total_users',
      'users',
      'user_count',
    ]);

    final totalGroups = _metric([
      'total_groups',
      'groups',
      'group_count',
    ]);

    final totalLeaders = _metric([
      'total_leaders',
      'leaders',
      'leader_count',
    ]);

    final totalMembers = _metric([
      'total_members',
      'members',
      'member_count',
    ]);

    final totalCommunities = _metric([
      'total_communities',
      'communities',
      'community_count',
    ]);

    final activeUsers = _metric([
      'active_users',
      'active_user_count',
    ]);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ExactDashboardHeader(
              name: data.profile.fullName,
              roleLabel: 'Virunga Super Admin',
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
                  const _AdminHeroCard(),
                  const SizedBox(height: 22),
                  const _AdminSectionHeading(),
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
                        icon: Icons.people_alt_rounded,
                        iconBg: AppColors.blueSoft,
                        iconColor: AppColors.blue,
                        title: 'Total Users',
                        value: totalUsers,
                        caption: 'Platform users',
                        lineColor: AppColors.blue,
                      ),
                      ExactOverviewCard(
                        icon: Icons.groups_2_rounded,
                        iconBg: AppColors.mintSoft,
                        iconColor: AppColors.success,
                        title: 'Groups',
                        value: totalGroups,
                        caption: 'Registered groups',
                        lineColor: AppColors.success,
                      ),
                      ExactOverviewCard(
                        icon: Icons.workspace_premium_rounded,
                        iconBg: AppColors.accentSoft,
                        iconColor: AppColors.warning,
                        title: 'Leaders',
                        value: totalLeaders,
                        caption: 'Group leaders',
                        lineColor: AppColors.warning,
                      ),
                      ExactOverviewCard(
                        icon: Icons.person_rounded,
                        iconBg: AppColors.purpleSoft,
                        iconColor: AppColors.purple,
                        title: 'Members',
                        value: totalMembers,
                        caption: 'Community members',
                        lineColor: AppColors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _PlatformSummaryCard(
                    totalUsers: totalUsers,
                    activeUsers: activeUsers,
                    totalGroups: totalGroups,
                    totalCommunities: totalCommunities,
                  ),
                  const SizedBox(height: 22),
                  const _AdminToolsCard(),
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

class _AdminHeroCard extends StatelessWidget {
  const _AdminHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: AppColors.primaryDeep.withValues(alpha: .20),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: .45),
              ),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: AppColors.accentLight,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Platform Control Centre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTypography.h3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Platform-wide Virunga administration and monitoring.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppTypography.small,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSectionHeading extends StatelessWidget {
  const _AdminSectionHeading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Platform Overview',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.h2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(
          Icons.monitor_heart_outlined,
          color: AppColors.primary,
          size: 21,
        ),
      ],
    );
  }
}

class _PlatformSummaryCard extends StatelessWidget {
  const _PlatformSummaryCard({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalGroups,
    required this.totalCommunities,
  });

  final String totalUsers;
  final String activeUsers;
  final String totalGroups;
  final String totalCommunities;

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
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
              ),
              SizedBox(width: 9),
              Text(
                'Platform Summary',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppTypography.h3,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SummaryRow(
            label: 'Total users',
            value: totalUsers,
          ),
          if (activeUsers != '--') ...[
            const Divider(height: 24),
            _SummaryRow(
              label: 'Active users',
              value: activeUsers,
            ),
          ],
          const Divider(height: 24),
          _SummaryRow(
            label: 'Groups',
            value: totalGroups,
          ),
          if (totalCommunities != '--') ...[
            const Divider(height: 24),
            _SummaryRow(
              label: 'Communities',
              value: totalCommunities,
            ),
          ],
        ],
      ),
    );
  }
}

class _AdminToolsCard extends StatelessWidget {
  const _AdminToolsCard();

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Administration',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.h3,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your role gives access to platform management tools.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.small,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _AdminTool(
                  icon: Icons.people_alt_outlined,
                  label: 'Users',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AdminTool(
                  icon: Icons.groups_outlined,
                  label: 'Groups',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AdminTool(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminTool extends StatelessWidget {
  const _AdminTool({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 23,
          ),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.tiny,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
