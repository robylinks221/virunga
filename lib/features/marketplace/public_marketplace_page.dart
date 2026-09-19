import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/theme/app_theme.dart';
import '../../core/storage/token_storage.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';

Future<bool> _requireMarketplaceLogin(BuildContext context) async {
  final auth=AuthService(tokenStorage:const TokenStorage());
  final loggedIn=await auth.restoreSession();
  if(loggedIn)return true;
  if(!context.mounted)return false;
  await Navigator.of(context).push(MaterialPageRoute(builder:(_)=>LoginPage(authService:auth)));
  return false;
}

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
  List<CraftProduct> _products = [];

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
      final products = decoded
          .whereType<Map>()
          .map((item) => CraftProduct.fromJson(Map<String, dynamic>.from(item)))
          .toList();
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

  List<CraftProduct> get _visible {
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
            onPressed: () async {
              if(!await _requireMarketplaceLogin(context))return;
              if(!context.mounted)return;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedCraftsPage()));
            },
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: () async {
              if(!await _requireMarketplaceLogin(context))return;
              if(!context.mounted)return;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage()));
            },
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
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AUTHENTIC CRAFTS', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
                    const SizedBox(height: 6),
                    const Text('Unique African Crafts', style: TextStyle(color: AppColors.primary, fontSize: 27, height: 1.1, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 7),
                    const Text('Support local artisans and discover crafts made across Greater Virunga.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.45)),
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
  final CraftProduct product;

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
                    Expanded(child: Text(_formatPrice(product.price), style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w800))),
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

class CraftCategoryPage extends StatefulWidget {
  const CraftCategoryPage({super.key, required this.category, required this.products});
  final String category;
  final List<CraftProduct> products;

  @override
  State<CraftCategoryPage> createState() => _CraftCategoryPageState();
}

class _CraftCategoryPageState extends State<CraftCategoryPage> {
  String country = 'All';

  List<String> get countries {
    final values = widget.products
        .map((product) => product.country.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['All', ...values];
  }

  List<CraftProduct> get visible =>
      country == 'All' ? widget.products : widget.products.where((product) => product.country == country).toList();

  @override
  Widget build(BuildContext context) {
    final products = visible;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Craft Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: () async {
              if(!await _requireMarketplaceLogin(context))return;
              if(!context.mounted)return;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceCartPage()));
            },
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
            Text(widget.category, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 7),
            Text('Discover crafts available in this category across Greater Virunga.', style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 11.5)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: countries.asMap().entries.expand((entry) {
                  final value = entry.value;
                  final selected = value == country;
                  return [
                    if (entry.key > 0) const SizedBox(width: 7),
                    ChoiceChip(
                      label: Text(value),
                      selected: selected,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => country = value),
                      selectedColor: AppColors.accent,
                      backgroundColor: Colors.white.withOpacity(.08),
                      side: BorderSide(color: selected ? AppColors.accent : Colors.white.withOpacity(.15)),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ];
                }).toList(),
              ),
            ),
          ]),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Row(children: [
              Expanded(
                child: Text(
                  products.isEmpty ? 'No crafts' : products.length.toString() + (products.length == 1 ? ' craft' : ' crafts'),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              if (country != 'All')
                TextButton(onPressed: () => setState(() => country = 'All'), child: const Text('Clear')),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
          sliver: products.isEmpty
              ? const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 70), child: Center(child: Text('No crafts available for this filter.', style: TextStyle(color: AppColors.textSecondary)))))
              : SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .61),
                  delegate: SliverChildBuilderDelegate((_, i) => _ProductCard(product: products[i]), childCount: products.length),
                ),
        ),
      ]),
    );
  }
}

class PublicCraftDetailPage extends StatefulWidget {
  const PublicCraftDetailPage({super.key, required this.product});

  final CraftProduct product;

  @override
  State<PublicCraftDetailPage> createState() => _PublicCraftDetailPageState();
}

class _PublicCraftDetailPageState extends State<PublicCraftDetailPage> {
  int quantity = 1;
  int selectedImage = 0;

  @override
  void initState() {
    super.initState();
    _RecentlyViewed.add(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final saved = _SavedCrafts.contains(p);
    final available = p.inStock && p.quantityAvailable > 0;
    final images = p.images.isNotEmpty
        ? p.images
        : (p.image.isNotEmpty ? <String>[p.image] : <String>[]);
    final hero = images.isNotEmpty
        ? images[selectedImage.clamp(0, images.length - 1)]
        : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              color: AppColors.primary,
              child: Row(
                children: [
                  _headerButton(
                    Icons.arrow_back_ios_new_rounded,
                    () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Product Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  _headerButton(
                    Icons.ios_share_rounded,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share craft link coming soon.'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _headerButton(
                    saved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    () async {
                      if(!await _requireMarketplaceLogin(context))return;
                      if(!mounted)return;
                      setState(() => _SavedCrafts.toggle(p));
                    },
                    accent: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _CraftImage(url: hero, fit: BoxFit.cover),
                          Positioned(
                            right: 16,
                            top: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.92),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 9,
                                    height: 9,
                                    decoration: BoxDecoration(
                                      color: available
                                          ? const Color(0xFF21C96B)
                                          : AppColors.danger,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        available
                                            ? 'In Stock'
                                            : 'Out of Stock',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (available)
                                        Text(
                                          '${p.quantityAvailable} available',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(.88),
                                            fontSize: 10,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (images.length > 1)
                      SizedBox(
                        height: 78,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedImage = i),
                              child: Container(
                                width: 88,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: selectedImage == i
                                        ? AppColors.accent
                                        : AppColors.cardBorder,
                                    width: selectedImage == i ? 2 : 1,
                                  ),
                                ),
                                child: _CraftImage(
                                  url: images[i],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.shopping_basket_outlined,
                                  color: AppColors.accent,
                                  size: 17,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  p.category.isEmpty
                                      ? 'Local Craft'
                                      : p.category,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            p.name,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 25,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _formatPrice(p.price),
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            p.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              height: 1.42,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 33,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'CRAFTED BY',
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: .7,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        p.seller.isEmpty
                                            ? 'Local Craft Seller'
                                            : p.seller,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            color: AppColors.primary,
                                            size: 13,
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              [p.community, p.country]
                                                  .where(
                                                    (x) =>
                                                        x.trim().isNotEmpty,
                                                  )
                                                  .join(', '),
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color:
                                                    AppColors.textSecondary,
                                                fontSize: 9.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            CraftSellerStorePage(
                                          seller: p.seller,
                                          community: p.community,
                                          country: p.country,
                                        ),
                                      ),
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 11,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'View Profile',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: AppColors.cardBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _qty(
                                      Icons.remove_rounded,
                                      () {
                                        if (quantity > 1) {
                                          setState(() => quantity--);
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 34,
                                      child: Text(
                                        '$quantity',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    _qty(
                                      Icons.add_rounded,
                                      () {
                                        if (quantity <
                                            p.quantityAvailable) {
                                          setState(() => quantity++);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: FilledButton.icon(
                                    onPressed: available
                                        ? () async {
                                            if(!await _requireMarketplaceLogin(context))return;
                                            if(!mounted)return;
                                            _MarketplaceCart.add(
                                              p,
                                              quantity,
                                            );
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${p.name} added to cart'),
                                                action: SnackBarAction(
                                                  label: 'VIEW CART',
                                                  onPressed: () => Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (_) => const MarketplaceCartPage()),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          AppColors.divider,
                                      shape: const StadiumBorder(),
                                    ),
                                    icon: Icon(
                                      available
                                          ? Icons.shopping_cart_outlined
                                          : Icons.inventory_2_outlined,
                                      size: 19,
                                    ),
                                    label: Text(
                                      available
                                          ? 'Add to Cart'
                                          : 'Out of Stock',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_MarketplaceCart.totalQuantity > 0) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  if(!await _requireMarketplaceLogin(context))return;
                                  if(!mounted)return;
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const MarketplaceCartPage()),
                                  );
                                  if (mounted) setState(() {});
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary, width: 1.4),
                                  shape: const StadiumBorder(),
                                ),
                                icon: const Icon(Icons.shopping_bag_outlined, size: 19),
                                label: Text(
                                  'View Cart  (${_MarketplaceCart.totalQuantity})',
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: FilledButton.icon(
                                    onPressed: () async {
                                      if(!await _requireMarketplaceLogin(context))return;
                                      if(!mounted)return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Seller messaging coming soon.',
                                          ),
                                        ),
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                    ),
                                    icon: const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 19,
                                    ),
                                    label: const Text(
                                      'Message Seller',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: FilledButton.icon(
                                    onPressed: () async {
                                      if(!await _requireMarketplaceLogin(context))return;
                                      if(!mounted)return;
                                      setState(() => _SavedCrafts.toggle(p));
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                    ),
                                    icon: Icon(
                                      saved
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_border_rounded,
                                      size: 19,
                                    ),
                                    label: Text(
                                      saved ? 'Saved' : 'Save for Later',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
                      child: _CraftProductSection(
                        title: 'Other Products from the Seller',
                        subtitle: 'More crafts created by the same artisan',
                        icon: Icons.storefront_outlined,
                        products: _MarketplaceCatalog.products
                            .where(
                              (x) =>
                                  x.id != p.id &&
                                  x.seller.trim().toLowerCase() ==
                                      p.seller.trim().toLowerCase(),
                            )
                            .take(6)
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                      child: _CraftProductSection(
                        title: 'Recently Viewed Products',
                        subtitle: 'Continue exploring crafts you opened recently',
                        icon: Icons.history_rounded,
                        products: _RecentlyViewed.items
                            .where((x) => x.id != p.id)
                            .take(6)
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerButton(
    IconData icon,
    VoidCallback tap, {
    bool accent = false,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: tap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(
            icon,
            color: accent ? AppColors.accent : AppColors.primary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _qty(IconData icon, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 39,
        height: 49,
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 19,
        ),
      ),
    );
  }
}

class _CraftProductSection extends StatelessWidget {
  const _CraftProductSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.products,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<CraftProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.045),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 17,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9.5,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.accent,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 248,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 11),
              itemBuilder: (_, i) => SizedBox(
                width: 154,
                child: _ProductCard(product: products[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CraftSellerStorePage extends StatelessWidget {
  const CraftSellerStorePage({super.key, required this.seller, required this.community, required this.country});
  final String seller, community, country;

  @override
  Widget build(BuildContext context) {
    final key = seller.trim().toLowerCase();
    final products = _MarketplaceCatalog.products.where((x) => x.seller.trim().toLowerCase() == key).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.primary, foregroundColor: Colors.white, title: const Text('Craft Seller', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(children: [
            Container(width: 86, height: 86, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.accent, width: 2)), child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 42)),
            const SizedBox(height: 13),
            Text(seller.isEmpty ? 'Local Craft Seller' : seller, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
            if (community.trim().isNotEmpty || country.trim().isNotEmpty) ...[
              const SizedBox(height: 7),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 16), const SizedBox(width: 4),
                Flexible(child: Text([community, country].where((x) => x.trim().isNotEmpty).join(', '), textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(.76), fontSize: 11.5))),
              ]),
            ],
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(22)),
              child: Text(products.length.toString() + (products.length == 1 ? ' Craft' : ' Crafts'), style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800)),
            ),
          ]),
        )),
        const SliverToBoxAdapter(child: Padding(
          padding: EdgeInsets.fromLTRB(20, 22, 20, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('CRAFT COLLECTION', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
            SizedBox(height: 5),
            Text('Crafts by this seller', style: TextStyle(color: AppColors.primary, fontSize: 21, fontWeight: FontWeight.w800)),
          ]),
        )),
        if (products.isEmpty)
          const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(20, 50, 20, 30), child: Center(child: Text('No other crafts are available from this seller yet.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)))))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .61),
              delegate: SliverChildBuilderDelegate((_, i) => _ProductCard(product: products[i]), childCount: products.length),
            ),
          ),
      ]),
    );
  }
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
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border_rounded, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 17),
                  const Text('No saved crafts yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text('Save crafts you would like to come back to.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.45)),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent), shape: const StadiumBorder()),
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
  static final List<CraftProduct> items = [];

  static bool contains(CraftProduct product) =>
      items.any((item) => item.id == product.id);

  static void toggle(CraftProduct product) {
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
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Your Cart', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        actions: [
          if (items.isNotEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  _MarketplaceCart.totalQuantity.toString() + ' items',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ),
        ],
      ),
      body: items.isEmpty
        ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 44),
            SizedBox(height: 13),
            Text('Your cart is empty', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 5),
            Text('Crafts you add will appear here.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ]))
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final item = items[i];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cardBorder)),
                child: Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: _CraftImage(url: item.product.image, width: 76, height: 76, fit: BoxFit.cover)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.product.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(item.product.country, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(_formatPrice(item.product.price * item.quantity), style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w800)),
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
                      const Text('Cart Total', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
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
  static final List<CraftProduct> items = [];

  static void add(CraftProduct product) {
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
  static void add(CraftProduct product, int quantity) {
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
  final CraftProduct product;
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
  static List<CraftProduct> products = [];
}

class CraftProduct {
  const CraftProduct({required this.id, required this.name, required this.category, required this.country, required this.description, required this.image, required this.images, required this.price, required this.quantityAvailable, required this.inStock, required this.isActive, required this.seller, required this.community, required this.park});
  final int id;
  final String name, category, country, description, image, seller, community, park;
  final List<String> images;
  final double price;
  final int quantityAvailable;
  final bool inStock, isActive;

  factory CraftProduct.fromJson(Map<String, dynamic> json) {
    final category = json['category'] is Map ? Map<String, dynamic>.from(json['category']) : <String, dynamic>{};
    final imagesJson = json['images'] is Map ? Map<String, dynamic>.from(json['images']) : <String, dynamic>{};
    final seller = json['seller'] is Map ? Map<String, dynamic>.from(json['seller']) : <String, dynamic>{};
    final community = seller['community'] is Map ? Map<String, dynamic>.from(seller['community']) : <String, dynamic>{};
    final park = community['national_park'] is Map ? Map<String, dynamic>.from(community['national_park']) : <String, dynamic>{};
    final country = community['country'] is Map ? Map<String, dynamic>.from(community['country']) : <String, dynamic>{};
    final allImages = ['featured','image_2','image_3'].map((key) => _secureImageUrl(imagesJson[key]?.toString() ?? '')).where((url) => url.isNotEmpty).toList();
    return CraftProduct(
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
    if (url.isEmpty) return Container(width: width, height: height, color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.image_outlined, color: AppColors.primary));
    return Image.network(url, width: width, height: height, fit: fit, errorBuilder: (_, __, ___) => Container(width: width, height: height, color: Colors.white, alignment: Alignment.center, child: const Icon(Icons.broken_image_outlined, color: AppColors.primary)));
  }
}
