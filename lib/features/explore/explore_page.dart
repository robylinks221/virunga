import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title will connect to its full page next.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.public_outlined, 'Countries', 'Uganda • Rwanda • DR Congo'),
      (Icons.landscape_outlined, 'Destinations', 'Protected landscapes'),
      (Icons.backpack_outlined, 'Porters', 'Destination support'),
      (Icons.shopping_basket_outlined, 'Crafts', 'Community marketplace'),
      (Icons.diversity_3_outlined, 'Community', 'Culture & heritage'),
      (Icons.eco_outlined, 'Conservation', 'Wildlife & habitats'),
      (Icons.shield_outlined, 'Rangers', 'Protection & verified statistics'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 90),
          children: [
            const Text(
              'EXPLORE GREATER VIRUNGA',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Discover the region.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Nature, culture, people and conservation across one connected landscape.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            TextField(
              readOnly: true,
              onTap: () => _comingSoon(context, 'Search'),
              decoration: InputDecoration(
                hintText: 'Where do you want to explore?',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 19),
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 185,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.public_outlined, color: AppColors.accent, size: 30),
                  Spacer(),
                  Text(
                    'ONE REGION • THREE COUNTRIES',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .8,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Nature. People. Place.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'DISCOVER',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () => _comingSoon(context, item.$2),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.$1, color: AppColors.primary, size: 21),
                        ),
                        const Spacer(),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.$3,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
