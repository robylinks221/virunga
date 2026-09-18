import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

import '../auth/auth_service.dart';
import 'marketplace_models.dart';
import 'marketplace_service.dart';
import 'product_form_page.dart';
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
  static const Color _forest = AppColors.primary;
  static const Color _cream = AppColors.background;
  static const Color _gold = AppColors.accent;

  final TextEditingController _searchController = TextEditingController();

  late final MarketplaceService _service;

  List<MarketplaceProduct> _products = const [];
  List<MarketplaceCategory> _categories = const [];

  bool _loading = true;
  String? _error;
  int? _selectedCategoryId;
  String _query = '';
  String _stockFilter = 'all';

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

      final matchesStock = switch (_stockFilter) {
        'in' => product.inStock && product.quantityAvailable > 2,
        'low' => product.inStock && product.quantityAvailable > 0 && product.quantityAvailable <= 2,
        'out' => !product.inStock || product.quantityAvailable <= 0,
        _ => true,
      };

      return matchesCategory && matchesSearch && matchesStock;
    }).toList();
  }

  Future<void> _addProduct() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductFormPage(authService: widget.authService),
      ),
    );
    if (result != null) await _load();
  }

  Future<void> _editProduct(MarketplaceProduct product) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          authService: widget.authService,
          product: product,
        ),
      ),
    );
    if (result != null) await _load();
  }

  Future<void> _deleteProduct(MarketplaceProduct product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete craft?'),
        content: Text('Delete “${product.name}”? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _service.deleteProduct(product.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Craft deleted.')));
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cleanError(e))));
    }
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
                  onAdd: _addProduct,
                  onChanged: (value) {
                    setState(() => _query = value);
                  },
                ),
              ),
              if (!_loading && _error == null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MANAGE INVENTORY', style: TextStyle(color: AppColors.accent, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                        const SizedBox(height: 5),
                        const Text('Your craft collection', style: TextStyle(color: AppColors.textPrimary, fontSize: 23, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            _StockChip(label: 'All', selected: _stockFilter == 'all', onTap: () => setState(() => _stockFilter = 'all')),
                            const SizedBox(width: 8),
                            _StockChip(label: 'In Stock', selected: _stockFilter == 'in', onTap: () => setState(() => _stockFilter = 'in')),
                            const SizedBox(width: 8),
                            _StockChip(label: 'Low Stock', selected: _stockFilter == 'low', onTap: () => setState(() => _stockFilter = 'low')),
                            const SizedBox(width: 8),
                            _StockChip(label: 'Out of Stock', selected: _stockFilter == 'out', onTap: () => setState(() => _stockFilter = 'out')),
                          ]),
                        ),
                        if (_categories.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 38,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _CategoryChip(label: 'All categories', selected: _selectedCategoryId == null, onTap: () => setState(() => _selectedCategoryId = null)),
                                ..._categories.where((item) => item.isActive).map((category) => Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: _CategoryChip(label: category.name, selected: _selectedCategoryId == category.id, onTap: () => setState(() => _selectedCategoryId = category.id)),
                                )),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 13),
                        Text('${products.length} craft${products.length == 1 ? '' : 's'}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
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

                        return Stack(
                          children: [
                            Positioned.fill(
                              child: MarketplaceProductCard(
                                product: product,
                                onTap: () => _editProduct(product),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: PopupMenuButton<String>(
                                color: Colors.white,
                                icon: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.more_horiz_rounded, color: AppColors.primary, size: 20),
                                ),
                                onSelected: (value) {
                                  if (value == 'edit') _editProduct(product);
                                  if (value == 'delete') _deleteProduct(product);
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 19), SizedBox(width: 10), Text('Edit craft')])),
                                  PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 19), SizedBox(width: 10), Text('Delete craft')])),
                                ],
                              ),
                            ),
                          ],
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
  const _MarketplaceHeader({required this.controller, required this.onAdd, required this.onChanged});
  final TextEditingController controller;
  final VoidCallback onAdd;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.background,
    padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('My Crafts', style: TextStyle(color: AppColors.primary, fontSize: 29, height: 1.05, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      const Text('Manage your products and grow your craft business.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
      const SizedBox(height: 18),
      SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.add_rounded, size: 23),
          label: const Text('Add New Craft', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search your crafts...',
          hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
        ),
      ),
    ]),
  );
}

class _StockChip extends StatelessWidget {
  const _StockChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    showCheckmark: false,
    onSelected: (_) => onTap(),
    selectedColor: AppColors.primary,
    backgroundColor: Colors.white,
    side: BorderSide(color: selected ? AppColors.primary : AppColors.cardBorder),
    labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
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
            : AppColors.cardBorder,
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textPrimary,
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
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 15),
          const Text(
            'Could not load products',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
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
            color: AppColors.textMuted,
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
