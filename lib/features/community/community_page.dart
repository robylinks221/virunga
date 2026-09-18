import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../marketplace/public_marketplace_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      const _CultureItem(
        Icons.groups_outlined,
        'Traditional Dance',
        'Movement, ceremony and community expression',
        'assets/images/onboarding_community.jpg',
      ),
      const _CultureItem(
        Icons.music_note_outlined,
        'Music & Performance',
        'Traditional sound, rhythm and performance',
        'assets/images/onboarding_landscape.jpg',
      ),
      const _CultureItem(
        Icons.auto_stories_outlined,
        'Stories & Heritage',
        'Oral traditions, memory and identity',
        'assets/images/onboarding_wildlife.jpg',
      ),
      _CultureItem(
        Icons.shopping_basket_outlined,
        'Craft & Making',
        'Skills and creativity passed through generations',
        'assets/images/crafts_beaded_sandals.jpg',
        onTap: () => _open(context, const PublicMarketplacePage()),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LIVING HERITAGE',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Community & Culture',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Meet the traditions, creativity and communities connected to Greater Virunga.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.72),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _CultureHero()),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRADITION & CREATIVITY',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Living culture',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _CultureCard(item: sections[index]),
                  childCount: sections.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
                child: InkWell(
                  onTap: () => _open(context, const PublicMarketplacePage()),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.shopping_basket_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CRAFTS & ARTISANS',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Discover local making',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_outward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CultureHero extends StatelessWidget {
  const _CultureHero();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Container(
        height: 225,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/onboarding_community.jpg',
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x05000000), Color(0xDD000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.94),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.diversity_3_outlined,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'PEOPLE • CULTURE • PLACE',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Culture lives with the people.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Stories, skills and traditions carried from one generation to the next.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.76),
                      fontSize: 11,
                      height: 1.35,
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

class _CultureCard extends StatelessWidget {
  const _CultureCard({required this.item});

  final _CultureItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.image, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0x75000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    top: 11,
                    child: Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.94),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 11, 10, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 9.5,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.onTap != null) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_outward_rounded,
                      color: AppColors.primary,
                      size: 17,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CultureItem {
  const _CultureItem(
    this.icon,
    this.title,
    this.subtitle,
    this.image, {
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback? onTap;
}
