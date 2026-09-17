import 'package:flutter/foundation.dart';

import '../../core/api/api_config.dart';

class MarketplaceCategory {
  const MarketplaceCategory({
    required this.id,
    required this.name,
    required this.isActive,
  });

  final int id;
  final String name;
  final bool isActive;

  factory MarketplaceCategory.fromJson(Map<String, dynamic> json) {
    return MarketplaceCategory(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      isActive: json['is_active'] != false,
    );
  }
}

class MarketplaceProduct {
  const MarketplaceProduct({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.quantityAvailable,
    required this.inStock,
    required this.featuredImage,
    this.image2,
    this.image3,
  });

  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final double price;
  final int quantityAvailable;
  final bool inStock;
  final String featuredImage;
  final String? image2;
  final String? image3;

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? '';

    final rawFeatured = json['featured_image']?.toString();
    final rawImage2 = json['image_2']?.toString();
    final rawImage3 = json['image_3']?.toString();

    final featured = _normaliseImageUrl(rawFeatured);
    final image2 = _normaliseOptionalImageUrl(rawImage2);
    final image3 = _normaliseOptionalImageUrl(rawImage3);

    debugPrint('========== VIRUNGA MARKETPLACE PRODUCT ==========');
    debugPrint('PRODUCT: $name');
    debugPrint('RAW featured_image: $rawFeatured');
    debugPrint('FINAL featured_image: $featured');
    debugPrint('RAW image_2: $rawImage2');
    debugPrint('FINAL image_2: $image2');
    debugPrint('RAW image_3: $rawImage3');
    debugPrint('FINAL image_3: $image3');
    debugPrint('=================================================');

    return MarketplaceProduct(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      categoryId: int.tryParse(json['category']?.toString() ?? '') ?? 0,
      categoryName: json['category_name']?.toString() ?? '',
      name: name,
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      quantityAvailable:
          int.tryParse(json['quantity_available']?.toString() ?? '') ?? 0,
      inStock: json['in_stock'] == true,
      featuredImage: featured,
      image2: image2,
      image3: image3,
    );
  }

  static String _normaliseImageUrl(dynamic value) {
    final raw = value?.toString().trim() ?? '';

    if (raw.isEmpty || raw.toLowerCase() == 'null') {
      return '';
    }

    final parsed = Uri.tryParse(raw);

    if (parsed != null && parsed.hasScheme) {
      return raw;
    }

    if (raw.startsWith('//')) {
      return 'https:$raw';
    }

    if (raw.startsWith('/')) {
      return '${ApiConfig.baseUrl}$raw';
    }

    return '${ApiConfig.baseUrl}/$raw';
  }

  static String? _normaliseOptionalImageUrl(dynamic value) {
    final url = _normaliseImageUrl(value);
    return url.isEmpty ? null : url;
  }
}
