import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String _country = 'All';
  bool _loading = true;
  String? _loadError;
  List<_CraftProduct> _products = [];

  List<String> get _categories {
    final values = _products
        .map((product) => product.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return ['All', ...values];
  }

  List<String> get _countries {
    final values = _products
        .map((product) => product.country.trim())
        .where((country) => country.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return ['All', ...values];
  }

  @override
  void initState() {
    super.initState();
    _loadCrafts();
  }

  Future<void> _loadCrafts() async {
    if (mounted) setState(() { _loading = true; _loadError = null; });
    try {
      final response = await http.get(Uri.parse('https://backend.redrocksafrica.com/api/web/crafts/all/'));
      if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('Server error');
      final decoded = jsonDecode(response.body);
      if (decoded is! List) throw Exception('Unexpected crafts response');
      final products = decoded.whereType<Map>().map((item) => _CraftProduct.fromJson(Map<String, dynamic>.from(item))).toList();
      if (!mounted) return;
      setState(() { _products = products; _MarketplaceCatalog.products = products; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _loadError = e.toString(); });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<_CraftProduct> get _visible {
    final q = _query.trim().toLowerCase();
    return _products.where((p) {
      final categoryOk = _category == 'All' || p.category == _category;
      final countryOk = _country == 'All' || p.country == _country;
      final queryOk = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.country.toLowerCase().contains(q) ||
          p.seller.toLowerCase().contains(q) ||
          p.community.toLowerCase().contains(q) ||
          p.park.toLowerCase().contains(q);
      return categoryOk && countryOk && queryOk;
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
            tooltip: 'Saved crafts',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedCraftsPage())),
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())),
            icon: _cartIcon(),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Shop by country', style: TextStyle(color: AppColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 9),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _countries.asMap().entries.expand((entry) {
                        final country = entry.value;
                        return [
                          if (entry.key > 0) const SizedBox(width: 6),
                          _CountryFilter(
                            label: country,
                            selected: _country == country,
                            onTap: () => setState(() => _country = country),
                          ),
                        ];
                      }).toList(),
                    ),
                  ),
                ]),
              ),
            ),
            if (_country != 'All' || _query.trim().isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        _country != 'All' ? 'Showing crafts from ' + _country : 'Search results',
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _search.clear();
                        setState(() {
                          _query = '';
                          _country = 'All';
                        });
                      },
                      child: const Text('Clear', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ]),
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
            if (_loading)
              const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
            else if (_loadError != null)
              SliverFillRemaining(hasScrollBody: false, child: Center(child: OutlinedButton(onPressed: _loadCrafts, child: const Text('Could not load crafts — Try Again'))))
            else if (products.isEmpty)
              const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('No crafts match your search.', style: TextStyle(color: AppColors.textSecondary))))
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

class _CountryFilter extends StatelessWidget {
  const _CountryFilter({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? AppColors.primary : AppColors.cardBorder)),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.primary, fontSize: 8.5, fontWeight: FontWeight.w700)),
    ),
  );
}

Widget _cartIcon() => Stack(
  clipBehavior: Clip.none,
  children: [
    const Icon(Icons.shopping_bag_outlined),
    if (_MarketplaceCart.totalQuantity > 0)
      Positioned(
        right: -7,
        top: -7,
        child: Container(
          constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            _MarketplaceCart.totalQuantity.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ),
      ),
  ],
);

class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.product});
  final _CraftProduct product;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final saved = _SavedCrafts.contains(product);
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
                  _CraftImage(url: product.image, fit: BoxFit.cover),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.white.withOpacity(.94),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => setState(() => _SavedCrafts.toggle(product)),
                        child: SizedBox(
                          width: 34,
                          height: 34,
                          child: Icon(saved ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 17, color: saved ? AppColors.accent : AppColors.primary),
                        ),
                      ),
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
                  Row(children: [const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary), const SizedBox(width: 3), Expanded(child: Text(product.country, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)))]),
                  const SizedBox(height: 7),
                  Row(children: [
                    Expanded(child: Text(_formatPrice(product.price), style: const TextStyle(color: AppColors.primary, fontSize: 11.5, fontWeight: FontWeight.w700))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: product.inStock ? AppColors.mintSoft : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(product.inStock ? 'IN STOCK' : 'OUT OF STOCK', style: TextStyle(color: product.inStock ? AppColors.success : AppColors.textSecondary, fontSize: 6.8, fontWeight: FontWeight.w700, letterSpacing: .25)),
                    ),
                  ]),
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
          icon: _cartIcon(),
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
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: products
                .map((product) => product.country)
                .where((country) => country.trim().isNotEmpty)
                .toSet()
                .map((country) => _RegionPill(country))
                .toList(),
          ),
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

class _RegionPill extends StatelessWidget {
  const _RegionPill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: Colors.white.withOpacity(.09), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(.14))),
    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w600)),
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
  int imageIndex = 0;

  @override
  void initState() {
    super.initState();
    _RecentlyViewed.add(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final saved = _SavedCrafts.contains(product);
    final recent = _RecentlyViewed.items.where((p) => p.id != product.id).take(3).toList();
    final sameCategory = _MarketplaceCatalog.products
        .where((p) => p.id != product.id && p.category == product.category && !recent.any((r) => r.id == p.id))
        .toList();
    final otherCrafts = _MarketplaceCatalog.products
        .where((p) => p.id != product.id && p.category != product.category && !recent.any((r) => r.id == p.id))
        .toList();
    final related = [...sameCategory, ...otherCrafts].take(3).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 360,
          pinned: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: saved ? 'Remove from saved' : 'Save craft',
              onPressed: () => setState(() => _SavedCrafts.toggle(product)),
              icon: Icon(saved ? Icons.favorite_rounded : Icons.favorite_border_rounded),
            ),
            IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())), icon: _cartIcon()),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (product.images.length > 1)
                  PageView.builder(
                    itemCount: product.images.length,
                    onPageChanged: (index) => setState(() => imageIndex = index),
                    itemBuilder: (_, index) => _CraftImage(url: product.images[index], fit: BoxFit.cover),
                  )
                else
                  _CraftImage(url: product.image, fit: BoxFit.cover),
                if (product.images.length > 1)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(product.images.length, (index) => GestureDetector(
                        onTap: () => setState(() => imageIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: index == imageIndex ? 22 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: index == imageIndex ? Colors.white : Colors.white.withOpacity(.55),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 23, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.category.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(product.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 27, height: 1.12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 9),
            Text(_formatPrice(product.price), style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 17), const SizedBox(width: 5), Expanded(child: Text(product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)))]),
            const SizedBox(height: 18),
            const SizedBox(height: 14),
            const Row(children: [
              Icon(Icons.visibility_outlined, color: AppColors.textSecondary, size: 15),
              SizedBox(width: 5),
              Text('200 views', style: TextStyle(color: AppColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Icon(product.inStock ? Icons.check_circle_outline_rounded : Icons.inventory_2_outlined, color: product.inStock ? AppColors.success : AppColors.textSecondary, size: 15),
              const SizedBox(width: 5),
              Text(
                product.inStock ? (product.quantityAvailable.toString() + ' available') : 'Currently out of stock',
                style: TextStyle(color: product.inStock ? AppColors.success : AppColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w600),
              ),
            ]),
            const SizedBox(height: 22),
            if (product.inStock && product.quantityAvailable > 0) ...[
              Row(children: [
                const Text('Quantity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const Spacer(),
                _qty(Icons.remove_rounded, () { if (quantity > 1) setState(() => quantity--); }),
                SizedBox(width: 38, child: Text(quantity.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
                _qty(Icons.add_rounded, () {
                  if (quantity < product.quantityAvailable) setState(() => quantity++);
                }),
              ]),
              const SizedBox(height: 18),
            ],
            SizedBox(width: double.infinity, height: 52, child: FilledButton.icon(
              onPressed: product.inStock && product.quantityAvailable > 0 ? () {
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
              } : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.divider,
                disabledForegroundColor: AppColors.textSecondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: Icon(product.inStock && product.quantityAvailable > 0 ? Icons.shopping_bag_outlined : Icons.inventory_2_outlined),
              label: Text(product.inStock && product.quantityAvailable > 0 ? 'Add to Cart' : 'Out of Stock', style: const TextStyle(fontWeight: FontWeight.w700)),
            )),
            const SizedBox(height: 29),
            const Text('About this craft', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(product.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.6)),
            const SizedBox(height: 22),
            InkWell(
              onTap: () {
                final categoryProducts = _MarketplaceCatalog.products.where((p) => p.category == product.category).toList();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CraftCategoryPage(category: product.category, products: categoryProducts)));
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 18)),
                  const SizedBox(width: 11),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('EXPLORE CATEGORY', style: TextStyle(color: AppColors.accent, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .8)),
                    const SizedBox(height: 3),
                    Text(product.category, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ])),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                ]),
              ),
            ),
            const SizedBox(height: 25),
            Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('ARTISAN', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
              const SizedBox(height: 6),
              Text(product.seller, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text(product.community + ' • ' + product.park, style: const TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.5)),
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

class SavedCraftsPage extends StatefulWidget {
  const SavedCraftsPage({super.key});

  @override
  State<SavedCraftsPage> createState() => _SavedCraftsPageState();
}

class _SavedCraftsPageState extends State<SavedCraftsPage> {
  @override
  Widget build(BuildContext context) {
    final products = _SavedCrafts.items;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Saved Crafts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage())),
            icon: _cartIcon(),
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border_rounded, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 17),
                  const Text('No saved crafts yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text('Save crafts you would like to come back to.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.45)),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Explore Marketplace', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ]),
              ),
            )
          : CustomScrollView(slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('YOUR COLLECTION', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                    SizedBox(height: 4),
                    Text('Crafts to revisit', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .66),
                  delegate: SliverChildBuilderDelegate((_, i) => _ProductCard(product: products[i]), childCount: products.length),
                ),
              ),
            ]),
    );
  }
}

class _SavedCrafts {
  static final List<_CraftProduct> items = [];

  static bool contains(_CraftProduct product) =>
      items.any((item) => item.id == product.id);

  static void toggle(_CraftProduct product) {
    final index = items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      items.removeAt(index);
    } else {
      items.insert(0, product);
    }
  }
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
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: _CraftImage(url: item.product.image, width: 76, height: 76, fit: BoxFit.cover)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.product.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(item.product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(_formatPrice(item.product.price * item.quantity), style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 7),
                    Row(children: [
                      _cartQty(Icons.remove_rounded, () => setState(() {
                        if (item.quantity > 1) item.quantity--;
                      })),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(item.quantity.toString(), style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      _cartQty(Icons.add_rounded, () => setState(() {
                        if (item.quantity < item.product.quantityAvailable) item.quantity++;
                      })),
                    ]),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      const Text('Cart total', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const Spacer(),
                      Text(_formatPrice(_MarketplaceCart.totalPrice), style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 10),
                    SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    icon: const Icon(Icons.storefront_outlined, size: 18),
                    label: const Text('Continue Shopping', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                  ],
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
    items.removeWhere((item) => item.id == product.id);
    items.insert(0, product);
    if (items.length > 6) items.removeLast();
  }
}

class _MarketplaceCart {
  static final List<_CartItem> items = [];

  static int get totalQuantity =>
      items.fold<int>(0, (total, item) => total + item.quantity);
  static double get totalPrice =>
      items.fold<double>(0, (total, item) => total + (item.product.price * item.quantity));
  static void add(_CraftProduct product, int quantity) {
    if (!product.inStock || product.quantityAvailable <= 0) return;
    final safeQuantity = quantity.clamp(1, product.quantityAvailable);
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index].quantity = (items[index].quantity + safeQuantity).clamp(1, product.quantityAvailable);
    } else {
      items.add(_CartItem(product, safeQuantity));
    }
  }
  static void remove(_CartItem item) => items.remove(item);
}

class _CartItem {
  _CartItem(this.product, this.quantity);
  final _CraftProduct product;
  int quantity;
}

String _formatPrice(double price) {
  final whole = price.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return 'UGX ' + buffer.toString();
}

class _MarketplaceCatalog {
  static List<_CraftProduct> products = [];
}

class _CraftProduct {
  const _CraftProduct({required this.id, required this.name, required this.category, required this.country, required this.description, required this.image, required this.images, required this.price, required this.quantityAvailable, required this.inStock, required this.isActive, required this.seller, required this.community, required this.park});
  final int id;
  final String name, category, country, description, image, seller, community, park;
  final List<String> images;
  final double price;
  final int quantityAvailable;
  final bool inStock, isActive;

  factory _CraftProduct.fromJson(Map<String, dynamic> json) {
    final category = json['category'] is Map ? Map<String, dynamic>.from(json['category']) : <String, dynamic>{};
    final imagesJson = json['images'] is Map ? Map<String, dynamic>.from(json['images']) : <String, dynamic>{};
    final seller = json['seller'] is Map ? Map<String, dynamic>.from(json['seller']) : <String, dynamic>{};
    final community = seller['community'] is Map ? Map<String, dynamic>.from(seller['community']) : <String, dynamic>{};
    final park = community['national_park'] is Map ? Map<String, dynamic>.from(community['national_park']) : <String, dynamic>{};
    final country = community['country'] is Map ? Map<String, dynamic>.from(community['country']) : <String, dynamic>{};
    final allImages = ['featured','image_2','image_3'].map((key) => _secureImageUrl(imagesJson[key]?.toString() ?? '')).where((url) => url.isNotEmpty).toList();
    return _CraftProduct(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      category: category['name']?.toString() ?? '',
      country: country['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: allImages.isNotEmpty ? allImages.first : '',
      images: allImages,
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      quantityAvailable: int.tryParse(json['quantity_available']?.toString() ?? '') ?? 0,
      inStock: json['in_stock'] == true,
      isActive: json['is_active'] == true,
      seller: seller['name']?.toString() ?? '',
      community: community['name']?.toString() ?? '',
      park: park['name']?.toString() ?? '',
    );
  }
  static String _secureImageUrl(String raw) {
    final value = raw.trim();
    if (value.isEmpty || value == 'null') return '';
    return value.startsWith('http://backend.redrocksafrica.com/') ? value.replaceFirst('http://', 'https://') : value;
  }
}

class _CraftImage extends StatelessWidget {
  const _CraftImage({required this.url, this.width, this.height, this.fit = BoxFit.cover});
  final String url;
  final double? width, height;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Container(width: width, height: height, color: AppColors.accentSoft, alignment: Alignment.center, child: const Icon(Icons.image_outlined, color: AppColors.primary));
    return Image.network(url, width: width, height: height, fit: fit, errorBuilder: (_, __, ___) => Container(width: width, height: height, color: AppColors.accentSoft, alignment: Alignment.center, child: const Icon(Icons.broken_image_outlined, color: AppColors.primary)));
  }
}
