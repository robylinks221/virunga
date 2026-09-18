import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ExploreSectionPage extends StatelessWidget {
  const ExploreSectionPage({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    required this.icon,
    required this.items,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final IconData icon;
  final List<ExploreSectionItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 36),
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            height: 128,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 29),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'GREATER VIRUNGA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(item.icon, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                    size: 17,
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

class ExploreSectionItem {
  const ExploreSectionItem(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}

class CountriesPage extends StatelessWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreSectionPage(
      title: 'Explore by Country',
      eyebrow: 'THREE COUNTRIES • ONE REGION',
      subtitle: 'Discover the Greater Virunga landscape through Uganda, Rwanda and DR Congo.',
      icon: Icons.public_outlined,
      items: [
        ExploreSectionItem(Icons.flag_outlined, 'Uganda', 'Forests, savannah, mountains and communities'),
        ExploreSectionItem(Icons.flag_outlined, 'Rwanda', 'Volcanoes, mountain forests and culture'),
        ExploreSectionItem(Icons.flag_outlined, 'DR Congo', 'Virunga landscapes, forests and biodiversity'),
      ],
    );
  }
}

class DestinationsPage extends StatelessWidget {
  const DestinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreSectionPage(
      title: 'Destinations',
      eyebrow: 'PROTECTED LANDSCAPES',
      subtitle: 'Explore important natural destinations across the Greater Virunga region.',
      icon: Icons.landscape_outlined,
      items: [
        ExploreSectionItem(Icons.forest_outlined, 'Bwindi Impenetrable National Park', 'Uganda • Mountain forest'),
        ExploreSectionItem(Icons.terrain_outlined, 'Mgahinga Gorilla National Park', 'Uganda • Volcanoes and forest'),
        ExploreSectionItem(Icons.grass_outlined, 'Queen Elizabeth National Park', 'Uganda • Savannah and wildlife'),
        ExploreSectionItem(Icons.terrain_outlined, 'Volcanoes National Park', 'Rwanda • Mountain forests'),
        ExploreSectionItem(Icons.landscape_outlined, 'Virunga National Park', 'DR Congo • Mountains, forest and wildlife'),
        ExploreSectionItem(Icons.forest_outlined, 'Kahuzi-Biega National Park', 'DR Congo • Tropical forest'),
      ],
    );
  }
}

class PortersPage extends StatelessWidget {
  const PortersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreSectionPage(
      title: 'Porters',
      eyebrow: 'DESTINATION SUPPORT',
      subtitle: 'View porter information by destination. Verified totals will be shown when connected to live data.',
      icon: Icons.backpack_outlined,
      items: [
        ExploreSectionItem(Icons.backpack_outlined, 'Bwindi', 'Porters —'),
        ExploreSectionItem(Icons.backpack_outlined, 'Mgahinga', 'Porters —'),
        ExploreSectionItem(Icons.backpack_outlined, 'Volcanoes', 'Porters —'),
        ExploreSectionItem(Icons.backpack_outlined, 'Virunga', 'Porters —'),
      ],
    );
  }
}

class ConservationPage extends StatelessWidget {
  const ConservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreSectionPage(
      title: 'Conservation',
      eyebrow: 'PROTECTING THE REGION',
      subtitle: 'Learn about wildlife, habitats, protected landscapes and the people supporting conservation.',
      icon: Icons.eco_outlined,
      items: [
        ExploreSectionItem(Icons.pets_outlined, 'Wildlife', 'Species and biodiversity'),
        ExploreSectionItem(Icons.forest_outlined, 'Habitats', 'Forests, mountains and savannah'),
        ExploreSectionItem(Icons.landscape_outlined, 'Protected Landscapes', 'Places across the region'),
        ExploreSectionItem(Icons.shield_outlined, 'Rangers', 'Protection and verified statistics'),
      ],
    );
  }
}

class RangersPage extends StatelessWidget {
  const RangersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreSectionPage(
      title: 'Rangers',
      eyebrow: 'PROTECTION',
      subtitle: 'Ranger statistics by destination. The app will show verified totals rather than estimates.',
      icon: Icons.shield_outlined,
      items: [
        ExploreSectionItem(Icons.shield_outlined, 'Bwindi', 'Rangers —'),
        ExploreSectionItem(Icons.shield_outlined, 'Mgahinga', 'Rangers —'),
        ExploreSectionItem(Icons.shield_outlined, 'Volcanoes', 'Rangers —'),
        ExploreSectionItem(Icons.shield_outlined, 'Virunga', 'Rangers —'),
        ExploreSectionItem(Icons.shield_outlined, 'Kahuzi-Biega', 'Rangers —'),
      ],
    );
  }
}
