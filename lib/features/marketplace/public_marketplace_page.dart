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
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
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
                      onSelected: (_) {
                        setState(() => _category = c);
                        if (c != 'All') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CraftCategoryPage(
                                category: c,
                                products: _products.where((p) => p.category == c).toList(),
                              ),
                            ),
                          );
                        }
                      },
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
                      decoration: BoxDecoration(color: Colors.white.withOpacity(.94), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_outward_rounded, size: 17, color: AppColors.primary),
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

class CraftCategoryPage extends StatelessWidget {
  const CraftCategoryPage({super.key, required this.category, required this.products});
  final String category;
  final List<_CraftProduct> products;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: const Text('Craft Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())),
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
      ],
    ),
    body: CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('CRAFT CATEGORY', style: TextStyle(color: AppColors.accent, fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
          const SizedBox(height: 6),
          Text(category, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text('Handmade pieces from makers across Greater Virunga.', style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 11.5)),
        ]),
      )),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Row(children: [
            Expanded(
              child: Text(
                products.isEmpty ? 'Crafts' : products.length.toString() + ' crafts',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
              child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 19),
            ),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
        sliver: products.isEmpty
          ? const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 70), child: Center(child: Text('Products will appear here.', style: TextStyle(color: AppColors.textSecondary)))))
          : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .66),
              delegate: SliverChildBuilderDelegate((_, i) => _ProductCard(product: products[i]), childCount: products.length),
            ),
      ),
    ]),
  );
}

class PublicCraftDetailPage extends StatefulWidget {
  const PublicCraftDetailPage({super.key, required this.product});
  final _CraftProduct product;
  @override
  State<PublicCraftDetailPage> createState() => _PublicCraftDetailPageState();
}

class _PublicCraftDetailPageState extends State<PublicCraftDetailPage> {
  int quantity = 1;
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    _RecentlyViewed.add(product);
    final recent = _RecentlyViewed.items.where((p) => p.name != product.name).take(3).toList();
    final related = _PublicMarketplacePageState._products
        .where((p) => p.name != product.name && !recent.any((r) => r.name == p.name))
        .take(3)
        .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 360,
          pinned: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(onPressed: () => setState(() => saved = !saved), icon: Icon(saved ? Icons.favorite_rounded : Icons.favorite_border_rounded)),
            IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())), icon: const Icon(Icons.shopping_bag_outlined)),
          ],
          flexibleSpace: FlexibleSpaceBar(background: Image.asset(product.image, fit: BoxFit.cover)),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 23, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.category.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(product.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 27, height: 1.12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 17), const SizedBox(width: 5), Text(product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]),
            const SizedBox(height: 23),
            Row(children: [
              const Text('Quantity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const Spacer(),
              _qty(Icons.remove_rounded, () { if (quantity > 1) setState(() => quantity--); }),
              SizedBox(width: 38, child: Text(quantity.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
              _qty(Icons.add_rounded, () => setState(() => quantity++)),
            ]),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, height: 52, child: FilledButton.icon(
              onPressed: () {
                _MarketplaceCart.add(product, quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(product.name + ' added to cart'),
                    action: SnackBarAction(
                      label: 'VIEW CART',
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())),
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.w700)),
            )),
            const SizedBox(height: 29),
            const Text('About this craft', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(product.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.6)),
            const SizedBox(height: 25),
            Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ARTISAN STORY', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
              SizedBox(height: 6),
              Text('Meet the maker behind the craft', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Text('Artisan profile information will connect here when marketplace data is available.', style: TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.5)),
            ])),
            const SizedBox(height: 30),
            Text(recent.isEmpty ? 'MORE CRAFTS' : 'RECENTLY VIEWED', style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
            const SizedBox(height: 5),
            Text(recent.isEmpty ? 'You may also like' : 'Continue exploring', style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 13),
          ]),
        )),
        SliverToBoxAdapter(child: SizedBox(
          height: 245,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            scrollDirection: Axis.horizontal,
            itemCount: (recent.isEmpty ? related : recent).length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final items = recent.isEmpty ? related : recent;
              return SizedBox(width: 165, child: _ProductCard(product: items[i]));
            },
          ),
        )),
      ]),
    );
  }

  Widget _qty(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.cardBorder)), child: Icon(icon, color: AppColors.primary, size: 18)),
  );
}

class MarketplaceCartPage extends StatefulWidget {
  const MarketplaceCartPage({super.key});
  @override
  State<MarketplaceCartPage> createState() => _MarketplaceCartPageState();
}

class _MarketplaceCartPageState extends State<MarketplaceCartPage> {
  @override
  Widget build(BuildContext context) {
    final items = _MarketplaceCart.items;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Your Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
      body: items.isEmpty
        ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 44),
            SizedBox(height: 13),
            Text('Your cart is empty', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 5),
            Text('Crafts you add will appear here.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ]))
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 34),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final item = items[i];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.cardBorder)),
                child: Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(item.product.image, width: 76, height: 76, fit: BoxFit.cover)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.product.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(item.product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                    const SizedBox(height: 7),
                    Text('Qty ' + item.quantity.toString(), style: const TextStyle(color: AppColors.primary, fontSize: 10.5, fontWeight: FontWeight.w700)),
                  ])),
                  IconButton(onPressed: () => setState(() => _MarketplaceCart.remove(item)), icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSecondary)),
                ]),
              );
            },
          ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.cardBorder))),
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: const Text('Continue with Cart', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _cartQty(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.cardBorder)),
      child: Icon(icon, color: AppColors.primary, size: 15),
    ),
  );
}

class _RecentlyViewed {
  static final List<_CraftProduct> items = [];

  static void add(_CraftProduct product) {
    items.removeWhere((item) => item.name == product.name);
    items.insert(0, product);
    if (items.length > 6) items.removeLast();
  }
}

class _MarketplaceCart {
  static final List<_CartItem> items = [];
  static void add(_CraftProduct product, int quantity) {
    final index = items.indexWhere((item) => item.product.name == product.name);
    if (index >= 0) {
      items[index].quantity += quantity;
    } else {
      items.add(_CartItem(product, quantity));
    }
  }
  static void remove(_CartItem item) => items.remove(item);
}

class _CartItem {
  _CartItem(this.product, this.quantity);
  final _CraftProduct product;
  int quantity;
}

class _CraftProduct {
  const _CraftProduct(this.name, this.category, this.country, this.description, this.image);
  final String name;
  final String category;
  final String country;
  final String description;
  final String image;
}
