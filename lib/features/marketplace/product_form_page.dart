import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/auth_exception.dart';
import '../auth/auth_service.dart';
import 'marketplace_models.dart';
import 'marketplace_service.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({
    super.key,
    required this.authService,
    this.product,
  });

  final AuthService authService;
  final MarketplaceProduct? product;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  static const _forest = Color(0xFF0B3B2E);
  static const _forestDeep = Color(0xFF06281F);
  static const _gold = Color(0xFFD7A845);
  static const _cream = Color(0xFFF6F3EC);
  static const _muted = Color(0xFF6F7974);
  static const _maxImageBytes = 5 * 1024 * 1024;

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();
  final _picker = ImagePicker();

  late final MarketplaceService _service;
  List<MarketplaceCategory> _categories = const [];
  MarketplaceCategory? _category;
  XFile? _featured;

  bool _loadingCategories = true;
  bool _saving = false;
  String? _categoryError;

  bool get _editing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _service = MarketplaceService(authService: widget.authService);
    final p = widget.product;
    if (p != null) {
      _name.text = p.name;
      _description.text = p.description;
      _price.text = p.price == p.price.roundToDouble()
          ? p.price.toStringAsFixed(0)
          : p.price.toStringAsFixed(2);
      _quantity.text = p.quantityAvailable.toString();
    } else {
      _quantity.text = '1';
    }
    _loadCategories();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _quantity.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final items = await _service.fetchCategories();
      MarketplaceCategory? selected;
      if (widget.product != null) {
        for (final item in items) {
          if (item.id == widget.product!.categoryId) {
            selected = item;
            break;
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _categories = items;
        _category = selected;
        _loadingCategories = false;
        _categoryError = items.isEmpty ? 'No active categories are available.' : null;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCategories = false;
        _categoryError = e.message;
      });
    }
  }

  Future<void> _pick(int slot) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 2200,
    );
    if (image == null) return;
    if (await image.length() > _maxImageBytes) {
      _snack('Image must be 5MB or smaller.', error: true);
      return;
    }
    if (!mounted) return;
    setState(() {
      if (slot == 1) _featured = image;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (_category == null) {
      setState(() => _categoryError = 'Select a category.');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_editing && _featured == null) {
      _snack('Add the main product photo.', error: true);
      return;
    }

    setState(() => _saving = true);
    try {
      final amount = double.parse(_price.text.replaceAll(',', '').trim());
      final qty = int.parse(_quantity.text.trim());
      final saved = _editing
          ? await _service.updateProduct(
              productId: widget.product!.id,
              categoryId: _category!.id,
              name: _name.text,
              description: _description.text,
              price: amount.toStringAsFixed(2),
              quantityAvailable: qty,
              featuredImagePath: _featured?.path,
            )
          : await _service.createProduct(
              categoryId: _category!.id,
              name: _name.text,
              description: _description.text,
              price: amount.toStringAsFixed(2),
              quantityAvailable: qty,
              featuredImagePath: _featured!.path,
            );

      if (!mounted) return;
      Navigator.pop(context, saved);
    } on AuthException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (_) {
      if (mounted) _snack('Could not save this product.', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String text, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? const Color(0xFF8C2D2D) : _forest,
          content: Text(text),
        ),
      );
  }

  InputDecoration _decoration(String hint, {String? errorText, String? prefixText}) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD9DDD9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _gold, width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _forestDeep,
        foregroundColor: Colors.white,
        title: Text(
          _editing ? 'Edit Product' : 'Create Product',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_forest, Color(0xFF155340)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _gold.withOpacity(.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.handyman_outlined, color: Color(0xFFF0C96B)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _editing ? 'Update your craft' : 'Add a craft to your shop',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _editing
                              ? 'Change only what you need, then save.'
                              : 'Use clear photos and simple details buyers can understand.',
                          style: const TextStyle(color: Color(0xFFD2DAD6), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Product Photos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            const Text('Each craft uses one clear product photo.', style: TextStyle(color: _muted)),
            const SizedBox(height: 14),
            _PhotoTile(
              title: 'Main Photo *',
              height: 220,
              local: _featured,
              network: _featured == null ? widget.product?.featuredImage : null,
              onTap: _saving ? null : () => _pick(1),
            ),
            const SizedBox(height: 28),
            const Text('Product Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _label('Product Name *'),
            TextFormField(
              controller: _name,
              maxLength: 150,
              textInputAction: TextInputAction.next,
              decoration: _decoration('e.g. Handwoven Gorilla Basket'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter product name.' : null,
            ),
            const SizedBox(height: 12),
            _label('Category *'),
            if (_loadingCategories)
              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD9DDD9)),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('Loading categories...'),
                  ],
                ),
              )
            else
              DropdownButtonFormField<MarketplaceCategory>(
                value: _category,
                isExpanded: true,
                decoration: _decoration('Select category', errorText: _categoryError),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: _saving
                    ? null
                    : (v) => setState(() {
                          _category = v;
                          _categoryError = null;
                        }),
              ),
            const SizedBox(height: 18),
            _label('Description'),
            TextFormField(
              controller: _description,
              minLines: 4,
              maxLines: 7,
              decoration: _decoration('Materials, size, colours, how it is made, or cultural meaning.'),
            ),
            const SizedBox(height: 24),
            const Text('Price & Stock', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _label('Price *'),
            TextFormField(
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: _decoration('25000', prefixText: 'UGX  '),
              validator: (v) {
                final n = double.tryParse((v ?? '').replaceAll(',', '').trim());
                return n == null || n <= 0 ? 'Enter a price greater than 0.' : null;
              },
            ),
            const SizedBox(height: 18),
            _label('Quantity Available *'),
            TextFormField(
              controller: _quantity,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _decoration('0'),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                return n == null || n < 0 ? 'Enter a whole number of 0 or more.' : null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 58,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : Text(
                        _editing ? 'Save Changes' : 'Publish Product',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.title,
    required this.height,
    required this.local,
    required this.network,
    required this.onTap,
  });

  final String title;
  final double height;
  final XFile? local;
  final String? network;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasNetwork = network != null && network!.trim().isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD9DDD9)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (local != null)
              Image.file(File(local!.path), fit: BoxFit.cover)
            else if (hasNetwork)
              Image.network(
                network!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined, size: 34, color: Color(0xFF0B3B2E)),
                    const SizedBox(height: 8),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    const Text('Tap to choose • Max 5MB', style: TextStyle(color: Color(0xFF6F7974), fontSize: 11)),
                  ],
                ),
              ),
            if (local != null || hasNetwork)
              Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.66),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.5)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
