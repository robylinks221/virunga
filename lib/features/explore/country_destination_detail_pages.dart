import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_theme.dart';
import '../auth/auth_service.dart';
import '../marketplace/public_marketplace_page.dart';

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

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
            child: _RealCraftCarousel(
              country: country,
              onTap: () => _open(context, const PublicMarketplacePage()),
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
            child: _ApiPorterGroups(park: name),
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
            child: _ApiCraftCategories(
              country: country,
              park: name,
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
            child: _RealCraftCarousel(
              country: country,
              park: name,
              onTap: () => _open(context, const PublicMarketplacePage()),
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


class _RealCraft {
  const _RealCraft(this.name, this.category, this.country, this.park, this.image, this.isActive);
  final String name, category, country, park, image;
  final bool isActive;

  factory _RealCraft.fromJson(Map<String, dynamic> json) {
    final category = json['category'] is Map ? Map<String, dynamic>.from(json['category']) : <String, dynamic>{};
    final images = json['images'] is Map ? Map<String, dynamic>.from(json['images']) : <String, dynamic>{};
    final seller = json['seller'] is Map ? Map<String, dynamic>.from(json['seller']) : <String, dynamic>{};
    final community = seller['community'] is Map ? Map<String, dynamic>.from(seller['community']) : <String, dynamic>{};
    final park = community['national_park'] is Map ? Map<String, dynamic>.from(community['national_park']) : <String, dynamic>{};
    final country = community['country'] is Map ? Map<String, dynamic>.from(community['country']) : <String, dynamic>{};
    var image = images['featured']?.toString() ?? '';
    if (image.startsWith('http://backend.redrocksafrica.com/')) image = image.replaceFirst('http://', 'https://');
    return _RealCraft(
      json['name']?.toString() ?? '',
      category['name']?.toString() ?? '',
      country['name']?.toString() ?? '',
      park['name']?.toString() ?? '',
      image,
      json['is_active'] == true,
    );
  }
}

class _ApiCraftCategories extends StatefulWidget {
  const _ApiCraftCategories({required this.country, required this.onTap, this.park});
  final String country;
  final String? park;
  final VoidCallback onTap;

  @override
  State<_ApiCraftCategories> createState() => _ApiCraftCategoriesState();
}

class _ApiCraftCategoriesState extends State<_ApiCraftCategories> {
  late final Future<List<String>> _future = _load();

  Future<List<String>> _load() async {
    final response = await http.get(Uri.parse('https://backend.redrocksafrica.com/api/web/crafts/all/'));
    if (response.statusCode < 200 || response.statusCode >= 300) return const [];
    final decoded = jsonDecode(response.body);
    if (decoded is! List) return const [];
    final categories = decoded.whereType<Map>().map((e) => _RealCraft.fromJson(Map<String, dynamic>.from(e))).where((craft) {
      final countryOk = craft.country.toLowerCase() == widget.country.toLowerCase();
      final parkOk = widget.park == null || craft.park.toLowerCase() == widget.park!.toLowerCase();
      return countryOk && parkOk && craft.category.trim().isNotEmpty;
    }).map((craft) => craft.category).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return categories;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<String>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(height: 86, child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
      }
      final categories = snapshot.data ?? const <String>[];
      if (categories.isEmpty) {
        return const Padding(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Text('No craft categories are currently connected to this location.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        );
      }
      return SizedBox(
        height: 104,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final category = categories[index];
            return InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(40),
              child: SizedBox(
                width: 82,
                child: Column(children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.handyman_outlined, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(height: 7),
                  Text(category, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 8.5, height: 1.15, fontWeight: FontWeight.w600)),
                ]),
              ),
            );
          },
        ),
      );
    },
  );
}

class _RealCraftCarousel extends StatefulWidget {
  const _RealCraftCarousel({required this.country, required this.onTap, this.park});
  final String country;
  final String? park;
  final VoidCallback onTap;

  @override
  State<_RealCraftCarousel> createState() => _RealCraftCarouselState();
}

class _RealCraftCarouselState extends State<_RealCraftCarousel> {
  late final Future<List<_RealCraft>> _future = _load();

  Future<List<_RealCraft>> _load() async {
    final response = await http.get(Uri.parse('https://backend.redrocksafrica.com/api/web/crafts/all/'));
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('Could not load crafts');
    final decoded = jsonDecode(response.body);
    if (decoded is! List) return const [];
    return decoded.whereType<Map>().map((e) => _RealCraft.fromJson(Map<String, dynamic>.from(e))).where((craft) {
      final countryOk = craft.country.toLowerCase() == widget.country.toLowerCase();
      final parkOk = widget.park == null || craft.park.toLowerCase() == widget.park!.toLowerCase();
      return countryOk && parkOk;
    }).take(3).toList();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<_RealCraft>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
      }
      final crafts = snapshot.data ?? const <_RealCraft>[];
      if (crafts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Text('No crafts are currently connected to this location.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        );
      }
      return SizedBox(
        height: 260,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: crafts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final craft = crafts[index];
            return InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 184,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.cardBorder)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: craft.image.isEmpty
                      ? Container(color: Colors.white, child: const Center(child: Icon(Icons.image_outlined, color: AppColors.primary)))
                      : Image.network(craft.image, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.white, child: const Center(child: Icon(Icons.broken_image_outlined, color: AppColors.primary)))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(craft.category.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.accent, fontSize: 8, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(craft.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ]),
              ),
            );
          },
        ),
      );
    },
  );
}

const _porterAvatar = 'assets/images/onboarding_community.jpg';
const _portersEndpoint = 'https://backend.redrocksafrica.com/api/web/porters/all/';

class _Porter {
  const _Porter({
    required this.id,
    required this.name,
    required this.isActive,
    required this.groupId,
    required this.group,
    required this.isGroupLeader,
    required this.communityId,
    required this.community,
    required this.park,
    required this.country,
    required this.countryCode,
    required this.joinedAt,
  });

  final int id, groupId, communityId;
  final String name, group, community, park, country, countryCode;
  final bool isActive, isGroupLeader;
  final DateTime? joinedAt;

  factory _Porter.fromJson(Map<String, dynamic> json) {
    final group = json['group'] is Map ? Map<String, dynamic>.from(json['group']) : <String, dynamic>{};
    final community = json['community'] is Map ? Map<String, dynamic>.from(json['community']) : <String, dynamic>{};
    final park = community['national_park'] is Map ? Map<String, dynamic>.from(community['national_park']) : <String, dynamic>{};
    final country = community['country'] is Map ? Map<String, dynamic>.from(community['country']) : <String, dynamic>{};
    return _Porter(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      isActive: json['is_active'] == true,
      groupId: int.tryParse(group['id']?.toString() ?? '') ?? 0,
      group: group['name']?.toString() ?? '',
      isGroupLeader: group['is_group_leader'] == true,
      communityId: int.tryParse(community['id']?.toString() ?? '') ?? 0,
      community: community['name']?.toString() ?? '',
      park: park['name']?.toString() ?? '',
      country: country['name']?.toString() ?? '',
      countryCode: country['code']?.toString() ?? '',
      joinedAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

Future<List<_Porter>> _loadPorters() async {
  final response = await http.get(Uri.parse(_portersEndpoint));
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Could not load porters');
  }
  final decoded = jsonDecode(response.body);
  if (decoded is! List) return const [];
  return decoded
      .whereType<Map>()
      .map((item) => _Porter.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

class _ApiPorterGroups extends StatefulWidget {
  const _ApiPorterGroups({required this.park});
  final String park;
  @override
  State<_ApiPorterGroups> createState() => _ApiPorterGroupsState();
}
class _ApiPorterGroupsState extends State<_ApiPorterGroups> {
  late final Future<List<_Porter>> _future = _loadPorters();
  @override
  Widget build(BuildContext context) => FutureBuilder<List<_Porter>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
      if (snapshot.hasError) return const Padding(padding: EdgeInsets.fromLTRB(20,0,20,8), child: Text('Porter information could not be loaded.', style: TextStyle(color: AppColors.textSecondary,fontSize:11.5)));
      final porters=(snapshot.data??const <_Porter>[]).where((x)=>x.park.toLowerCase()==widget.park.toLowerCase()).toList();
      if(porters.isEmpty) return const Padding(padding: EdgeInsets.fromLTRB(20,0,20,8),child:Text('No porters are currently connected to this park.',style:TextStyle(color:AppColors.textSecondary,fontSize:11.5)));
      return SizedBox(height:228,child:ListView.separated(padding:const EdgeInsets.fromLTRB(20,0,20,16),scrollDirection:Axis.horizontal,physics:const BouncingScrollPhysics(),itemCount:porters.length,separatorBuilder:(_,__)=>const SizedBox(width:12),itemBuilder:(context,index)=>_ParkPorterCard(porter:porters[index])));
    },
  );
}
class _ParkPorterCard extends StatelessWidget {
  const _ParkPorterCard({required this.porter});
  final _Porter porter;
  @override
  Widget build(BuildContext context) {
    final location=[porter.community,porter.park,porter.country].where((x)=>x.trim().isNotEmpty).join(', ');
    return InkWell(
      onTap:()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>PorterDetailPage(porter:porter))),
      borderRadius:BorderRadius.circular(22),
      child:Container(width:282,clipBehavior:Clip.antiAlias,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:AppColors.cardBorder),boxShadow:[BoxShadow(color:AppColors.primary.withOpacity(.05),blurRadius:18,offset:const Offset(0,8))]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Container(height:82,padding:const EdgeInsets.symmetric(horizontal:15),color:AppColors.primary,child:Row(children:[
          Container(width:58,height:58,padding:const EdgeInsets.all(2.5),decoration:const BoxDecoration(color:Colors.white,shape:BoxShape.circle),child:ClipOval(child:Image.asset(_porterAvatar,fit:BoxFit.cover))),
          const SizedBox(width:12),
          Expanded(child:Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Text('COMMUNITY PORTER',style:TextStyle(color:AppColors.accent,fontSize:7.5,fontWeight:FontWeight.w800,letterSpacing:.9)),
            const SizedBox(height:4),
            Text(porter.name,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(color:Colors.white,fontSize:15,height:1.15,fontWeight:FontWeight.w800)),
          ])),
        ])),
        Expanded(child:Padding(padding:const EdgeInsets.fromLTRB(15,13,15,13),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('LOCATION',style:TextStyle(color:AppColors.textMuted,fontSize:7.5,fontWeight:FontWeight.w800,letterSpacing:.8)),
          const SizedBox(height:4),
          Text(location,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(color:AppColors.textPrimary,fontSize:10.5,height:1.3,fontWeight:FontWeight.w600)),
          const SizedBox(height:10),
          const Text('JOINED',style:TextStyle(color:AppColors.textMuted,fontSize:7.5,fontWeight:FontWeight.w800,letterSpacing:.8)),
          const SizedBox(height:3),
          Text(_porterJoined(porter.joinedAt),style:const TextStyle(color:AppColors.primary,fontSize:10.5,fontWeight:FontWeight.w700)),
          const Spacer(),
          Row(children:[
            if(porter.isGroupLeader) Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration:BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(12)),child:const Text('GROUP LEADER',style:TextStyle(color:AppColors.primary,fontSize:7,fontWeight:FontWeight.w800))),
            const Spacer(),
            const Text('View Profile',style:TextStyle(color:AppColors.accent,fontSize:9.5,fontWeight:FontWeight.w800)),
            const SizedBox(width:4),const Icon(Icons.arrow_forward_rounded,color:AppColors.accent,size:15),
          ]),
        ]))),
      ])),
    );
  }
}
class PorterDetailPage extends StatelessWidget {
  const PorterDetailPage({super.key,required this.porter});
  final _Porter porter;
  @override
  Widget build(BuildContext context) {
    final location=[porter.community,porter.park,porter.country].where((x)=>x.trim().isNotEmpty).join(', ');
    return Scaffold(backgroundColor:AppColors.background,appBar:AppBar(backgroundColor:AppColors.primary,foregroundColor:Colors.white,surfaceTintColor:Colors.transparent,elevation:0,title:const Text('Porter Profile',style:TextStyle(fontSize:17,fontWeight:FontWeight.w800))),body:ListView(physics:const BouncingScrollPhysics(),padding:const EdgeInsets.fromLTRB(20,22,20,38),children:[
      Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:AppColors.primary,borderRadius:BorderRadius.circular(26)),child:Column(children:[
        Container(width:104,height:104,padding:const EdgeInsets.all(4),decoration:const BoxDecoration(color:Colors.white,shape:BoxShape.circle),child:ClipOval(child:Image.asset(_porterAvatar,fit:BoxFit.cover))),
        const SizedBox(height:14),Text(porter.name,textAlign:TextAlign.center,style:const TextStyle(color:Colors.white,fontSize:23,height:1.15,fontWeight:FontWeight.w800)),
        const SizedBox(height:6),Text(porter.isGroupLeader?'Community Porter · Group Leader':'Community Porter',style:const TextStyle(color:AppColors.accent,fontSize:10,fontWeight:FontWeight.w700)),
      ])),
      const SizedBox(height:22),
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:AppColors.cardBorder)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('PORTER DETAILS',style:TextStyle(color:AppColors.accent,fontSize:9,fontWeight:FontWeight.w800,letterSpacing:1)),
        const SizedBox(height:17),
        _porterDetailRow('Location',location),_porterDetailDivider(),
        _porterDetailRow('Community',porter.community),_porterDetailDivider(),
        _porterDetailRow('National Park',porter.park),_porterDetailDivider(),
        _porterDetailRow('Country',porter.country),_porterDetailDivider(),
        _porterDetailRow('Porter Group',porter.group),_porterDetailDivider(),
        _porterDetailRow('Joined',_porterJoined(porter.joinedAt)),_porterDetailDivider(),
        _porterDetailRow('Status',porter.isActive?'Active':'Inactive'),
      ])),
      const SizedBox(height:18),
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(22)),child:const Text('Porters support visitors and local communities around the Greater Virunga landscape. Profile information shown here comes from the porter directory.',style:TextStyle(color:AppColors.textPrimary,fontSize:11.5,height:1.5))),
      const SizedBox(height:18),
      SizedBox(
        height:54,
        child:ElevatedButton(
          onPressed:porter.isActive?()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>PorterBookingPage(porter:porter))):null,
          style:ElevatedButton.styleFrom(backgroundColor:AppColors.accent,foregroundColor:Colors.white,disabledBackgroundColor:AppColors.divider,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(28)),elevation:0),
          child:Text(porter.isActive?'BOOK THIS PORTER':'PORTER UNAVAILABLE',style:const TextStyle(fontSize:12,fontWeight:FontWeight.w800,letterSpacing:.4)),
        ),
      ),
    ]));
  }
}
class PorterBookingPage extends StatefulWidget {
  const PorterBookingPage({super.key,required this.porter});
  final _Porter porter;
  @override
  State<PorterBookingPage> createState()=>_PorterBookingPageState();
}
class _PorterBookingPageState extends State<PorterBookingPage> {
  final _formKey=GlobalKey<FormState>();
  final _name=TextEditingController();
  final _phone=TextEditingController();
  final _email=TextEditingController();
  final _notes=TextEditingController();
  DateTime? _date;
  int _visitors=1;

  @override
  void dispose(){_name.dispose();_phone.dispose();_email.dispose();_notes.dispose();super.dispose();}

  Future<void> _pickDate() async {
    final now=DateTime.now();
    final picked=await showDatePicker(context:context,initialDate:now.add(const Duration(days:1)),firstDate:now,lastDate:DateTime(now.year+2),helpText:'Select visit date');
    if(picked!=null)setState(()=>_date=picked);
  }

  void _continueRequest(){
    if(!_formKey.currentState!.validate())return;
    if(_date==null){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Please select your visit date.')));return;}
    Navigator.of(context).push(MaterialPageRoute(builder:(_)=>PorterBookingReviewPage(
      porter:widget.porter,
      visitorName:_name.text.trim(),
      phone:_phone.text.trim(),
      email:_email.text.trim(),
      notes:_notes.text.trim(),
      visitDate:_date!,
      visitors:_visitors,
    )));
  }

  @override
  Widget build(BuildContext context)=>Scaffold(
    backgroundColor:AppColors.background,
    appBar:AppBar(backgroundColor:AppColors.primary,foregroundColor:Colors.white,surfaceTintColor:Colors.transparent,elevation:0,title:const Text('Book a Porter',style:TextStyle(fontSize:17,fontWeight:FontWeight.w800))),
    body:Form(key:_formKey,child:ListView(physics:const BouncingScrollPhysics(),padding:const EdgeInsets.fromLTRB(20,22,20,38),children:[
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:AppColors.primary,borderRadius:BorderRadius.circular(24)),child:Row(children:[
        Container(width:68,height:68,padding:const EdgeInsets.all(3),decoration:const BoxDecoration(color:Colors.white,shape:BoxShape.circle),child:ClipOval(child:Image.asset(_porterAvatar,fit:BoxFit.cover))),
        const SizedBox(width:13),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('SELECTED PORTER',style:TextStyle(color:AppColors.accent,fontSize:8,fontWeight:FontWeight.w800,letterSpacing:.9)),
          const SizedBox(height:5),Text(widget.porter.name,style:const TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.w800)),
          const SizedBox(height:4),Text(widget.porter.park,style:TextStyle(color:Colors.white.withOpacity(.72),fontSize:10.5)),
        ])),
      ])),
      const SizedBox(height:24),
      const Text('YOUR VISIT',style:TextStyle(color:AppColors.accent,fontSize:9,fontWeight:FontWeight.w800,letterSpacing:1)),
      const SizedBox(height:6),
      const Text('Plan your porter request',style:TextStyle(color:AppColors.primary,fontSize:22,fontWeight:FontWeight.w800)),
      const SizedBox(height:15),
      _porterBookingField(label:'National Park',child:Text(widget.porter.park,style:const TextStyle(color:AppColors.textPrimary,fontSize:12,fontWeight:FontWeight.w600))),
      const SizedBox(height:12),
      InkWell(onTap:_pickDate,borderRadius:BorderRadius.circular(18),child:_porterBookingField(label:'Visit Date',child:Row(children:[
        Expanded(child:Text(_date==null?'Select your date':_bookingDate(_date!),style:TextStyle(color:_date==null?AppColors.textSecondary:AppColors.textPrimary,fontSize:12,fontWeight:FontWeight.w600))),
        const Icon(Icons.calendar_month_outlined,color:AppColors.accent,size:20),
      ]))),
      const SizedBox(height:12),
      _porterBookingField(label:'Number of Visitors',child:Row(children:[
        _qtyButton(Icons.remove,()=>setState(()=>_visitors=_visitors>1?_visitors-1:1)),
        Expanded(child:Text('$_visitors',textAlign:TextAlign.center,style:const TextStyle(color:AppColors.primary,fontSize:16,fontWeight:FontWeight.w800))),
        _qtyButton(Icons.add,()=>setState(()=>_visitors++)),
      ])),
      const SizedBox(height:24),
      const Text('CONTACT DETAILS',style:TextStyle(color:AppColors.accent,fontSize:9,fontWeight:FontWeight.w800,letterSpacing:1)),
      const SizedBox(height:12),
      _bookingTextField(_name,'Full Name',validator:(v)=>v==null||v.trim().isEmpty?'Enter your full name':null),
      const SizedBox(height:11),
      _bookingTextField(_phone,'Phone Number',keyboardType:TextInputType.phone,validator:(v)=>v==null||v.trim().isEmpty?'Enter your phone number':null),
      const SizedBox(height:11),
      _bookingTextField(_email,'Email Address',keyboardType:TextInputType.emailAddress),
      const SizedBox(height:11),
      _bookingTextField(_notes,'Notes (optional)',maxLines:4),
      const SizedBox(height:22),
      SizedBox(height:54,child:ElevatedButton(onPressed:_continueRequest,style:ElevatedButton.styleFrom(backgroundColor:AppColors.accent,foregroundColor:Colors.white,elevation:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(28))),child:const Text('CONTINUE',style:TextStyle(fontSize:12,fontWeight:FontWeight.w800,letterSpacing:.5)))),
      const SizedBox(height:10),
      const Text('This prepares your porter request for review. Online submission will be connected when the porter-booking API is available.',textAlign:TextAlign.center,style:TextStyle(color:AppColors.textMuted,fontSize:9.5,height:1.4)),
    ])),
  );
}

class PorterBookingReviewPage extends StatelessWidget {
  const PorterBookingReviewPage({super.key,required this.porter,required this.visitorName,required this.phone,required this.email,required this.notes,required this.visitDate,required this.visitors});
  final _Porter porter;
  final String visitorName,phone,email,notes;
  final DateTime visitDate;
  final int visitors;
  @override
  Widget build(BuildContext context)=>Scaffold(
    backgroundColor:AppColors.background,
    appBar:AppBar(backgroundColor:AppColors.primary,foregroundColor:Colors.white,surfaceTintColor:Colors.transparent,title:const Text('Review Request',style:TextStyle(fontSize:17,fontWeight:FontWeight.w800))),
    body:ListView(padding:const EdgeInsets.fromLTRB(20,22,20,38),children:[
      Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:AppColors.primary,borderRadius:BorderRadius.circular(24)),child:const Column(children:[
        Icon(Icons.check_circle_outline_rounded,color:AppColors.accent,size:38),SizedBox(height:10),
        Text('Porter request ready',style:TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.w800)),
        SizedBox(height:6),Text('Review the details below before submission.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,fontSize:10.5)),
      ])),
      const SizedBox(height:18),
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:AppColors.cardBorder)),child:Column(children:[
        _porterDetailRow('Porter',porter.name),_porterDetailDivider(),
        _porterDetailRow('National Park',porter.park),_porterDetailDivider(),
        _porterDetailRow('Visit Date',_bookingDate(visitDate)),_porterDetailDivider(),
        _porterDetailRow('Visitors',visitors.toString()),_porterDetailDivider(),
        _porterDetailRow('Name',visitorName),_porterDetailDivider(),
        _porterDetailRow('Phone',phone),
        if(email.isNotEmpty)...[_porterDetailDivider(),_porterDetailRow('Email',email)],
        if(notes.isNotEmpty)...[_porterDetailDivider(),_porterDetailRow('Notes',notes)],
      ])),
      const SizedBox(height:18),
      Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(18)),child:const Text('Backend submission is not enabled yet. Your request has not been sent or confirmed.',style:TextStyle(color:AppColors.textPrimary,fontSize:11,height:1.45,fontWeight:FontWeight.w600))),
      const SizedBox(height:18),
      SizedBox(height:52,child:ElevatedButton(onPressed:null,style:ElevatedButton.styleFrom(disabledBackgroundColor:AppColors.divider,disabledForegroundColor:AppColors.textMuted,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(26))),child:const Text('SUBMISSION COMING SOON',style:TextStyle(fontSize:11,fontWeight:FontWeight.w800)))),
    ]),
  );
}

Widget _porterBookingField({required String label,required Widget child})=>Container(
  padding:const EdgeInsets.fromLTRB(16,12,16,13),
  decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:AppColors.cardBorder)),
  child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(label.toUpperCase(),style:const TextStyle(color:AppColors.textMuted,fontSize:7.5,fontWeight:FontWeight.w800,letterSpacing:.7)),
    const SizedBox(height:7),child,
  ]),
);
Widget _qtyButton(IconData icon,VoidCallback onTap)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(20),child:Container(width:34,height:34,decoration:BoxDecoration(color: Colors.white,shape:BoxShape.circle),child:Icon(icon,color:AppColors.primary,size:17)));
Widget _bookingTextField(TextEditingController controller,String label,{TextInputType? keyboardType,int maxLines=1,String? Function(String?)? validator})=>TextFormField(
  controller:controller,keyboardType:keyboardType,maxLines:maxLines,validator:validator,
  style:const TextStyle(color:AppColors.textPrimary,fontSize:12),
  decoration:InputDecoration(labelText:label,labelStyle:const TextStyle(color:AppColors.textSecondary,fontSize:11),filled:true,fillColor:Colors.white,contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:15),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(17),borderSide:const BorderSide(color:AppColors.cardBorder)),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(17),borderSide:const BorderSide(color:AppColors.primary,width:1.3)),errorBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(17),borderSide:const BorderSide(color:AppColors.danger))),
);
String _bookingDate(DateTime date){const m=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];return date.day.toString()+' '+m[date.month-1]+' '+date.year.toString();}

Widget _porterDetailRow(String label,String value)=>Padding(padding:const EdgeInsets.symmetric(vertical:3),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
  SizedBox(width:92,child:Text(label.toUpperCase(),style:const TextStyle(color:AppColors.textMuted,fontSize:7.5,fontWeight:FontWeight.w800,letterSpacing:.6))),
  Expanded(child:Text(value.trim().isEmpty?'Not provided':value,style:const TextStyle(color:AppColors.textPrimary,fontSize:11,height:1.35,fontWeight:FontWeight.w600))),
]));
Widget _porterDetailDivider()=>const Padding(padding:EdgeInsets.symmetric(vertical:10),child:Divider(height:1,color:AppColors.divider));
String _porterJoined(DateTime? date) {
  if(date==null) return 'Not provided';
  const months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return months[date.month-1]+' '+date.year.toString();
}

class _PorterGroup {
  const _PorterGroup({
    required this.id,
    required this.name,
    required this.community,
    required this.park,
    required this.country,
    required this.porters,
  });

  final int id;
  final String name, community, park, country;
  final List<_Porter> porters;

  factory _PorterGroup.fromPorters(List<_Porter> porters) {
    final first = porters.first;
    return _PorterGroup(
      id: first.groupId,
      name: first.group,
      community: first.community,
      park: first.park,
      country: first.country,
      porters: List<_Porter>.unmodifiable(porters),
    );
  }
}

class _PorterGroupCarousel extends StatelessWidget {
  const _PorterGroupCarousel({required this.groups});
  final List<_PorterGroup> groups;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 238,
    child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) => _PorterGroupCard(
        group: groups[index],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PorterGroupDetailPage(group: groups[index])),
        ),
      ),
    ),
  );
}

class _PorterGroupCard extends StatelessWidget {
  const _PorterGroupCard({required this.group, required this.onTap});
  final _PorterGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 286,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cardBorder)),
      child: Column(children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(_porterAvatar, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('PORTER GROUP', style: TextStyle(color: AppColors.accent, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .9)),
              const SizedBox(height: 4),
              Text(group.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.15, fontWeight: FontWeight.w700)),
            ])),
          ]),
        ),
        Expanded(child: Padding(
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
            Row(children: [
              Text(group.porters.length.toString() + (group.porters.length == 1 ? ' porter' : ' porters'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
              const Spacer(),
              const Text('View group', style: TextStyle(color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 15),
            ]),
          ]),
        )),
      ]),
    ),
  );
}

class PorterGroupDetailPage extends StatelessWidget {
  const PorterGroupDetailPage({super.key, required this.group});
  final _PorterGroup group;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, surfaceTintColor: Colors.transparent, title: const Text('Porter Group', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
    body: ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 38),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(22)),
          child: Row(children: [
            Container(width: 72, height: 72, padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: ClipOval(child: Image.asset(_porterAvatar, fit: BoxFit.cover))),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('PORTER GROUP', style: TextStyle(color: AppColors.accent, fontSize: 8.5, fontWeight: FontWeight.w700, letterSpacing: 1)),
              const SizedBox(height: 5),
              Text(group.name, style: const TextStyle(color: Colors.white, fontSize: 19, height: 1.15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              Text(group.community, style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 10.5)),
            ])),
          ]),
        ),
        const SizedBox(height: 26),
        const Text('COMMUNITY', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        const SizedBox(height: 6),
        Text(group.community, style: const TextStyle(color: AppColors.textPrimary, fontSize: 21, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('This porter group is connected to ${group.community}, a community associated with ${group.park}.', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.5)),
        const SizedBox(height: 28),
        const Text('GROUP MEMBERS', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        const SizedBox(height: 6),
        Text(group.porters.length.toString() + (group.porters.length == 1 ? ' porter in this group' : ' porters in this group'), style: const TextStyle(color: AppColors.textPrimary, fontSize: 21, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        ...group.porters.map((porter) => _PorterMemberCard(porter: porter, group: group)),
      ],
    ),
  );
}

class _PorterMemberCard extends StatelessWidget {
  const _PorterMemberCard({required this.porter, required this.group});
  final _Porter porter;
  final _PorterGroup group;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.cardBorder)),
    child: Row(children: [
      ClipOval(child: Image.asset(_porterAvatar, width: 52, height: 52, fit: BoxFit.cover)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(porter.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700))),
          if (porter.isGroupLeader)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: const Text('GROUP LEADER', style: TextStyle(color: AppColors.primary, fontSize: 6.8, fontWeight: FontWeight.w700, letterSpacing: .3)),
            ),
        ]),
        const SizedBox(height: 4),
        Text(group.name, style: const TextStyle(color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(group.community + ' · ' + group.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
      ])),
    ]),
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
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
