import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';

import '../community/community_page.dart';
import '../explore/explore_page.dart';
import '../explore/explore_section_pages.dart';
import '../explore/virunga_search_page.dart';
import '../dashboard/nav_pages/account_profile_page.dart';
import '../explore/country_destination_detail_pages.dart' as connected;
import '../marketplace/public_marketplace_page.dart' as market;

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({
    super.key,
    required this.authService,
    this.showBottomNavigation = true,
  });

  final AuthService authService;
  final bool showBottomNavigation;

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  // Home layout is intentionally unchanged; these aliases keep the approved
  // design while using the same Virunga brand colours as the rest of the app.
  static const green = AppColors.primary;
  static const deepGreen = AppColors.primary;
  static const ink = Color(0xFF14231D);
  static const muted = Color(0xFF6F7A75);
  static const background = Color(0xFFF5F1E8);
  static const softGreen = Colors.white;
  static const border = Color(0xFFE5EAE7);
  static const gold = AppColors.accent;

  String? _firstName;
  bool _authenticated = false;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      if (!await widget.authService.restoreSession()) return;
      final response = await widget.authService.authenticatedGet(ApiConfig.me);
      if (response.statusCode < 200 || response.statusCode >= 300) return;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return;
      final data = Map<String, dynamic>.from(decoded);

      String? value(dynamic v) {
        final s = v?.toString().trim();
        return (s == null || s.isEmpty || s == 'null') ? null : s;
      }

      String? name =
          value(data['first_name']) ??
          value(data['firstname']) ??
          value(data['given_name']) ??
          value(data['name']) ??
          value(data['full_name']);

      final user = data['user'];
      if (name == null && user is Map) {
        final u = Map<String, dynamic>.from(user);
        name =
            value(u['first_name']) ??
            value(u['firstname']) ??
            value(u['given_name']) ??
            value(u['name']) ??
            value(u['full_name']);
      }

      if (!mounted) return;
      setState(() {
        _authenticated = true;
        _firstName = name?.split(RegExp(r'\s+')).first;
      });
    } catch (_) {}
  }

  void _message(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$label is being connected to the Virunga platform.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        ),
      );
  }

  void _login() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoginPage(authService: widget.authService),
      ),
    );
  }

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _openMarketplace() {
    _open(const market.PublicMarketplacePage());
  }

  void _nav(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        return;
      case 1:
        _open(ExplorePage(authService: widget.authService));
        break;
      case 2:
        _open(const CommunityPage());
        break;
      case 3:
        _openMarketplace();
        break;
      case 4:
        if (_authenticated) {
          _open(AccountProfilePage(authService: widget.authService, title: 'Account'));
        } else {
          _login();
        }
        break;
    }

    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) setState(() => _navIndex = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final greeting =
        _firstName == null ? 'Welcome, Explorer' : 'Hello, $_firstName';

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _Header(
                greeting: greeting,
                authenticated: _authenticated,
                onNotifications: () => _message('Notifications'),
                onProfile: _authenticated
                    ? () => _open(AccountProfilePage(authService: widget.authService, title: 'Account'))
                    : _login,
              ),
            ),
            SliverToBoxAdapter(
              child: _Search(
                onSearch: () => _open(const VirungaSearchPage()),
                onFilter: () => _open(const VirungaSearchPage()),
              ),
            ),
            SliverToBoxAdapter(
              child: _TitleRow(
                title: 'Tourism Services',
                onViewAll: () => _open(ExplorePage(authService: widget.authService)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 206,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _Service(
                      image: 'assets/images/onboarding_landscape.jpg',
                      icon: Icons.luggage_outlined,
                      title: 'Porters',
                      subtitle: 'Support local communities',
                      onTap: () => _open(const PortersPage()),
                    ),
                    _Service(
                      image: 'assets/images/onboarding_community.jpg',
                      icon: Icons.diversity_3_outlined,
                      title: 'Community & Culture',
                      subtitle: 'People. Heritage. Living culture.',
                      onTap: () => _open(const CommunityPage()),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
                child: _CraftFeatureCard(
                  image: 'assets/images/crafts_beaded_sandals.jpg',
                  onTap: _openMarketplace,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _TitleRow(
                title: 'Crafts from the Community',
                onViewAll: _openMarketplace,
              ),
            ),
            SliverToBoxAdapter(
              child: _HomeCraftCarousel(onViewAll: _openMarketplace),
            ),
            SliverToBoxAdapter(
              child: _TitleRow(
                title: 'Explore by Country',
                onViewAll: () => _open(const CountriesPage()),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 248,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _Country(
                      image: 'assets/images/onboarding_landscape.jpg',
                      title: 'Uganda',
                      subtitle: 'The Pearl of Africa',
                      onTap: () => _open(const connected.CountryDetailPage(country: 'Uganda')),
                    ),
                    _Country(
                      image: 'assets/images/onboarding_wildlife.jpg',
                      title: 'Rwanda',
                      subtitle: 'Land of a Thousand Hills',
                      onTap: () => _open(const connected.CountryDetailPage(country: 'Rwanda')),
                    ),
                    _Country(
                      image: 'assets/images/onboarding_community.jpg',
                      title: 'DR Congo',
                      subtitle: 'A Land of Extraordinary Beauty',
                      onTap: () => _open(const connected.CountryDetailPage(country: 'DR Congo')),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _TitleRow(
                title: 'Top Destinations',
                onViewAll: () => _open(const DestinationsPage()),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 245,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
                  children: [
                    _Destination(
                      image: 'assets/images/onboarding_wildlife.jpg',
                      title: 'Bwindi\nImpenetrable NP',
                      onTap: () => _open(const connected.DestinationDetailPage(name: 'Bwindi Impenetrable National Park', country: 'Uganda')),
                    ),
                    _Destination(
                      image: 'assets/images/onboarding_landscape.jpg',
                      title: 'Volcanoes\nNational Park',
                      onTap: () => _open(const connected.DestinationDetailPage(name: 'Volcanoes National Park', country: 'Rwanda')),
                    ),
                    _Destination(
                      image: 'assets/images/onboarding_landscape.jpg',
                      title: 'Virunga\nNational Park',
                      onTap: () => _open(const connected.DestinationDetailPage(name: 'Virunga National Park', country: 'DR Congo')),
                    ),
                    _Destination(
                      image: 'assets/images/onboarding_community.jpg',
                      title: 'Queen Elizabeth\nNational Park',
                      onTap: () => _open(const connected.DestinationDetailPage(name: 'Queen Elizabeth National Park', country: 'Uganda')),
                    ),
                    _Destination(
                      image: 'assets/images/onboarding_wildlife.jpg',
                      title: 'Kahuzi-Biega\nNational Park',
                      onTap: () => _open(const connected.DestinationDetailPage(name: 'Kahuzi-Biega National Park', country: 'DR Congo')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNavigation
          ? _BottomNav(
              index: _navIndex,
              onTap: _nav,
            )
          : null,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.authenticated,
    required this.onNotifications,
    required this.onProfile,
  });

  final String greeting;
  final bool authenticated;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _GuestHomePageState.deepGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.landscape_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _GuestHomePageState.deepGreen,
                    fontSize: 18,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Together for a Wilder Tomorrow',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _GuestHomePageState.muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _CircleAction(
            icon: Icons.notifications_none_rounded,
            badge: authenticated ? '3' : null,
            onTap: onNotifications,
          ),
          const SizedBox(width: 9),
          _CircleAction(
            icon: authenticated
                ? Icons.person_rounded
                : Icons.person_outline_rounded,
            onTap: onProfile,
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(17),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                border: Border.all(color: _GuestHomePageState.border),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                icon,
                color: _GuestHomePageState.deepGreen,
                size: 23,
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            right: -3,
            top: -4,
            child: Container(
              height: 20,
              constraints: const BoxConstraints(minWidth: 20),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE84040),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Search extends StatelessWidget {
  const _Search({required this.onSearch, required this.onFilter});

  final VoidCallback onSearch;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(20, 2, 20, 16),
      padding: const EdgeInsets.fromLTRB(16, 5, 5, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _GuestHomePageState.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: _GuestHomePageState.ink,
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: onSearch,
              child: const Text(
                'Where are you going?',
                style: TextStyle(
                  color: Color(0xFF87908C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onFilter,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _GuestHomePageState.deepGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 302,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _GuestHomePageState.deepGreen,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding_wildlife.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 285,
            child: Container(
              color: const Color(0xD9002E21),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PEOPLE  •  NATURE  •  BRIGHTER TOMORROWS',
                  style: TextStyle(
                    color: Color(0xFFE4EEE9),
                    fontSize: 9,
                    letterSpacing: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Travel with Purpose.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Protect What Matters.',
                  style: TextStyle(
                    color: _GuestHomePageState.gold,
                    fontSize: 28,
                    height: 1.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 13),
                const SizedBox(
                  width: 245,
                  child: Text(
                    'Discover extraordinary places, support local communities, and help conserve the unique beauty of the Greater Virunga.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 45,
                  child: FilledButton.icon(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: _GuestHomePageState.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0x88FFFFFF)),
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text(
                      'Start Exploring',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 19,
            bottom: 18,
            child: Row(
              children: [
                _HeroDot(active: true),
                _HeroDot(),
                _HeroDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDot extends StatelessWidget {
  const _HeroDot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 17 : 7,
      height: 7,
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white60,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 14, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _GuestHomePageState.ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -.35,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Container(
              height: 1,
              color: _GuestHomePageState.deepGreen,
            ),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: _GuestHomePageState.deepGreen,
              padding: const EdgeInsets.symmetric(horizontal: 3),
            ),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text(
              'View all',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Country extends StatefulWidget {
  const _Country({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_Country> createState() => _CountryState();
}

class _CountryState extends State<_Country> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 218,
      margin: const EdgeInsets.only(right: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: _GuestHomePageState.deepGreen,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0x28000000),
                      Color(0xD9000000),
                    ],
                    stops: [0.0, 0.42, 0.66, 1.0],
                  ),
                ),
              ),

              // Favourite remains the only top icon.
              Positioned(
                right: 14,
                top: 14,
                child: GestureDetector(
                  onTap: () => setState(() => _favorite = !_favorite),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      _favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _GuestHomePageState.deepGreen,
                      size: 19,
                    ),
                  ),
                ),
              ),

              // Clean country text: no rating and no location icon.
              Positioned(
                left: 16,
                right: 76,
                bottom: 17,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.1,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.north_east_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Service extends StatelessWidget {
  const _Service({
    required this.image,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String image;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 218,
      margin: const EdgeInsets.only(right: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _GuestHomePageState.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.none,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17),
                    ),
                    child: Image.asset(
                      image,
                      height: 112,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(66, 10, 12, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _GuestHomePageState.ink,
                                    fontSize: 13,
                                    height: 1.08,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _GuestHomePageState.muted,
                                    fontSize: 9.4,
                                    height: 1.18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: _GuestHomePageState.deepGreen,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 14,
                top: 91,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _GuestHomePageState.border,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: _GuestHomePageState.deepGreen,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CraftFeatureCard extends StatelessWidget {
  const _CraftFeatureCard({
    required this.image,
    required this.onTap,
  });

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(23),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 286,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xF0000000),
                      Color(0xC7000000),
                      Color(0x4D000000),
                      Color(0x00000000),
                    ],
                    stops: [0.0, 0.37, 0.67, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(21, 20, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 3,
                      decoration: BoxDecoration(
                        color: _GuestHomePageState.gold,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      'AFRICAN CRAFTS\nLOCAL ARTISANS\nREAL STORIES',
                      style: TextStyle(
                        color: Color(0xFFF0D49A),
                        fontSize: 8.3,
                        height: 1.38,
                        letterSpacing: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 205,
                      child: Text(
                        'Traditional Arts\nand Crafts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.02,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      width: 210,
                      child: Text(
                        'Unique. Authentic. Meaningful.\nSupport local artisans and take home a piece of Africa.',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFFF5F3EF),
                          fontSize: 10.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 42,
                      child: FilledButton.icon(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _GuestHomePageState.deepGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                        ),
                        label: const Text(
                          'Explore Crafts',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                right: 18,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 38,
                      child: Divider(
                        color: Color(0xFFF0D49A),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'MORE THAN CRAFTS\nA CULTURE LIVES ON',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7.2,
                        height: 1.4,
                        letterSpacing: 1.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _HomeCraftCarousel extends StatefulWidget {
  const _HomeCraftCarousel({required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  State<_HomeCraftCarousel> createState() => _HomeCraftCarouselState();
}

class _HomeCraftCarouselState extends State<_HomeCraftCarousel> {
  late final Future<List<market.CraftProduct>> _future = _load();

  Future<List<market.CraftProduct>> _load() async {
    final response = await http.get(Uri.parse('https://backend.redrocksafrica.com/api/web/crafts/all/'));
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('Crafts unavailable');
    final decoded = jsonDecode(response.body);
    if (decoded is! List) return const [];
    final crafts = decoded
        .whereType<Map>()
        .map((item) => market.CraftProduct.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    crafts.shuffle();
    return crafts.take(8).toList();
  }

  String _money(double value) {
    final raw = value.round().toString();
    final out = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) out.write(',');
      out.write(raw[i]);
    }
    return 'UGX $out';
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<market.CraftProduct>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(height: 225, child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
      }
      final crafts = snapshot.data ?? const <market.CraftProduct>[];
      if (crafts.isEmpty) return const SizedBox.shrink();
      return SizedBox(
        height: 232,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          itemCount: crafts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final craft = crafts[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => market.PublicCraftDetailPage(product: craft)),
                ),
                child: Container(
                  width: 178,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.cardBorder), borderRadius: BorderRadius.circular(19)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      height: 139,
                      width: double.infinity,
                      child: craft.image.isEmpty
                          ? const ColoredBox(color: Color(0xFFEAE7DE), child: Icon(Icons.image_outlined, color: AppColors.textMuted))
                          : Image.network(craft.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFFEAE7DE), child: Icon(Icons.broken_image_outlined, color: AppColors.textMuted))),
                    ),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        if (craft.category.isNotEmpty) Text(craft.category.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.accent, fontSize: 7.5, fontWeight: FontWeight.w800, letterSpacing: .6)),
                        const SizedBox(height: 3),
                        Text(craft.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primary, fontSize: 11.5, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text(_money(craft.price), style: const TextStyle(color: AppColors.textPrimary, fontSize: 10.5, fontWeight: FontWeight.w700)),
                      ]),
                    )),
                  ]),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class _Destination extends StatefulWidget {
  const _Destination({
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  State<_Destination> createState() => _DestinationState();
}

class _DestinationState extends State<_Destination> {
  bool _favorite = false;

  String get _country {
    final t = widget.title.toLowerCase();
    if (t.contains('volcanoes')) return 'Rwanda';
    if (t.contains('virunga') || t.contains('kahuzi')) return 'DR Congo';
    return 'Uganda';
  }

  String get _rating {
    final t = widget.title.toLowerCase();
    if (t.contains('bwindi')) return '4.9';
    if (t.contains('virunga')) return '4.8';
    if (t.contains('volcanoes')) return '4.8';
    if (t.contains('queen')) return '4.7';
    if (t.contains('kahuzi')) return '4.7';
    return '4.8';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      margin: const EdgeInsets.only(right: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _GuestHomePageState.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(widget.image, fit: BoxFit.cover),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => setState(() => _favorite = !_favorite),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            _favorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18,
                            color: _GuestHomePageState.deepGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _GuestHomePageState.ink,
                              fontSize: 12,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Icon(
                          Icons.star_rounded,
                          color: _GuestHomePageState.gold,
                          size: 15,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _rating,
                          style: const TextStyle(
                            color: _GuestHomePageState.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 9),
                      color: _GuestHomePageState.border,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: _GuestHomePageState.gold,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            _country,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _GuestHomePageState.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _GuestHomePageState.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _GuestHomePageState.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 24,
            offset: Offset(0, -7),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          height: 70,
          selectedIndex: index,
          onDestinationSelected: onTap,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: _GuestHomePageState.softGreen,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: 'Community',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Marketplace',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
