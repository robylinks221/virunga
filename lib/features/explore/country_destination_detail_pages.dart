import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../marketplace/public_marketplace_page.dart';

class CountryDetailPage extends StatelessWidget {
  const CountryDetailPage({super.key, required this.country});
  final String country;

  List<String> get destinations {
    switch (country) {
      case 'Uganda':
        return ['Bwindi Impenetrable National Park', 'Mgahinga Gorilla National Park', 'Queen Elizabeth National Park'];
      case 'Rwanda':
        return ['Volcanoes National Park'];
      default:
        return ['Virunga National Park', 'Kahuzi-Biega National Park'];
    }
  }

  @override
  Widget build(BuildContext context) => _CountryPage(
    country: country,
    destinations: destinations,
    image: _countryImage(country),
  );
}

class _CountryPage extends StatelessWidget {
  const _CountryPage({
    required this.country,
    required this.destinations,
    required this.image,
  });

  final String country;
  final List<String> destinations;
  final String image;

  String get tagline {
    switch (country) {
      case 'Uganda':
        return 'Mountain forests, protected landscapes and living craft traditions.';
      case 'Rwanda':
        return 'Volcanic landscapes, mountain forests and refined craft traditions.';
      default:
        return 'Virunga forests, dramatic landscapes and enduring craft traditions.';
    }
  }

  String get overview {
    switch (country) {
      case 'Uganda':
        return 'Explore Uganda through its Greater Virunga landscapes, protected areas and the craft traditions of communities connected to the region.';
      case 'Rwanda':
        return 'Explore Rwanda through its Greater Virunga landscapes, protected areas and the craft traditions of communities connected to the region.';
      default:
        return 'Explore DR Congo through its Greater Virunga landscapes, protected areas and the craft traditions of communities connected to the region.';
    }
  }

  List<(String, IconData)> get craftCategories => const [
    ('Baskets & Weaving', Icons.shopping_basket_outlined),
    ('Wood Carvings', Icons.handyman_outlined),
    ('Beadwork', Icons.diamond_outlined),
    ('Textiles', Icons.checkroom_outlined),
    ('Pottery', Icons.local_cafe_outlined),
    ('Artworks', Icons.palette_outlined),
  ];

  List<_CountryCraft> get crafts {
    switch (country) {
      case 'Uganda':
        return const [
          _CountryCraft('Virunga Beaded Sandals', 'Beadwork', 'assets/images/crafts_beaded_sandals.jpg'),
          _CountryCraft('Heritage Textile', 'Textiles', 'assets/images/onboarding_community.jpg'),
          _CountryCraft('Handmade Basket', 'Baskets & Weaving', 'assets/images/onboarding_landscape.jpg'),
        ];
      case 'Rwanda':
        return const [
          _CountryCraft('Handwoven Basket', 'Baskets & Weaving', 'assets/images/onboarding_community.jpg'),
          _CountryCraft('Traditional Beadwork', 'Beadwork', 'assets/images/crafts_beaded_sandals.jpg'),
          _CountryCraft('Heritage Textile', 'Textiles', 'assets/images/onboarding_landscape.jpg'),
        ];
      default:
        return const [
          _CountryCraft('Carved Wildlife Art', 'Wood Carvings', 'assets/images/onboarding_wildlife.jpg'),
          _CountryCraft('Virunga Beadwork', 'Beadwork', 'assets/images/crafts_beaded_sandals.jpg'),
          _CountryCraft('Community Weaving', 'Baskets & Weaving', 'assets/images/onboarding_community.jpg'),
        ];
    }
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 285,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(image, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x12000000), Color(0xE8000000)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Text(
                          'GREATER VIRUNGA',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          country,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            height: 1.05,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tagline,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.78),
                            fontSize: 11.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              child: _CountrySectionIntro(
                eyebrow: 'OVERVIEW',
                title: 'A closer look at $country',
                body: overview,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              child: _CountrySectionIntro(
                eyebrow: 'DESTINATIONS',
                title: 'Greater Virunga destinations',
                body: 'Protected landscapes in $country that belong to the region covered by Virunga.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 222,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: destinations.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final name = destinations[index];
                  return _CountryDestinationCard(
                    name: name,
                    country: country,
                    image: _destinationImage(name),
                    onTap: () => _open(
                      context,
                      DestinationDetailPage(name: name, country: country),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 13),
              child: _CountrySectionIntro(
                eyebrow: 'CRAFT CATEGORIES',
                title: 'Craft traditions of $country',
                body: 'Browse locally made craft categories connected to communities in the Greater Virunga region.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _CountryCraftCategories(items: craftCategories),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _CountrySectionIntro(
                      eyebrow: 'FEATURED CRAFTS',
                      title: 'Made in $country',
                      body: 'A selection of crafts from local makers.',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _open(context, const PublicMarketplacePage()),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: crafts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _CountryCraftCard(
                  craft: crafts[index],
                  country: country,
                  onTap: () => _open(context, const PublicMarketplacePage()),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 38),
              child: InkWell(
                onTap: () => _open(context, const PublicMarketplacePage()),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 17, 16, 17),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPLORE THE MARKETPLACE',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Discover more local crafts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountrySectionIntro extends StatelessWidget {
  const _CountrySectionIntro({
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.25,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          height: 1.12,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        body,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11.5,
          height: 1.5,
        ),
      ),
    ],
  );
}

class _CountryDestinationCard extends StatelessWidget {
  const _CountryDestinationCard({
    required this.name,
    required this.country,
    required this.image,
    required this.onTap,
  });

  final String name;
  final String country;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 230,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x06000000), Color(0xE8000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    country.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          color: AppColors.primary,
                          size: 17,
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

class _CountryCraftCategories extends StatelessWidget {
  const _CountryCraftCategories({required this.items});
  final List<(String, IconData)> items;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 104,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 15),
      itemBuilder: (_, index) {
        final item = items[index];
        return SizedBox(
          width: 70,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Icon(item.$2, color: AppColors.primary, size: 23),
              ),
              const SizedBox(height: 7),
              Text(
                item.$1,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 8.5,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _CountryCraftCard extends StatelessWidget {
  const _CountryCraftCard({
    required this.craft,
    required this.country,
    required this.onTap,
  });

  final _CountryCraft craft;
  final String country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 172,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                craft.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    craft.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    craft.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    country,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
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
  );
}

class _CountryCraft {
  const _CountryCraft(this.name, this.category, this.image);
  final String name;
  final String category;
  final String image;
}

class DestinationDetailPage extends StatelessWidget {
  const DestinationDetailPage({
    super.key,
    required this.name,
    required this.country,
    this.authService,
  });

  final String name;
  final String country;
  final AuthService? authService;

  List<_CountryCraft> get crafts {
    switch (country) {
      case 'Uganda':
        return const [
          _CountryCraft('Handwoven Basket', 'Baskets & Weaving', 'assets/images/onboarding_community.jpg'),
          _CountryCraft('Virunga Beadwork', 'Beadwork', 'assets/images/crafts_beaded_sandals.jpg'),
          _CountryCraft('Heritage Textile', 'Textiles', 'assets/images/onboarding_landscape.jpg'),
        ];
      case 'Rwanda':
        return const [
          _CountryCraft('Handwoven Basket', 'Baskets & Weaving', 'assets/images/onboarding_community.jpg'),
          _CountryCraft('Traditional Beadwork', 'Beadwork', 'assets/images/crafts_beaded_sandals.jpg'),
          _CountryCraft('Heritage Textile', 'Textiles', 'assets/images/onboarding_landscape.jpg'),
        ];
      default:
        return const [
          _CountryCraft('Carved Wildlife Art', 'Wood Carvings', 'assets/images/onboarding_wildlife.jpg'),
          _CountryCraft('Virunga Beadwork', 'Beadwork', 'assets/images/crafts_beaded_sandals.jpg'),
          _CountryCraft('Community Weaving', 'Baskets & Weaving', 'assets/images/onboarding_community.jpg'),
        ];
    }
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(_destinationImage(name), fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x10000000), Color(0xED000000)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          country.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            height: 1.08,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A protected Greater Virunga landscape shaped by nature, communities and conservation.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.78),
                            fontSize: 11.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 27, 20, 0),
              child: _CountrySectionIntro(
                eyebrow: 'OVERVIEW',
                title: 'Discover $name',
                body: 'Explore the natural character, conservation importance and communities connected to this Greater Virunga destination.',
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 13),
              child: _CountrySectionIntro(
                eyebrow: 'PORTER GROUPS',
                title: 'Porter groups around this park',
                body: 'Explore porter groups connected to communities around $name. Each porter belongs to a group, and each group belongs to a community.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _PorterGroupCarousel(groups: _porterGroupsForPark(name)),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 13),
              child: _CountrySectionIntro(
                eyebrow: 'CRAFT CATEGORIES',
                title: 'Crafts connected to this destination',
                body: 'Browse locally made craft categories from communities around $name.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _craftCategories(
              onTap: () => _open(context, const PublicMarketplacePage()),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: _CountrySectionIntro(
                      eyebrow: 'FEATURED CRAFTS',
                      title: 'Made around this destination',
                      body: 'A selection of local craft products.',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _open(context, const PublicMarketplacePage()),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: crafts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _CountryCraftCard(
                  craft: crafts[index],
                  country: country,
                  onTap: () => _open(context, const PublicMarketplacePage()),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 38),
              child: InkWell(
                onTap: () => _open(context, const PublicMarketplacePage()),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 17, 16, 17),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SUPPORT LOCAL ARTISANS',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Discover more crafts from the region',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


const _porterAvatar = 'assets/images/onboarding_community.jpg';

List<_PorterGroup> _porterGroupsForPark(String park) {
  if (park.contains('Bwindi')) {
    return const [
      _PorterGroup('Buhoma Porter Group', 'Buhoma Community', 'Bwindi Impenetrable National Park'),
      _PorterGroup('Ruhija Porter Group', 'Ruhija Community', 'Bwindi Impenetrable National Park'),
      _PorterGroup('Rushaga Porter Group', 'Rushaga Community', 'Bwindi Impenetrable National Park'),
    ];
  }
  if (park.contains('Mgahinga')) {
    return const [
      _PorterGroup('Mgahinga Porter Group', 'Mgahinga Community', 'Mgahinga Gorilla National Park'),
    ];
  }
  if (park.contains('Volcanoes')) {
    return const [
      _PorterGroup('Volcanoes Porter Group', 'Volcanoes Community', 'Volcanoes National Park'),
    ];
  }
  if (park.contains('Virunga')) {
    return const [
      _PorterGroup('Virunga Porter Group', 'Virunga Community', 'Virunga National Park'),
    ];
  }
  if (park.contains('Kahuzi-Biega')) {
    return const [
      _PorterGroup('Kahuzi-Biega Porter Group', 'Kahuzi-Biega Community', 'Kahuzi-Biega National Park'),
    ];
  }
  return const [];
}

class _PorterGroup {
  const _PorterGroup(this.name, this.community, this.park);
  final String name;
  final String community;
  final String park;
}

class _PorterGroupCarousel extends StatelessWidget {
  const _PorterGroupCarousel({required this.groups});
  final List<_PorterGroup> groups;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 4),
        child: Text('Porter groups for this park will appear here.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
      );
    }

    return SizedBox(
      height: 238,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) => _PorterGroupCard(group: groups[index]),
      ),
    );
  }
}

class _PorterGroupCard extends StatelessWidget {
  const _PorterGroupCard({required this.group});
  final _PorterGroup group;

  @override
  Widget build(BuildContext context) => Container(
    width: 286,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(_porterAvatar, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('PORTER GROUP', style: TextStyle(color: AppColors.accent, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .9)),
                  const SizedBox(height: 4),
                  Text(group.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.15, fontWeight: FontWeight.w700)),
                ]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.groups_2_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 7),
                Expanded(child: Text(group.community, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 9),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.park_outlined, size: 16, color: AppColors.accent),
                const SizedBox(width: 7),
                Expanded(child: Text(group.park, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9.5, height: 1.35))),
              ]),
              const Spacer(),
              const Row(children: [
                Text('View group', style: TextStyle(color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.w700)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 15),
              ]),
            ]),
          ),
        ),
      ],
    ),
  );
}

String _countryImage(String country) {
  switch (country) {
    case 'Uganda':
      return 'assets/images/onboarding_landscape.jpg';
    case 'Rwanda':
      return 'assets/images/onboarding_wildlife.jpg';
    default:
      return 'assets/images/onboarding_community.jpg';
  }
}

String _destinationImage(String name) {
  if (name.contains('Bwindi') || name.contains('Virunga')) {
    return 'assets/images/onboarding_wildlife.jpg';
  }
  if (name.contains('Mgahinga') || name.contains('Volcanoes')) {
    return 'assets/images/onboarding_landscape.jpg';
  }
  return 'assets/images/onboarding_community.jpg';
}

Widget _photoHero(String image, IconData icon, String eyebrow, String title) => Container(
  height: 235,
  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
  child: Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(image, fit: BoxFit.cover),
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x08000000), Color(0xE0000000)],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.94), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primary, size: 21),
            ),
            const Spacer(),
            Text(eyebrow, style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 21, height: 1.12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    ],
  ),
);

PreferredSizeWidget _appBar() => AppBar(
  backgroundColor: AppColors.primary,
  surfaceTintColor: Colors.transparent,
  foregroundColor: Colors.white,
  elevation: 0,
);

Widget _eyebrow(String value) => Text(
  value,
  style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1),
);

Widget _title(String value) => Text(
  value,
  style: const TextStyle(color: AppColors.textPrimary, fontSize: 27, fontWeight: FontWeight.w700, height: 1.15),
);

Widget _body(String value) => Text(
  value,
  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.55),
);

Widget _sectionTitle(String value) => Text(
  value,
  style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1),
);

Widget _oldDarkHero(IconData icon, String eyebrow, String title) => Container(
  height: 155,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(22)),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.accent, size: 31),
      const Spacer(),
      Text(eyebrow, style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: .8)),
      const SizedBox(height: 5),
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
    ],
  ),
);

Widget _roundIcon(IconData icon) => Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(color: Colors.white.withOpacity(.12), shape: BoxShape.circle),
  child: Icon(icon, color: Colors.white, size: 20),
);

Widget _listCard({required IconData icon, required String title, required String subtitle, VoidCallback? onTap}) => InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(16),
  child: Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 20),
      ],
    ),
  ),
);

Widget _simpleGrid(List<(String, IconData)> items) => GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: items.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 1.35,
  ),
  itemBuilder: (context, index) {
    final item = items[index];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.$2, color: AppColors.primary, size: 22),
          const Spacer(),
          Text(item.$1, style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  },
);

Widget _horizontalInfoCards(List<(String, IconData)> items) => SizedBox(
  height: 125,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: items.length,
    separatorBuilder: (_, __) => const SizedBox(width: 10),
    itemBuilder: (context, index) {
      final item = items[index];
      return Container(
        width: 148,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.$2, color: AppColors.accent, size: 25),
            const Spacer(),
            Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.25)),
          ],
        ),
      );
    },
  ),
);

Widget _craftCategories({VoidCallback? onTap}) {
  const items = [
    ('Baskets & Weaving', Icons.shopping_basket_outlined),
    ('Wood Carvings', Icons.handyman_outlined),
    ('Beadwork & Jewellery', Icons.diamond_outlined),
    ('Textiles & Clothing', Icons.checkroom_outlined),
    ('Pottery & Ceramics', Icons.local_cafe_outlined),
    ('Traditional Instruments', Icons.music_note_outlined),
    ('Paintings & Artworks', Icons.palette_outlined),
    ('Natural & Eco Crafts', Icons.eco_outlined),
  ];
  return SizedBox(
    height: 112,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
          width: 76,
          child: Column(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
                child: Icon(item.$2, color: AppColors.primary, size: 25),
              ),
              const SizedBox(height: 7),
              Text(item.$1, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 8.5, fontWeight: FontWeight.w500, height: 1.2)),
            ],
          ),
          ),
        );
      },
    ),
  );
}

Widget _statCard(IconData icon, String label, String value) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.cardBorder)),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.primary, size: 23),
      const SizedBox(height: 18),
      Text(value, style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: .7)),
    ],
  ),
);
