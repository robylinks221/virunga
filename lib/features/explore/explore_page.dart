import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../community/community_page.dart';
import '../marketplace/public_marketplace_page.dart';
import 'explore_section_pages.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$title will connect to its full page next.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _ExploreItem(
        icon: Icons.public_outlined,
        title: 'Countries',
        subtitle: 'Uganda • Rwanda • DR Congo',
        image: 'assets/images/onboarding_landscape.jpg',
        onTap: () => _open(context, const CountriesPage()),
      ),
      _ExploreItem(
        icon: Icons.landscape_outlined,
        title: 'Destinations',
        subtitle: 'Parks, forests & landscapes',
        image: 'assets/images/onboarding_wildlife.jpg',
        onTap: () => _open(context, const DestinationsPage()),
      ),
      _ExploreItem(
        icon: Icons.backpack_outlined,
        title: 'Porters',
        subtitle: 'People supporting every journey',
        image: 'assets/images/onboarding_community.jpg',
        onTap: () => _open(context, const PortersPage()),
      ),
      _ExploreItem(
        icon: Icons.shopping_basket_outlined,
        title: 'Crafts',
        subtitle: 'Authentic crafts & artisans',
        image: 'assets/images/crafts_beaded_sandals.jpg',
        onTap: () => _open(context, const PublicMarketplacePage()),
      ),
      _ExploreItem(
        icon: Icons.diversity_3_outlined,
        title: 'Community',
        subtitle: 'Culture, people & heritage',
        image: 'assets/images/onboarding_community.jpg',
        onTap: () => _open(context, const CommunityPage()),
      ),
      _ExploreItem(
        icon: Icons.eco_outlined,
        title: 'Conservation',
        subtitle: 'Wildlife, forests & habitats',
        image: 'assets/images/onboarding_wildlife.jpg',
        onTap: () => _open(context, const ConservationPage()),
      ),
      _ExploreItem(
        icon: Icons.shield_outlined,
        title: 'Rangers',
        subtitle: 'Protecting Greater Virunga',
        image: 'assets/images/onboarding_landscape.jpg',
        onTap: () => _open(context, const RangersPage()),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXPLORE GREATER VIRUNGA',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Discover the region.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nature, culture, people and conservation across one connected landscape.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.72),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      onTap: () => _comingSoon(context, 'Search'),
                      decoration: InputDecoration(
                        hintText: 'Where do you want to explore?',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _RegionFeature(
                  onTap: () => _open(context, const CountriesPage()),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 27, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DISCOVER',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Explore Greater Virunga',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ExploreCard(item: items[index]),
                  childCount: items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionFeature extends StatelessWidget {
  const _RegionFeature({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 190,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/onboarding_landscape.jpg',
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x12000000),
                    Color(0xD9000000),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.92),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.public_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'ONE REGION • THREE COUNTRIES',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Nature. People. Place.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Uganda • Rwanda • DR Congo',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.76),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.item});

  final _ExploreItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.image, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0x8A000000),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    top: 11,
                    child: Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.94),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 10, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 9.5,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    color: AppColors.primary,
                    size: 17,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreItem {
  const _ExploreItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;
}
