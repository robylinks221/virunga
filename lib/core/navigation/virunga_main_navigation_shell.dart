import 'package:flutter/material.dart';

class VirungaMainNavigationShell extends StatefulWidget {
  const VirungaMainNavigationShell({
    super.key,
    required this.homePage,
    required this.explorePage,
    required this.communityPage,
    required this.marketplacePage,
    required this.profilePage,
    this.initialIndex = 0,
  });

  /// IMPORTANT:
  /// Pass the EXISTING approved GuestHomePage here.
  /// This shell never rebuilds or redesigns the Home page itself.
  final Widget homePage;
  final Widget explorePage;
  final Widget communityPage;
  final Widget marketplacePage;
  final Widget profilePage;
  final int initialIndex;

  @override
  State<VirungaMainNavigationShell> createState() =>
      _VirungaMainNavigationShellState();
}

class _VirungaMainNavigationShellState
    extends State<VirungaMainNavigationShell> {
  static const _green = Color(0xFF032329);
  static const _beige = Color(0xFFF58020);
  static const _background = Color(0xFFFAFBF8);
  static const _border = Color(0xFFE5EAE7);

  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      widget.homePage,
      widget.explorePage,
      widget.communityPage,
      widget.marketplacePage,
      widget.profilePage,
    ];

    return Scaffold(
      backgroundColor: _background,
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            backgroundColor: Colors.white,
            indicatorColor: _beige,
            surfaceTintColor: Colors.transparent,
            height: 68,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: _green),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded, color: _green),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.diversity_3_outlined),
                selectedIcon: Icon(Icons.diversity_3, color: _green),
                label: 'Community',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag, color: _green),
                label: 'Marketplace',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: _green),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
