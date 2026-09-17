import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../marketplace_models.dart';

class MarketplaceProductCard extends StatelessWidget {
  const MarketplaceProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final MarketplaceProduct product;
  final VoidCallback onTap;

  String _money(double value) {
    final raw = value.round().toString();
    final result = StringBuffer();

    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) result.write(',');
      result.write(raw[i]);
    }

    return 'UGX $result';
  }

  Widget _productImage() {
    final url = product.featuredImage.trim();

    if (url.isEmpty) {
      debugPrint(
        'VIRUNGA IMAGE EMPTY | product="${product.name}" | featured_image is empty',
      );
      return const _ImagePlaceholder();
    }

    debugPrint(
      'VIRUNGA IMAGE REQUEST | product="${product.name}" | url=$url',
    );

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          debugPrint(
            'VIRUNGA IMAGE LOADED | product="${product.name}" | url=$url',
          );
          return child;
        }

        return const ColoredBox(
          color: Color(0xFFEAE7DE),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF0B3B2E),
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('!!!!!!!!!! VIRUNGA IMAGE FAILED !!!!!!!!!!');
        debugPrint('PRODUCT: ${product.name}');
        debugPrint('URL: $url');
        debugPrint('ERROR: $error');
        debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

        return const _ImagePlaceholder(
          failed: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _productImage(),
                  Positioned(
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.inStock ? 'IN STOCK' : 'SOLD OUT',
                        style: const TextStyle(
                          color: Color(0xFF0B3B2E),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.categoryName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF777E79),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .6,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF17251F),
                      fontSize: 14,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _money(product.price),
                    style: const TextStyle(
                      color: Color(0xFF0B3B2E),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.inStock
                        ? '${product.quantityAvailable} available'
                        : 'Sold out',
                    style: const TextStyle(
                      color: Color(0xFF777E79),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({
    this.failed = false,
  });

  final bool failed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFEAE7DE),
      child: Center(
        child: Icon(
          failed ? Icons.broken_image_outlined : Icons.image_outlined,
          size: 38,
          color: const Color(0xFF999D99),
        ),
      ),
    );
  }
}
