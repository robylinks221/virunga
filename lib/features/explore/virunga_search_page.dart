import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../community/community_page.dart';
import '../marketplace/public_marketplace_page.dart';
import 'country_destination_detail_pages.dart';
import 'explore_section_pages.dart';

class VirungaSearchPage extends StatefulWidget {
  const VirungaSearchPage({super.key});

  @override
  State<VirungaSearchPage> createState() => _VirungaSearchPageState();
}

class _VirungaSearchPageState extends State<VirungaSearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  List<_SearchItem> get _items => [
    _SearchItem('Uganda', 'Country', 'Forests, savannah and mountain landscapes', Icons.public_outlined, () => _open(CountryDetailPage(country: 'Uganda'))),
    _SearchItem('Rwanda', 'Country', 'Volcanoes, mountain forests and culture', Icons.public_outlined, () => _open(CountryDetailPage(country: 'Rwanda'))),
    _SearchItem('DR Congo', 'Country', 'Virunga landscapes and biodiversity', Icons.public_outlined, () => _open(CountryDetailPage(country: 'DR Congo'))),
    _SearchItem('Bwindi Impenetrable National Park', 'Destination', 'Uganda • Mountain forest', Icons.forest_outlined, () => _open(const DestinationDetailPage(name: 'Bwindi Impenetrable National Park', country: 'Uganda'))),
    _SearchItem('Mgahinga Gorilla National Park', 'Destination', 'Uganda • Volcanoes and forest', Icons.terrain_outlined, () => _open(const DestinationDetailPage(name: 'Mgahinga Gorilla National Park', country: 'Uganda'))),
    _SearchItem('Queen Elizabeth National Park', 'Destination', 'Uganda • Savannah and wildlife', Icons.grass_outlined, () => _open(const DestinationDetailPage(name: 'Queen Elizabeth National Park', country: 'Uganda'))),
    _SearchItem('Volcanoes National Park', 'Destination', 'Rwanda • Mountain forests', Icons.terrain_outlined, () => _open(const DestinationDetailPage(name: 'Volcanoes National Park', country: 'Rwanda'))),
    _SearchItem('Virunga National Park', 'Destination', 'DR Congo • Mountains, forest and wildlife', Icons.landscape_outlined, () => _open(const DestinationDetailPage(name: 'Virunga National Park', country: 'DR Congo'))),
    _SearchItem('Kahuzi-Biega National Park', 'Destination', 'DR Congo • Tropical forest', Icons.forest_outlined, () => _open(const DestinationDetailPage(name: 'Kahuzi-Biega National Park', country: 'DR Congo'))),
    _SearchItem('Porters', 'People', 'Destination support across Greater Virunga', Icons.backpack_outlined, () => _open(const PortersPage())),
    _SearchItem('Rangers', 'Conservation', 'People protecting the region', Icons.shield_outlined, () => _open(const RangersPage())),
    _SearchItem('Conservation', 'Nature', 'Wildlife, habitats and protected landscapes', Icons.eco_outlined, () => _open(const ConservationPage())),
    _SearchItem('Community & Culture', 'Heritage', 'Traditions, creativity and communities', Icons.diversity_3_outlined, () => _open(const CommunityPage())),
    _SearchItem('Crafts & Artisans', 'Marketplace', 'Authentic crafts from Greater Virunga', Icons.shopping_basket_outlined, () => _open(const PublicMarketplacePage())),
  ];

  void _open(Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty ? _items : _items.where((item) =>
      item.title.toLowerCase().contains(q) ||
      item.category.toLowerCase().contains(q) ||
      item.subtitle.toLowerCase().contains(q)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SEARCH GREATER VIRUNGA', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                const SizedBox(height: 6),
                const Text('What would you like to discover?', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search places, culture, crafts...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                    suffixIcon: _query.isEmpty ? null : IconButton(
                      onPressed: () { _controller.clear(); setState(() => _query = ''); },
                      icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 34),
              children: [
                Row(
                  children: [
                    Text(q.isEmpty ? 'DISCOVER' : 'RESULTS', style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                    const Spacer(),
                    Text('${results.length}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                if (results.isEmpty)
                  const _EmptySearch()
                else
                  ...results.map((item) => _SearchCard(item: item)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.item});
  final _SearchItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.cardBorder)),
          child: Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(13)),
                child: Icon(item.icon, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.category.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 8.5, fontWeight: FontWeight.w700, letterSpacing: .7)),
                  const SizedBox(height: 3),
                  Text(item.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, height: 1.3)),
                ],
              )),
              const Icon(Icons.arrow_outward_rounded, color: AppColors.primary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.cardBorder)),
      child: const Column(
        children: [
          Icon(Icons.travel_explore_rounded, color: AppColors.primary, size: 34),
          SizedBox(height: 12),
          Text('No matches yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
          SizedBox(height: 5),
          Text('Try a country, destination, conservation, culture or crafts.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }
}

class _SearchItem {
  const _SearchItem(this.title, this.category, this.subtitle, this.icon, this.onTap);
  final String title;
  final String category;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}
