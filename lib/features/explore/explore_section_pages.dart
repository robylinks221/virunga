import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'country_destination_detail_pages.dart';

class ExploreSectionPage extends StatelessWidget {
  const ExploreSectionPage({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    required this.icon,
    required this.items,
    this.onItem,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final IconData icon;
  final List<ExploreSectionItem> items;
  final void Function(ExploreSectionItem)? onItem;

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
            (item) => InkWell(
              onTap: onItem == null ? null : () => onItem!(item),
              borderRadius: BorderRadius.circular(17),
              child: Container(
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
    const countries = [
      _CountryCardData(
        'Uganda',
        'The Pearl of Africa',
        'Forests, savannah, mountains and communities',
        'assets/images/onboarding_landscape.jpg',
      ),
      _CountryCardData(
        'Rwanda',
        'Land of a Thousand Hills',
        'Volcanoes, mountain forests and living culture',
        'assets/images/onboarding_wildlife.jpg',
      ),
      _CountryCardData(
        'DR Congo',
        'Extraordinary Wild Landscapes',
        'Virunga landscapes, forests and biodiversity',
        'assets/images/onboarding_community.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Explore by Country',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GREATER VIRUNGA',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Three countries.\nOne connected region.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      height: 1.08,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Explore the landscapes, people and protected places of Uganda, Rwanda and DR Congo.',
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
          SliverToBoxAdapter(
            child: SizedBox(
              height: 286,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: countries.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return _CountryDiscoveryCard(
                    country: country,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CountryDetailPage(country: country.name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DISCOVER THE REGION',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Choose your starting point',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
            sliver: SliverList.separated(
              itemCount: countries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final country = countries[index];
                return _CountryListCard(
                  country: country,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CountryDetailPage(country: country.name),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryDiscoveryCard extends StatelessWidget {
  const _CountryDiscoveryCard({required this.country, required this.onTap});
  final _CountryCardData country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 218,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(country.image, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x08000000), Color(0xE6000000)],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      country.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .9,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      country.tagline,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.82),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryListCard extends StatelessWidget {
  const _CountryListCard({required this.country, required this.onTap});
  final _CountryCardData country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                country.image,
                width: 78,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    country.tagline,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    country.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class DestinationsPage extends StatelessWidget {
  const DestinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const destinations = [
      _DestinationCardData('Bwindi Impenetrable National Park', 'Uganda', 'Mountain forest', 'assets/images/onboarding_wildlife.jpg'),
      _DestinationCardData('Mgahinga Gorilla National Park', 'Uganda', 'Volcanoes and forest', 'assets/images/onboarding_landscape.jpg'),
      _DestinationCardData('Queen Elizabeth National Park', 'Uganda', 'Savannah and wildlife', 'assets/images/onboarding_community.jpg'),
      _DestinationCardData('Volcanoes National Park', 'Rwanda', 'Mountain forests', 'assets/images/onboarding_landscape.jpg'),
      _DestinationCardData('Virunga National Park', 'DR Congo', 'Mountains, forest and wildlife', 'assets/images/onboarding_wildlife.jpg'),
      _DestinationCardData('Kahuzi-Biega National Park', 'DR Congo', 'Tropical forest', 'assets/images/onboarding_community.jpg'),
    ];

    return _PhotoCollectionPage(
      eyebrow: 'PROTECTED LANDSCAPES',
      title: 'Destinations',
      subtitle:
          'Explore important natural destinations across the Greater Virunga region.',
      heroImage: 'assets/images/onboarding_wildlife.jpg',
      heroLabel: 'DISCOVER THE WILD',
      heroTitle: 'Forests, volcanoes, savannah and wildlife.',
      children: destinations
          .map(
            (destination) => _WidePhotoCard(
              image: destination.image,
              eyebrow: destination.country.toUpperCase(),
              title: destination.name,
              subtitle: destination.landscape,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DestinationDetailPage(
                    name: destination.name,
                    country: destination.country,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PhotoCollectionPage extends StatelessWidget {
  const _PhotoCollectionPage({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.heroImage,
    required this.heroLabel,
    required this.heroTitle,
    required this.children,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String heroImage;
  final String heroLabel;
  final String heroTitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.72),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Container(
              height: 205,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(heroImage, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x08000000), Color(0xD9000000)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          heroLabel,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          heroTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 27, 20, 13),
            child: Text(
              'EXPLORE',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _WidePhotoCard extends StatelessWidget {
  const _WidePhotoCard({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String image;
  final String eyebrow;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 190,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(image, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xE0000000)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      eyebrow.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  height: 1.15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.76),
                                  fontSize: 10.5,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.94),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryCardData {
  const _CountryCardData(this.name, this.tagline, this.description, this.image);
  final String name;
  final String tagline;
  final String description;
  final String image;
}

class _DestinationCardData {
  const _DestinationCardData(this.name, this.country, this.landscape, this.image);
  final String name;
  final String country;
  final String landscape;
  final String image;
}

class PortersPage extends StatelessWidget {
  const PortersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PeopleLandscapePage(
      eyebrow: 'DESTINATION SUPPORT',
      title: 'Porters',
      subtitle: 'Meet the people who support journeys across the mountain and forest destinations of Greater Virunga.',
      heroImage: 'assets/images/onboarding_community.jpg',
      heroLabel: 'PEOPLE OF THE LANDSCAPE',
      heroTitle: 'Local knowledge. Strength. Support.',
      introTitle: 'Porters by Destination',
      introText: 'Verified porter information will appear by destination when live data is connected.',
      icon: Icons.backpack_outlined,
      entries: [
        _PeopleEntry('Bwindi', 'Uganda', 'Porters —'),
        _PeopleEntry('Mgahinga', 'Uganda', 'Porters —'),
        _PeopleEntry('Volcanoes', 'Rwanda', 'Porters —'),
        _PeopleEntry('Virunga', 'DR Congo', 'Porters —'),
      ],
    );
  }
}

class ConservationPage extends StatelessWidget {
  const ConservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PeopleLandscapePage(
      eyebrow: 'PROTECTING THE REGION',
      title: 'Conservation',
      subtitle: 'Explore the wildlife, habitats and protected landscapes that make Greater Virunga extraordinary.',
      heroImage: 'assets/images/onboarding_wildlife.jpg',
      heroLabel: 'A SHARED WILD LANDSCAPE',
      heroTitle: 'Protecting nature across borders.',
      introTitle: 'Conservation Focus',
      introText: 'Discover the natural systems and people at the heart of conservation across the region.',
      icon: Icons.eco_outlined,
      entries: [
        _PeopleEntry('Wildlife', 'Greater Virunga', 'Species and biodiversity'),
        _PeopleEntry('Habitats', 'Greater Virunga', 'Forests, mountains and savannah'),
        _PeopleEntry('Protected Landscapes', 'Uganda • Rwanda • DR Congo', 'Connected places across the region'),
        _PeopleEntry('Rangers', 'Greater Virunga', 'Protection and verified statistics'),
      ],
    );
  }
}

class RangersPage extends StatelessWidget {
  const RangersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PeopleLandscapePage(
      eyebrow: 'PROTECTION',
      title: 'Rangers',
      subtitle: 'Explore ranger information across the protected landscapes of Greater Virunga.',
      heroImage: 'assets/images/onboarding_landscape.jpg',
      heroLabel: 'PROTECTING THE WILD',
      heroTitle: 'People on the front line of conservation.',
      introTitle: 'Rangers by Destination',
      introText: 'Only verified ranger totals will be displayed when live information is connected.',
      icon: Icons.shield_outlined,
      entries: [
        _PeopleEntry('Bwindi', 'Uganda', 'Rangers —'),
        _PeopleEntry('Mgahinga', 'Uganda', 'Rangers —'),
        _PeopleEntry('Volcanoes', 'Rwanda', 'Rangers —'),
        _PeopleEntry('Virunga', 'DR Congo', 'Rangers —'),
        _PeopleEntry('Kahuzi-Biega', 'DR Congo', 'Rangers —'),
      ],
    );
  }
}

class _PeopleLandscapePage extends StatelessWidget {
  const _PeopleLandscapePage({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.heroImage,
    required this.heroLabel,
    required this.heroTitle,
    required this.introTitle,
    required this.introText,
    required this.icon,
    required this.entries,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String heroImage;
  final String heroLabel;
  final String heroTitle;
  final String introTitle;
  final String introText;
  final IconData icon;
  final List<_PeopleEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eyebrow, style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 27, height: 1.1, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 12, height: 1.5)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Container(
              height: 215,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(heroImage, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x08000000), Color(0xD9000000)],
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
                          decoration: BoxDecoration(color: Colors.white.withOpacity(.94), borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, color: AppColors.primary, size: 21),
                        ),
                        const Spacer(),
                        Text(heroLabel, style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                        const SizedBox(height: 5),
                        Text(heroTitle, style: const TextStyle(color: Colors.white, fontSize: 20, height: 1.15, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 27, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EXPLORE', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                const SizedBox(height: 5),
                Text(introTitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(introText, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
          ...entries.map((entry) => _PeopleEntryCard(entry: entry, icon: icon)),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _PeopleEntryCard extends StatelessWidget {
  const _PeopleEntryCard({required this.entry, required this.icon});

  final _PeopleEntry entry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 11),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(entry.location, style: const TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(entry.value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5, height: 1.3)),
              ],
            ),
          ),
          const Icon(Icons.arrow_outward_rounded, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}

class _PeopleEntry {
  const _PeopleEntry(this.title, this.location, this.value);
  final String title;
  final String location;
  final String value;
}
