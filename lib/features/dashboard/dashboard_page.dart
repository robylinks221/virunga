import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';
import '../marketplace/marketplace_page.dart';
import '../marketplace/public_marketplace_page.dart';
import '../explore/explore_page.dart';
import '../community/community_page.dart';
import '../guest/guest_home_page.dart';
import 'dashboard_model.dart';
import 'dashboard_service.dart';
import 'nav_pages/account_profile_page.dart';
import 'nav_pages/nav_placeholder_page.dart';
import 'role_home/admin_dashboard_home.dart';
import 'role_home/leader_dashboard_home.dart';
import 'role_home/member_dashboard_home.dart';
import 'widgets/dashboard_bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardService _service;
  late Future<DashboardBundle> _future;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _service = DashboardService(authService: widget.authService);
    _future = _service.fetchBundle();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _service.fetchBundle();
      _selectedIndex = 0;
    });

    await _future;
  }

  Future<void> _logout() async {
    await widget.authService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(
          authService: widget.authService,
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<DashboardBundle>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _DashboardError(
              message:
                  snapshot.error?.toString() ?? 'Dashboard failed to load.',
              onRetry: _reload,
              onLogout: _logout,
            );
          }

          final data = snapshot.data!;
          final role = _normaliseScope(data.scope);
          final isCraftSeller = _isCraftSeller(data);

          final navigation = _navigationFor(
            role,
            isCraftSeller: isCraftSeller,
          );

          if (_selectedIndex >= navigation.items.length) {
            _selectedIndex = 0;
          }

          return Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pagesFor(
                    data: data,
                    role: role,
                    navigation: navigation,
                    isCraftSeller: isCraftSeller,
                  ),
                ),
              ),
              DashboardBottomNav(
                items: navigation.items,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _normaliseScope(String value) {
    final scope = value.trim().toLowerCase();

    if (scope == 'super_admin' ||
        scope == 'super-admin' ||
        scope == 'superadmin' ||
        scope == 'admin') {
      return 'super_admin';
    }

    if (scope == 'leader' ||
        scope == 'group_leader' ||
        scope == 'group-leader') {
      return 'leader';
    }

    return 'member';
  }

  /// A user's marketplace role belongs to /api/auth/me/, not the dashboard
  /// scope. The dashboard scope only tells us member/leader/admin.
  bool _isCraftSeller(DashboardBundle data) {
    final authoritativeRole = data.currentUser?.role.trim().toLowerCase();

    if (authoritativeRole != null && authoritativeRole.isNotEmpty) {
      return _matchesCraftSellerRole(authoritativeRole);
    }

    final dashboardRole = data.dashboard.stringValue([
      'role_name',
      'role',
      'group_role_name',
      'group_role',
    ]);

    if (dashboardRole == null) return false;

    return _matchesCraftSellerRole(dashboardRole.trim().toLowerCase());
  }

  bool _matchesCraftSellerRole(String role) {
    final normalised = role
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .trim();

    return normalised == 'craft_seller' ||
        normalised == 'craftseller' ||
        normalised == 'craft_vendor' ||
        normalised == 'artisan' ||
        normalised.contains('craft_seller') ||
        (normalised.contains('craft') &&
            (normalised.contains('seller') ||
                normalised.contains('vendor') ||
                normalised.contains('artisan')));
  }

  List<Widget> _pagesFor({
    required DashboardBundle data,
    required String role,
    required _RoleNavigation navigation,
    required bool isCraftSeller,
  }) {
    final home = switch (role) {
      'super_admin' => AdminDashboardHome(
          data: data,
          onRefresh: _reload,
        ),
      'leader' => LeaderDashboardHome(
          data: data,
          onRefresh: _reload,
        ),
      _ => GuestHomePage(
          authService: widget.authService,
          showBottomNavigation: false,
        ),
    };

    final pages = <Widget>[home];

    for (var i = 1; i < navigation.items.length; i++) {
      final item = navigation.items[i];

      if (item.label == 'Products' && isCraftSeller) {
        pages.add(
          MarketplacePage(
            authService: widget.authService,
          ),
        );
        continue;
      }

      if (item.label == 'Explore') {
        pages.add(ExplorePage(authService: widget.authService));
        continue;
      }

      if (item.label == 'Community') {
        pages.add(const CommunityPage());
        continue;
      }

      if (item.label == 'Marketplace') {
        pages.add(const PublicMarketplacePage());
        continue;
      }

      if (item.label == 'Profile' || item.label == 'More') {
        pages.add(
          AccountProfilePage(
            authService: widget.authService,
            title: item.label,
          ),
        );
        continue;
      }

      pages.add(
        NavPlaceholderPage(
          title: item.label,
          subtitle: _subtitleFor(
            label: item.label,
            role: role,
          ),
          icon: item.selectedIcon,
        ),
      );
    }

    return pages;
  }

  String _subtitleFor({
    required String label,
    required String role,
  }) {
    switch (label) {
      case 'Products':
        return 'Browse craft products available in the marketplace.';
      case 'Wallet':
        return 'Your wallet balance, transactions and account activity.';
      case 'Group':
        return 'Your Virunga group, community and leadership information.';
      case 'Members':
        return 'View and manage members in your assigned group.';
      case 'Users':
        return 'Manage users across the Virunga platform.';
      case 'Groups':
        return 'Manage groups, leaders and communities.';
      case 'More':
        return 'More platform administration tools and settings.';
      case 'Profile':
      default:
        return 'Your profile and account settings.';
    }
  }

  _RoleNavigation _navigationFor(
    String role, {
    required bool isCraftSeller,
  }) {
    if (role == 'super_admin') {
      return const _RoleNavigation(
        items: [
          DashboardNavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
          ),
          DashboardNavItem(
            label: 'Users',
            icon: Icons.people_outline_rounded,
            selectedIcon: Icons.people_alt_rounded,
          ),
          DashboardNavItem(
            label: 'Groups',
            icon: Icons.groups_outlined,
            selectedIcon: Icons.groups_rounded,
          ),
          DashboardNavItem(
            label: 'More',
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view_rounded,
          ),
        ],
      );
    }

    if (role == 'leader') {
      final items = <DashboardNavItem>[
        const DashboardNavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
        ),
        if (isCraftSeller)
          const DashboardNavItem(
            label: 'Products',
            icon: Icons.storefront_outlined,
            selectedIcon: Icons.storefront_rounded,
          ),
        const DashboardNavItem(
          label: 'Members',
          icon: Icons.people_outline_rounded,
          selectedIcon: Icons.people_alt_rounded,
        ),
        const DashboardNavItem(
          label: 'Wallet',
          icon: Icons.account_balance_wallet_outlined,
          selectedIcon: Icons.account_balance_wallet_rounded,
        ),
        const DashboardNavItem(
          label: 'Profile',
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
        ),
      ];

      return _RoleNavigation(items: items);
    }

    final items = <DashboardNavItem>[
      const DashboardNavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      const DashboardNavItem(
        label: 'Explore',
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore_rounded,
      ),
      const DashboardNavItem(
        label: 'Community',
        icon: Icons.diversity_3_outlined,
        selectedIcon: Icons.diversity_3_rounded,
      ),
      const DashboardNavItem(
        label: 'Marketplace',
        icon: Icons.shopping_bag_outlined,
        selectedIcon: Icons.shopping_bag_rounded,
      ),
      const DashboardNavItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
      ),
    ];

    return _RoleNavigation(items: items);
  }
}

class _RoleNavigation {
  const _RoleNavigation({
    required this.items,
  });

  final List<DashboardNavItem> items;
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({
    required this.message,
    required this.onRetry,
    required this.onLogout,
  });

  final String message;
  final Future<void> Function() onRetry;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 38,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Dashboard could not load',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppTypography.h2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppTypography.body,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: onRetry,
                  child: const Text('Try Again'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onLogout,
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
