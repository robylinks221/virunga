import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../auth/auth_exception.dart';
import '../auth/auth_service.dart';
import 'marketplace_models.dart';

class MarketplaceService {
  const MarketplaceService({required this.authService});

  final AuthService authService;

  Future<List<MarketplaceCategory>> fetchCategories() async {
    final response = await authService.authenticatedGet(
      '/api/marketplace/categories/',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(_message(response.body, 'Could not load categories.'));
    }

    final decoded = jsonDecode(response.body);
    final list = decoded is List
        ? decoded
        : decoded is Map<String, dynamic> && decoded['results'] is List
            ? decoded['results'] as List
            : const [];

    return list
        .whereType<Map>()
        .map((e) => MarketplaceCategory.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.isActive)
        .toList();
  }

  Future<List<MarketplaceProduct>> fetchMyProducts() async {
    final response = await authService.authenticatedGet(
      '/api/marketplace/my-products/',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(_message(response.body, 'Could not load your products.'));
    }

    final decoded = jsonDecode(response.body);
    final list = decoded is List
        ? decoded
        : decoded is Map<String, dynamic> && decoded['results'] is List
            ? decoded['results'] as List
            : const [];

    return list
        .whereType<Map>()
        .map((e) => MarketplaceProduct.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<MarketplaceProduct> createProduct({
    required int categoryId,
    required String name,
    required String description,
    required String price,
    required int quantityAvailable,
    required String featuredImagePath,
    String? image2Path,
    String? image3Path,
  }) {
    return _submit(
      method: 'POST',
      path: '/api/marketplace/my-products/',
      fields: {
        'category': '$categoryId',
        'name': name.trim(),
        'description': description.trim(),
        'price': price,
        'quantity_available': '$quantityAvailable',
      },
      featuredImagePath: featuredImagePath,
      image2Path: image2Path,
      image3Path: image3Path,
    );
  }

  Future<MarketplaceProduct> updateProduct({
    required int productId,
    required int categoryId,
    required String name,
    required String description,
    required String price,
    required int quantityAvailable,
    String? featuredImagePath,
    String? image2Path,
    String? image3Path,
  }) {
    return _submit(
      method: 'PATCH',
      path: '/api/marketplace/my-products/$productId/',
      fields: {
        'category': '$categoryId',
        'name': name.trim(),
        'description': description.trim(),
        'price': price,
        'quantity_available': '$quantityAvailable',
      },
      featuredImagePath: featuredImagePath,
      image2Path: image2Path,
      image3Path: image3Path,
    );
  }

  Future<void> deleteProduct(int productId) async {
    final response = await authService.authenticatedDelete(
      '/api/marketplace/my-products/$productId/',
    );

    if (response.statusCode != 204 &&
        (response.statusCode < 200 || response.statusCode >= 300)) {
      throw AuthException(_message(response.body, 'Could not delete product.'));
    }
  }

  Future<MarketplaceProduct> _submit({
    required String method,
    required String path,
    required Map<String, String> fields,
    String? featuredImagePath,
    String? image2Path,
    String? image3Path,
  }) async {
    Future<http.Response> send() async {
      final token = await authService.getValidAccessToken();
      final request = http.MultipartRequest(method, ApiConfig.uri(path));
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields.addAll(fields);

      if (featuredImagePath != null && featuredImagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('featured_image', featuredImagePath),
        );
      }
      if (image2Path != null && image2Path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('image_2', image2Path),
        );
      }
      if (image3Path != null && image3Path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('image_3', image3Path),
        );
      }

      return http.Response.fromStream(await request.send());
    }

    var response = await send();
    if (response.statusCode == 401) {
      final ok = await authService.refreshAccessToken();
      if (!ok) {
        throw const AuthException('Your session has expired. Please log in again.');
      }
      response = await send();
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(_message(response.body, 'Could not save product.'));
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const AuthException('Unexpected product response from server.');
    }
    return MarketplaceProduct.fromJson(decoded);
  }

  static String _message(String raw, String fallback) {
    if (raw.trim().isEmpty) return fallback;
    try {
      final decoded = jsonDecode(raw);
      String? pick(dynamic v) {
        if (v is String && v.trim().isNotEmpty) return v.trim();
        if (v is List && v.isNotEmpty) return pick(v.first);
        if (v is Map) {
          for (final value in v.values) {
            final found = pick(value);
            if (found != null) return found;
          }
        }
        return null;
      }

      return pick(decoded) ?? fallback;
    } catch (_) {
      return fallback;
    }
  }
}
