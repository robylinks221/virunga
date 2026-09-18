import 'package:flutter/material.dart';

typedef VirungaPageBuilder = Widget Function(BuildContext context);

/// Keeps the page map in one place without importing or modifying GuestHomePage.
///
/// Register the actual page widgets from main.dart/app.dart once all generated
/// UI files have been copied into the project.
class VirungaPageRegistry {
  VirungaPageRegistry({
    required this.home,
    required this.explore,
    required this.community,
    required this.marketplace,
    required this.profile,
    this.destinations,
    this.countries,
    this.porters,
    this.conservation,
    this.rangers,
    this.search,
    this.settings,
    this.saved,
    this.notifications,
  });

  final VirungaPageBuilder home;
  final VirungaPageBuilder explore;
  final VirungaPageBuilder community;
  final VirungaPageBuilder marketplace;
  final VirungaPageBuilder profile;

  final VirungaPageBuilder? destinations;
  final VirungaPageBuilder? countries;
  final VirungaPageBuilder? porters;
  final VirungaPageBuilder? conservation;
  final VirungaPageBuilder? rangers;
  final VirungaPageBuilder? search;
  final VirungaPageBuilder? settings;
  final VirungaPageBuilder? saved;
  final VirungaPageBuilder? notifications;

  Map<String, VirungaPageBuilder> routes() {
    final map = <String, VirungaPageBuilder>{
      '/': home,
      '/explore': explore,
      '/community': community,
      '/marketplace': marketplace,
      '/profile': profile,
    };

    void add(String route, VirungaPageBuilder? builder) {
      if (builder != null) map[route] = builder;
    }

    add('/destinations', destinations);
    add('/countries', countries);
    add('/porters', porters);
    add('/conservation', conservation);
    add('/rangers', rangers);
    add('/search', search);
    add('/settings', settings);
    add('/saved', saved);
    add('/notifications', notifications);

    return map;
  }
}
