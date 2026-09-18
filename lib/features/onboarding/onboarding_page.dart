import 'package:flutter/material.dart';

import '../../core/storage/onboarding_storage.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';
import '../guest/guest_home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _green = Color(0xFF006B46);
  static const _darkText = Color(0xFF10241D);
  static const _cream = Color(0xFFFBF9F2);
  static const _accent = Color(0xFF6DAA21);

  final PageController _controller = PageController();
  final OnboardingStorage _storage = OnboardingStorage();
  int _index = 0;

  static const _pages = <_OnboardingData>[
    _OnboardingData(
      image: 'assets/images/onboarding_landscape.jpg',
      eyebrow: 'WELCOME',
      titleBefore: 'Discover the\n',
      titleGreen: 'Greater Virunga',
      titleAfter: '\nLandscape',
      body:
          'Explore extraordinary destinations, connect with local people and '
          'be part of a shared future for nature and communities.',
    ),
    _OnboardingData(
      image: 'assets/images/onboarding_wildlife.jpg',
      eyebrow: 'AUTHENTIC EXPERIENCES',
      titleBefore: 'Meet Incredible\n',
      titleGreen: 'Wildlife',
      titleAfter: '',
      body:
          'From mountain gorillas to rare birds and stunning landscapes, '
          'experience the natural wonders that make the Greater Virunga '
          'a global treasure.',
    ),
    _OnboardingData(
      image: 'assets/images/onboarding_community.jpg',
      eyebrow: 'TRAVEL WITH PURPOSE',
      titleBefore: 'Support\n',
      titleGreen: 'Local Communities',
      titleAfter: '',
      body:
          'Book local guides, trackers, porters and discover authentic crafts. '
          'Your journey supports people, livelihoods and conservation across '
          'Uganda, Rwanda and the DRC.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openLogin() async {
    await _storage.markCompleted();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(authService: widget.authService),
      ),
      (_) => false,
    );
  }

  Future<void> _continueAsGuest() async {
    await _storage.markCompleted();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => GuestHomePage(authService: widget.authService),
      ),
      (_) => false,
    );
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _openLogin();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (value) => setState(() => _index = value),
        itemBuilder: (context, index) => _OnboardingScreen(
          data: _pages[index],
          pageIndex: index,
          pageCount: _pages.length,
          isLast: index == _pages.length - 1,
          onSkip: _openLogin,
          onNext: _next,
          onGuest: _continueAsGuest,
        ),
      ),
    );
  }
}

class _OnboardingScreen extends StatelessWidget {
  const _OnboardingScreen({
    required this.data,
    required this.pageIndex,
    required this.pageCount,
    required this.isLast,
    required this.onSkip,
    required this.onNext,
    required this.onGuest,
  });

  final _OnboardingData data;
  final int pageIndex;
  final int pageCount;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onGuest;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final compact = h < 760;
        final firstPage = pageIndex == 0;
        final extraCompact = compact && firstPage;
        final imageHeight = h * (compact ? 0.495 : 0.53);

        return Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: imageHeight,
              child: Image.asset(data.image, fit: BoxFit.cover),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: 140,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.24),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topRight,
                child: Semantics(
                  button: true,
                  label: 'Skip',
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onSkip,
                    child: const SizedBox(
                      width: 92,
                      height: 64,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: imageHeight - 42,
              bottom: 0,
              child: ClipPath(
                clipper: _OnboardingPanelClipper(),
                child: Container(
                  color: _OnboardingPageState._cream,
                  padding: EdgeInsets.fromLTRB(
                    28,
                    extraCompact ? 54 : (compact ? 58 : 66),
                    28,
                    extraCompact ? 4 : (compact ? 8 : 14),
                  ),
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.eyebrow,
                          style: TextStyle(
                            color: _OnboardingPageState._darkText,
                            fontSize: extraCompact ? 10 : (compact ? 10.5 : 11.5),
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: extraCompact ? 3 : (compact ? 5 : 7)),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: _OnboardingPageState._darkText,
                              fontSize: extraCompact ? 27.5 : (compact ? 29 : 32),
                              height: 1.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.7,
                            ),
                            children: [
                              TextSpan(text: data.titleBefore),
                              TextSpan(
                                text: data.titleGreen,
                                style: const TextStyle(
                                  color: _OnboardingPageState._green,
                                ),
                              ),
                              TextSpan(text: data.titleAfter),
                            ],
                          ),
                        ),
                        SizedBox(height: extraCompact ? 6 : (compact ? 8 : 10)),
                        Container(
                          width: 55,
                          height: 3,
                          decoration: BoxDecoration(
                            color: _OnboardingPageState._accent,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        SizedBox(height: extraCompact ? 6 : (compact ? 8 : 10)),
                        Text(
                          data.body,
                          style: TextStyle(
                            color: const Color(0xFF25352F),
                            fontSize: extraCompact ? 12.5 : (compact ? 13 : 14),
                            height: 1.32,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pageCount,
                            (dotIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: dotIndex == pageIndex ? 12 : 9,
                              height: 9,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: dotIndex == pageIndex
                                    ? _OnboardingPageState._green
                                    : const Color(0xFFD8D8D2),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: extraCompact ? 8 : (compact ? 11 : 14)),
                        SizedBox(
                          height: extraCompact ? 47 : (compact ? 50 : 54),
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: onNext,
                            style: FilledButton.styleFrom(
                              backgroundColor: _OnboardingPageState._green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLast ? 'Get Started' : 'Next',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 19,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: extraCompact ? 6 : (compact ? 8 : 10)),
                        SizedBox(
                          height: extraCompact ? 45 : (compact ? 48 : 52),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: onGuest,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _OnboardingPageState._green,
                              side: const BorderSide(
                                color: _OnboardingPageState._green,
                                width: 1.15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            child: const Text(
                              'Continue as Guest',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OnboardingPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 28)
      ..quadraticBezierTo(size.width * 0.45, -18, size.width, 58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _OnboardingData {
  const _OnboardingData({
    required this.image,
    required this.eyebrow,
    required this.titleBefore,
    required this.titleGreen,
    required this.titleAfter,
    required this.body,
  });

  final String image;
  final String eyebrow;
  final String titleBefore;
  final String titleGreen;
  final String titleAfter;
  final String body;
}
