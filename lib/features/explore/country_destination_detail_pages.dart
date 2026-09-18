import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CountryDetailPage extends StatelessWidget {
  const CountryDetailPage({super.key, required this.country});
  final String country;
  List<String> get destinations {
    switch (country) {
      case 'Uganda': return ['Bwindi Impenetrable National Park', 'Mgahinga Gorilla National Park', 'Queen Elizabeth National Park'];
      case 'Rwanda': return ['Volcanoes National Park'];
      default: return ['Virunga National Park', 'Kahuzi-Biega National Park'];
    }
  }
  @override
  Widget build(BuildContext context) => _InfoPage(
    eyebrow: 'GREATER VIRUNGA • ' + country.toUpperCase(),
    title: country,
    subtitle: 'Explore protected landscapes, nature, community, culture and crafts.',
    icon: Icons.public_outlined,
    sections: {'DESTINATIONS': destinations, 'DISCOVER': const ['Wildlife & Nature', 'Community & Culture', 'Craft & Artisans', 'Porters', 'Conservation']},
    onItem: (item) {
      if (destinations.contains(item)) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DestinationDetailPage(name: item, country: country)));
      }
    },
  );
}

class DestinationDetailPage extends StatelessWidget {
  const DestinationDetailPage({super.key, required this.name, required this.country});
  final String name;
  final String country;
  @override
  Widget build(BuildContext context) => _InfoPage(
    eyebrow: country.toUpperCase(),
    title: name,
    subtitle: 'Destination information for nature, culture, conservation and local community connections.',
    icon: Icons.landscape_outlined,
    sections: const {
      'DESTINATION': ['Overview', 'Wildlife & Nature', 'Things to Do', 'Community & Culture'],
      'LOCAL CONNECTION': ['Craft & Artisans', 'Porters', 'Rangers'],
      'VISITOR INFORMATION': ['Practical Information', 'Location'],
    },
  );
}

class _InfoPage extends StatelessWidget {
  const _InfoPage({required this.eyebrow, required this.title, required this.subtitle, required this.icon, required this.sections, this.onItem});
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Map<String, List<String>> sections;
  final void Function(String)? onItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent, foregroundColor: AppColors.primary, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 40),
        children: [
          Text(eyebrow, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.1)),
          const SizedBox(height: 7),
          Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 27, fontWeight: FontWeight.w700, height: 1.15)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
          const SizedBox(height: 22),
          Container(
            height: 155, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(22)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: AppColors.accent, size: 31), const Spacer(),
              const Text('NATURE • PEOPLE • PLACE', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: .8)),
              const SizedBox(height: 5),
              const Text('Greater Virunga', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 26),
          ...sections.entries.expand((section) => [
            Text(section.key, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 10),
            ...section.value.map((item) => InkWell(
              onTap: onItem == null ? null : () => onItem!(item),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.cardBorder)),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.arrow_outward_rounded, color: AppColors.primary, size: 18)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w600))),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 20),
                ]),
              ),
            )),
            const SizedBox(height: 15),
          ]),
        ],
      ),
    );
  }
}
