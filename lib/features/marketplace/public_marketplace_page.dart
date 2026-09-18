import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class PublicMarketplacePage extends StatefulWidget {
  const PublicMarketplacePage({super.key});

  @override
  State<PublicMarketplacePage> createState() => _PublicMarketplacePageState();
}

class _PublicMarketplacePageState extends State<PublicMarketplacePage> {
  final _search = TextEditingController();
  String _query = '';
  String _category = 'All';

  static const _categories = [
    'All',
    'Baskets & Weaving',
    'Beadwork & Jewellery',
    'Wood Carvings',
    'Textiles & Clothing',
    'Pottery & Ceramics',
  ];

  static const _products = [
    _CraftProduct('Virunga Beaded Sandals', 'Beadwork & Jewellery', 'Uganda', 'Hand-finished beadwork inspired by communities around the Virunga landscape.', 'assets/images/crafts_beaded_sandals.jpg'),
    _CraftProduct('Handwoven Basket', 'Baskets & Weaving', 'Rwanda', 'Traditional woven craft made with patterns rooted in local making traditions.', 'assets/images/onboarding_community.jpg'),
    _CraftProduct('Carved Wildlife Art', 'Wood Carvings', 'DR Congo', 'Decorative wood craft celebrating the wildlife and forests of the region.', 'assets/images/onboarding_wildlife.jpg'),
    _CraftProduct('Heritage Textile', 'Textiles & Clothing', 'Uganda', 'A presentation of textile craft and living cultural expression.', 'assets/images/onboarding_landscape.jpg'),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<_CraftProduct> get _visible {
    final q = _query.trim().toLowerCase();
    return _products.where((p) {
      final categoryOk = _category == 'All' || p.category == _category;
      final queryOk = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.country.toLowerCase().contains(q);
      return categoryOk && queryOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _visible;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Marketplace', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AUTHENTIC CRAFTS', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
                    const SizedBox(height: 6),
                    const Text('Made across Greater Virunga.', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 7),
                    Text('Discover local making, heritage and artisan stories from Uganda, Rwanda and DR Congo.', style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 12, height: 1.45)),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search crafts, categories or country',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 62,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final c = _categories[i];
                    final selected = c == _category;
                    return ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _category = c),
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.cardBorder),
                      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DISCOVER', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                    SizedBox(height: 4),
                    Text('Crafts & Artisans', style: TextStyle(color: AppColors.textPrimary, fontSize: 23, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No crafts match your search.', style: TextStyle(color: AppColors.textSecondary))),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .66),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _ProductCard(product: products[i]),
                    childCount: products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final _CraftProduct product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PublicCraftDetailPage(product: product))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.cardBorder)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(product.image, fit: BoxFit.cover),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border_rounded, size: 18, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.accent, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .5)),
                  const SizedBox(height: 4),
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.2, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 7),
                  Row(children: [const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary), const SizedBox(width: 3), Expanded(child: Text(product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PublicCraftDetailPage extends StatelessWidget {
  const PublicCraftDetailPage({super.key, required this.product});
  final _CraftProduct product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(background: Image.asset(product.image, fit: BoxFit.cover)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                  const SizedBox(height: 7),
                  Text(product.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 27, height: 1.15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 9),
                  Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18), const SizedBox(width: 5), Text(product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))]),
                  const SizedBox(height: 25),
                  const Text('About this craft', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 9),
                  Text(product.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.65)),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ARTISAN STORY', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                        SizedBox(height: 7),
                        Text('Meet the people behind the craft', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                        SizedBox(height: 6),
                        Text('Artisan profiles and live product information will appear here when marketplace data is connected.', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CraftProduct {
  const _CraftProduct(this.name, this.category, this.country, this.description, this.image);
  final String name;
  final String category;
  final String country;
  final String description;
  final String image;
}
