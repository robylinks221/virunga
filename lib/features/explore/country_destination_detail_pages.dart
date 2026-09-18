import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../marketplace/marketplace_page.dart';

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
  );
}

class _CountryPage extends StatelessWidget {
  const _CountryPage({required this.country, required this.destinations});
  final String country;
  final List<String> destinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          _eyebrow('GREATER VIRUNGA • ' + country.toUpperCase()),
          const SizedBox(height: 7),
          _title(country),
          const SizedBox(height: 8),
          _body('Explore protected landscapes, nature, community, culture and crafts.'),
          const SizedBox(height: 22),
          _darkHero(Icons.public_outlined, 'THREE COUNTRIES • ONE REGION', country),
          const SizedBox(height: 27),
          _sectionTitle('DESTINATIONS'),
          const SizedBox(height: 11),
          ...destinations.map((name) => _listCard(
            icon: Icons.landscape_outlined,
            title: name,
            subtitle: 'Protected landscape • ' + country,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => DestinationDetailPage(name: name, country: country)),
            ),
          )),
          const SizedBox(height: 18),
          _sectionTitle('DISCOVER'),
          const SizedBox(height: 11),
          _simpleGrid(const [
            ('Wildlife & Nature', Icons.pets_outlined),
            ('Community & Culture', Icons.diversity_3_outlined),
            ('Craft & Artisans', Icons.shopping_basket_outlined),
            ('Porters', Icons.backpack_outlined),
            ('Conservation', Icons.eco_outlined),
          ]),
        ],
      ),
    );
  }
}

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

          // Photo-ready premium hero. A verified/local destination image can replace
          // this colour surface later without changing the layout.
          Container(
            height: 235,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _roundIcon(Icons.landscape_outlined),
                    const Spacer(),
                    _roundIcon(Icons.favorite_border_rounded),
                  ],
                ),
                const Spacer(),
                const Text(
                  'PROTECTED LANDSCAPE',
                  style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
                const SizedBox(height: 7),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700, height: 1.12),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.accent, size: 15),
                    const SizedBox(width: 5),
                    Text(country, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
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
            onTap: authService == null ? null : () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MarketplacePage(authService: authService!)),
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

PreferredSizeWidget _appBar() => AppBar(
  backgroundColor: AppColors.background,
  surfaceTintColor: Colors.transparent,
  foregroundColor: AppColors.primary,
  elevation: 0,
);

Widget _eyebrow(String value) => Text(
  value,
  style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.1),
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

Widget _darkHero(IconData icon, String eyebrow, String title) => Container(
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
