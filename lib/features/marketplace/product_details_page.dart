import 'package:flutter/material.dart';

import 'marketplace_models.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  final MarketplaceProduct product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  static const Color _forest = Color(0xFF0B3B2E);
  static const Color _cream = Color(0xFFF6F3EC);
  static const Color _gold = Color(0xFFE2B84B);

  int _selectedImage = 0;

  List<String> get _images => [
        widget.product.featuredImage,
        if ((widget.product.image2 ?? '').trim().isNotEmpty)
          widget.product.image2!,
        if ((widget.product.image3 ?? '').trim().isNotEmpty)
          widget.product.image3!,
      ].where((image) => image.trim().isNotEmpty).toList();

  String _money(double value) {
    final raw = value.round().toString();
    final result = StringBuffer();

    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) result.write(',');
      result.write(raw[i]);
    }

    return 'UGX $result';
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = _images;

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: .95,
                    child: images.isEmpty
                        ? const _ImagePlaceholder()
                        : Image.network(
                            images[_selectedImage],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const _ImagePlaceholder(),
                          ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: Material(
                      color: Colors.white.withOpacity(.94),
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (images.length > 1) ...[
                      SizedBox(
                        height: 65,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 9),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedImage = index);
                              },
                              child: Container(
                                width: 65,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedImage == index
                                        ? _gold
                                        : const Color(0xFFE2DED4),
                                    width: _selectedImage == index ? 2 : 1,
                                  ),
                                ),
                                child: Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const _ImagePlaceholder(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                    Text(
                      product.categoryName.toUpperCase(),
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Color(0xFF17251F),
                        fontSize: 28,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _money(product.price),
                      style: const TextStyle(
                        color: _forest,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: _cream,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 19,
                            color: _forest,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            product.inStock
                                ? '${product.quantityAvailable} available'
                                : 'Currently sold out',
                            style: const TextStyle(
                              color: _forest,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (product.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 28),
                      const Text(
                        'About this craft',
                        style: TextStyle(
                          color: Color(0xFF17251F),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        product.description,
                        style: const TextStyle(
                          color: Color(0xFF68716C),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: product.inStock ? () {} : null,
              style: FilledButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                product.inStock ? 'Add to Cart' : 'Currently Unavailable',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFEAE7DE),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: Color(0xFF999D99),
        ),
      ),
    );
  }
}
