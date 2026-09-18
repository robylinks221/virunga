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
  const _CountryPage({required this.country, required this.destinations, required this.image});
  final String country;
  final List<String> destinations;
  final String image;

  String get tagline {
    switch (country) {
      case 'Uganda':
        return 'Forests, savannah, mountains and living communities.';
      case 'Rwanda':
        return 'Volcanoes, mountain forests and a rich cultural landscape.';
      default:
        return 'Extraordinary forests, mountains and protected landscapes.';
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
            expandedHeight: 310,
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
                        colors: [Color(0x18000000), Color(0xF0000000)],
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
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          country,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 31,
                            height: 1.05,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 315,
                          child: Text(
                            tagline,
                            style: TextStyle(
                              color: Colors.white.withOpacity(.78),
                              fontSize: 12,
                              height: 1.45,
                            ),
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
            child: SizedBox(
              height: 76,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                scrollDirection: Axis.horizontal,
                children: [
                  _countryQuickLink(Icons.landscape_outlined, 'Destinations'),
                  _countryQuickLink(Icons.pets_outlined, 'Nature'),
                  _countryQuickLink(Icons.diversity_3_outlined, 'Culture'),
                  _countryQuickLink(Icons.shopping_basket_outlined, 'Crafts'),
                  _countryQuickLink(Icons.eco_outlined, 'Conservation'),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('ABOUT ' + country.toUpperCase()),
                  const SizedBox(height: 8),
                  _body('Discover the part of Greater Virunga found in $country, from protected landscapes and wildlife to communities, heritage and locally made crafts.'),
                  const SizedBox(height: 28),
                  _countryHeading('Top destinations', 'Explore protected places across $country'),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 225,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 16),
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
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _countryHeading('Discover $country', 'Nature, people and living heritage'),
                  const SizedBox(height: 13),
                  _countryFeatureGrid(context),
                  const SizedBox(height: 28),
                  _countryHeading('Things to do', 'Experiences are shown as destination information'),
                  const SizedBox(height: 13),
                  _countryActivityStrip(),
                  const SizedBox(height: 28),
                  _countryHeading('Crafts & artisans', 'Discover making traditions connected to $country'),
                  const SizedBox(height: 13),
                  _countryCraftBanner(
                    onTap: () => _open(context, const PublicMarketplacePage()),
                  ),
                  const SizedBox(height: 28),
                  _countryHeading('People of the landscape', 'Tourism support and conservation'),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(child: _countryPeopleCard(Icons.backpack_outlined, 'Porters', 'Supporting journeys')),
                      const SizedBox(width: 10),
                      Expanded(child: _countryPeopleCard(Icons.shield_outlined, 'Rangers', 'Protecting landscapes')),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _countryHeading('Plan your discovery', 'Useful country information'),
                  const SizedBox(height: 13),
                  _listCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Visitor Information',
                    subtitle: 'Practical country and destination information',
                  ),
                  _listCard(
                    icon: Icons.location_on_outlined,
                    title: 'Explore Locations',
                    subtitle: 'Discover protected places across $country',
                  ),
                  _listCard(
                    icon: Icons.eco_outlined,
                    title: 'Conservation',
                    subtitle: 'Learn about nature and landscape protection',
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryFeatureGrid(BuildContext context) {
    const items = [
      ('Wildlife & Nature', Icons.pets_outlined),
      ('Community & Culture', Icons.diversity_3_outlined),
      ('Conservation', Icons.eco_outlined),
      ('Porters', Icons.backpack_outlined),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$2, color: AppColors.primary, size: 23),
              const Spacer(),
              Text(
                item.$1,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _countryQuickLink(IconData icon, String label) => Container(
  margin: const EdgeInsets.only(right: 8),
  padding: const EdgeInsets.symmetric(horizontal: 13),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(99),
    border: Border.all(color: AppColors.cardBorder),
  ),
  child: Row(
    children: [
      Icon(icon, color: AppColors.primary, size: 17),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 10.5, fontWeight: FontWeight.w600)),
    ],
  ),
);

Widget _countryHeading(String title, String subtitle) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 21, fontWeight: FontWeight.w700)),
    const SizedBox(height: 4),
    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5, height: 1.35)),
  ],
);

class _CountryDestinationCard extends StatelessWidget {
  const _CountryDestinationCard({required this.name, required this.country, required this.image, required this.onTap});
  final String name;
  final String country;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x08000000), Color(0xE8000000)],
                ),
              ),
            ),
            Positioned(
              top: 13,
              right: 13,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_outward_rounded, color: AppColors.primary, size: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(country.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 8.5, fontWeight: FontWeight.w700, letterSpacing: .8)),
                  const SizedBox(height: 4),
                  Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.15, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _countryActivityStrip() {
  const items = [
    ('Wildlife Viewing', Icons.pets_outlined),
    ('Gorilla Trekking', Icons.forest_outlined),
    ('Birding', Icons.flutter_dash_outlined),
    ('Hiking', Icons.hiking_outlined),
  ];
  return SizedBox(
    height: 112,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          width: 125,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$2, color: AppColors.accent, size: 23),
              const Spacer(),
              Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    ),
  );
}

Widget _countryCraftBanner({required VoidCallback onTap}) => InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(20),
  child: Container(
    height: 155,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/crafts_beaded_sandals.jpg', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xE8000000), Color(0x18000000)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('LOCAL MAKING', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    SizedBox(height: 5),
                    Text('Crafts & artisan stories', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_outward_rounded, color: AppColors.primary, size: 18),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

Widget _countryPeopleCard(IconData icon, String title, String subtitle) => Container(
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: AppColors.cardBorder),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 3),
      Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9.5)),
    ],
  ),
);

class DestinationDetailPage extends StatelessWidget {
  const DestinationDetailPage({super.key, required this.name, required this.country, this.authService});
  final String name;
  final String country;
  final AuthService? authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 44),
        children: [
          _eyebrow(country.toUpperCase()),
          const SizedBox(height: 7),
          _title(name),
          const SizedBox(height: 9),
          _body('A protected Greater Virunga landscape shaped by wildlife, communities and conservation.'),
          const SizedBox(height: 22),

          _photoHero(
            _destinationImage(name),
            Icons.landscape_outlined,
            'PROTECTED LANDSCAPE • ${country.toUpperCase()}',
            name,
          ),
          const SizedBox(height: 27),

          _sectionTitle('OVERVIEW'),
          const SizedBox(height: 9),
          _body('Discover the landscape, its natural character, conservation importance and the communities connected to it. Detailed verified destination content will connect here.'),
          const SizedBox(height: 25),

          _sectionTitle('THINGS TO DO'),
          const SizedBox(height: 5),
          const Text(
            'Informational activities only',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: 11),
          _horizontalInfoCards(const [
            ('Wildlife & Nature', Icons.pets_outlined),
            ('Forest & Trails', Icons.forest_outlined),
            ('Community Culture', Icons.diversity_3_outlined),
          ]),
          const SizedBox(height: 27),

          _sectionTitle('CRAFTS FROM THIS DESTINATION'),
          const SizedBox(height: 5),
          _body('Explore craft categories made and sold by artisans connected to this destination.'),
          const SizedBox(height: 14),
          _craftCategories(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PublicMarketplacePage()),
            ),
          ),
          const SizedBox(height: 27),

          _sectionTitle('LIVING HERITAGE'),
          const SizedBox(height: 5),
          _body('Traditional arts and cultural expressions connected to local communities.'),
          const SizedBox(height: 13),
          _horizontalInfoCards(const [
            ('Traditional Dance', Icons.groups_outlined),
            ('Music & Performance', Icons.music_note_outlined),
            ('Stories & Heritage', Icons.auto_stories_outlined),
          ]),
          const SizedBox(height: 27),

          _sectionTitle('DESTINATION WORKFORCE'),
          const SizedBox(height: 5),
          _body('Verified totals will appear when live destination data is connected.'),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(child: _statCard(Icons.backpack_outlined, 'PORTERS', '—')),
              const SizedBox(width: 10),
              Expanded(child: _statCard(Icons.shield_outlined, 'RANGERS', '—')),
            ],
          ),
          const SizedBox(height: 27),

          _sectionTitle('VISITOR INFORMATION'),
          const SizedBox(height: 11),
          _listCard(icon: Icons.info_outline_rounded, title: 'Practical Information', subtitle: 'Destination information and travel notes'),
          _listCard(icon: Icons.location_on_outlined, title: 'Location', subtitle: 'View where this destination is located'),
        ],
      ),
    );
  }
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
