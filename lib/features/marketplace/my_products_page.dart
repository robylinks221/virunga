import 'package:flutter/material.dart';

import '../auth/auth_exception.dart';
import '../auth/auth_service.dart';
import 'marketplace_models.dart';
import 'marketplace_service.dart';
import 'product_form_page.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  static const Color _forest = Color(0xFF0B3B2E);
  static const Color _forestDeep = Color(0xFF06281F);
  static const Color _gold = Color(0xFFD7A845);
  static const Color _cream = Color(0xFFF6F3EC);

  late final MarketplaceService _service;

  bool _loading = true;
  String? _error;
  List<MarketplaceProduct> _products = const [];

  @override
  void initState() {
    super.initState();
    _service = MarketplaceService(authService: widget.authService);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final products = await _service.fetchMyProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
        _loading = false;
      });
    } on AuthException catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'Could not load your products.';
        _loading = false;
      });
    }
  }

  Future<void> _openCreate() async {
    final result = await Navigator.push<MarketplaceProduct>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          authService: widget.authService,
        ),
      ),
    );

    if (result != null) {
      await _load();
    }
  }

  Future<void> _openEdit(MarketplaceProduct product) async {
    final result = await Navigator.push<MarketplaceProduct>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          authService: widget.authService,
          product: product,
        ),
      ),
    );

    if (result != null) {
      await _load();
    }
  }

  Future<void> _delete(MarketplaceProduct product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete product?'),
          content: Text(
            'Delete "${product.name}" from your products? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF9A3333),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await _service.deleteProduct(product.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _forest,
          content: Text('Product deleted.'),
        ),
      );

      await _load();
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF8C2D2D),
          content: Text(error.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _forestDeep,
        foregroundColor: Colors.white,
        title: const Text(
          'My Craft Products',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        backgroundColor: _gold,
        foregroundColor: const Color(0xFF11130F),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 220),
          Center(
            child: CircularProgressIndicator(
              color: _forest,
            ),
          ),
        ],
      );
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 100),
          const Icon(
            Icons.cloud_off_outlined,
            size: 50,
            color: _forest,
          ),
          const SizedBox(height: 14),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: FilledButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ),
        ],
      );
    }

    if (_products.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Container(
            width: 86,
            height: 86,
            margin: const EdgeInsets.symmetric(horizontal: 110),
            decoration: BoxDecoration(
              color: _forest.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: _forest,
              size: 40,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No products yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first craft product and make it ready for buyers to discover.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6F7974),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: FilledButton.icon(
              onPressed: _openCreate,
              style: FilledButton.styleFrom(
                backgroundColor: _forest,
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Product'),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
      itemCount: _products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = _products[index];

        return _ProductCard(
          product: product,
          onEdit: () => _openEdit(product),
          onDelete: () => _delete(product),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final MarketplaceProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _money(double value) {
    final raw = value.round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < raw.length; i++) {
      final reverseIndex = raw.length - i;
      buffer.write(raw[i]);

      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE0E3E0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 116,
            child: product.featuredImage.isEmpty
                ? const ColoredBox(
                    color: Color(0xFFEAEDEB),
                    child: Icon(
                      Icons.image_outlined,
                      color: Color(0xFF6F7974),
                    ),
                  )
                : Image.network(
                    product.featuredImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const ColoredBox(
                        color: Color(0xFFEAEDEB),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Color(0xFF6F7974),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF17211D),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') onEdit();
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined),
                                SizedBox(width: 9),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFF9A3333),
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Color(0xFF9A3333),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.categoryName,
                    style: const TextStyle(
                      color: Color(0xFF6F7974),
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'UGX ${_money(product.price)}',
                    style: const TextStyle(
                      color: Color(0xFF0B3B2E),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: product.inStock
                              ? const Color(0xFFE5F4E9)
                              : const Color(0xFFF7E7E7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          product.inStock ? 'In stock' : 'Out of stock',
                          style: TextStyle(
                            color: product.inStock
                                ? const Color(0xFF28643A)
                                : const Color(0xFF913838),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${product.quantityAvailable} available',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF6F7974),
                            fontSize: 11.5,
                          ),
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
    );
  }
}
