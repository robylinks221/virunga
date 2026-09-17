import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'marketplace_models.dart';
import 'marketplace_service.dart';
import 'product_details_page.dart';
import 'widgets/marketplace_product_card.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  static const Color _forest = Color(0xFF0B3B2E);
  static const Color _cream = Color(0xFFF6F3EC);
  static const Color _gold = Color(0xFFE2B84B);

  final TextEditingController _searchController = TextEditingController();

  late final MarketplaceService _service;

  List<MarketplaceProduct> _products = const [];
  List<MarketplaceCategory> _categories = const [];

  bool _loading = true;
  String? _error;
  int? _selectedCategoryId;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _service = MarketplaceService(authService: widget.authService);
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final results = await Future.wait([
        _service.fetchMyProducts(),
        _service.fetchCategories(),
      ]);

      if (!mounted) return;

      setState(() {
        _products = results[0] as List<MarketplaceProduct>;
        _categories = results[1] as List<MarketplaceCategory>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = _cleanError(e);
      });
    }
  }

  String _cleanError(Object error) {
    final text = error.toString().trim();
    if (text.startsWith('AuthException: ')) {
      return text.substring('AuthException: '.length);
    }
    if (text.startsWith('Exception: ')) {
      return text.substring('Exception: '.length);
    }
    return text.isEmpty ? 'Could not load marketplace products.' : text;
  }

  List<MarketplaceProduct> get _visibleProducts {
    final query = _query.trim().toLowerCase();

    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == null ||
          product.categoryId == _selectedCategoryId;

      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.categoryName.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openProduct(MarketplaceProduct product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _MarketplaceHeader(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _query = value);
                  },
                ),
              ),
              if (!_loading && _error == null && _categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 62,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 11,
                      ),
                      children: [
                        _CategoryChip(
                          label: 'All',
                          selected: _selectedCategoryId == null,
                          onTap: () {
                            setState(() => _selectedCategoryId = null);
                          },
                        ),
                        ..._categories.where((c) => c.isActive).map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _CategoryChip(
                                  label: category.name,
                                  selected:
                                      _selectedCategoryId == category.id,
                                  onTap: () {
                                    setState(
                                      () =>
                                          _selectedCategoryId = category.id,
                                    );
                                  },
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              if (!_loading && _error == null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DISCOVER',
                                style: TextStyle(
                                  color: _gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.7,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Local Crafts',
                                style: TextStyle(
                                  color: Color(0xFF17251F),
                                  fontSize: 24,
                                  height: 1,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${products.length} product${products.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Color(0xFF737A75),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _LoadingState(),
                )
              else if (_error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(
                    message: _error!,
                    onRetry: _load,
                  ),
                )
              else if (products.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    filtered: _products.isNotEmpty,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                      childAspectRatio: .63,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];

                        return MarketplaceProductCard(
                          product: product,
                          onTap: () => _openProduct(product),
                        );
                      },
                      childCount: products.length,
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

class _MarketplaceHeader extends StatelessWidget {
  const _MarketplaceHeader({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _MarketplacePageState._forest,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marketplace',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Authentic crafts from local communities',
            style: TextStyle(
              color: Colors.white.withOpacity(.72),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search handmade products...',
              hintStyle: const TextStyle(
                color: Color(0xFF7C837F),
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF55625C),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      label: Text(label),
      selectedColor: _MarketplacePageState._forest,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected
            ? _MarketplacePageState._forest
            : const Color(0xFFE0DCD2),
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF3D4843),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: _MarketplacePageState._forest,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: Color(0xFF7D857F),
          ),
          const SizedBox(height: 15),
          const Text(
            'Could not load products',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF24342D),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF777E79),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: _MarketplacePageState._forest,
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.filtered,
  });

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 54,
            color: Color(0xFF8D958F),
          ),
          const SizedBox(height: 16),
          Text(
            filtered ? 'No matching products' : 'No products yet',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF24342D),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            filtered
                ? 'Try another search or product category.'
                : 'Products added by this seller will appear here.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF777E79),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
