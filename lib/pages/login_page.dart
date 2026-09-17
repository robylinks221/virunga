import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _background = Color(0xFF07100D);
  static const Color _panel = Color(0xE6141C19);
  static const Color _gold = Color(0xFFD7A845);
  static const Color _goldLight = Color(0xFFF0C96B);
  static const Color _textSecondary = Color(0xFFB7BDBA);

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _hidePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: _background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_gorilla.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.2, -0.85),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.30, 0.50, 0.68, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.24),
                    const Color(0xCC07100D),
                    const Color(0xF207100D),
                    _background,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.42),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.26),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const _RegionMark(),
                        ],
                      ),

                      SizedBox(height: size.height * 0.25),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xB5212C25),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _gold.withOpacity(0.35),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              color: _goldLight,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'EXPLORE • CONNECT • CONSERVE',
                              style: TextStyle(
                                color: _goldLight,
                                fontSize: 11,
                                letterSpacing: 1.15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 43,
                          height: 1.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.25,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Sign in to continue your journey\nin the heart of Africa.',
                        style: TextStyle(
                          color: Color(0xFFD1D5D3),
                          fontSize: 17,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 26),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                        decoration: BoxDecoration(
                          color: _panel,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _gold.withOpacity(0.24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.30),
                              blurRadius: 36,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone Number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),

                            _PremiumField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              hintText: 'Enter your phone number',
                              prefix: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _UgandaFlag(),
                                  SizedBox(width: 10),
                                  Text(
                                    '+256',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: _textSecondary,
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    height: 28,
                                    child: VerticalDivider(
                                      width: 1,
                                      thickness: 1,
                                      color: Color(0xFF58615D),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 17,
                                  color: _gold.withOpacity(0.95),
                                ),
                                const SizedBox(width: 7),
                                const Expanded(
                                  child: Text(
                                    'Your sign-in details are securely protected.',
                                    style: TextStyle(
                                      color: _textSecondary,
                                      fontSize: 12.5,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),

                            _PremiumField(
                              controller: _passwordController,
                              hintText: 'Enter your password',
                              obscureText: _hidePassword,
                              prefix: const Padding(
                                padding: EdgeInsets.only(right: 13),
                                child: Icon(
                                  Icons.lock_outline_rounded,
                                  color: _goldLight,
                                  size: 22,
                                ),
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: _textSecondary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 180),
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: _rememberMe
                                              ? _gold
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: _rememberMe
                                                ? _gold
                                                : Colors.white30,
                                          ),
                                        ),
                                        child: _rememberMe
                                            ? const Icon(
                                                Icons.check_rounded,
                                                size: 16,
                                                color: Color(0xFF10130F),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 9),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(
                                          color: Color(0xFFE0E3E1),
                                          fontSize: 13.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: _goldLight,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: _gold,
                                  foregroundColor: const Color(0xFF11130F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 21,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.035),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  ContainerDotIcon(),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Operating in',
                                          style: TextStyle(
                                            color: _textSecondary,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Uganda • Rwanda • DRC',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.public_rounded,
                                    color: _goldLight,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: _textSecondary,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: _goldLight,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumField extends StatelessWidget {
  const _PremiumField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: _LoginPageState._gold.withOpacity(0.75),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        cursorColor: _LoginPageState._goldLight,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF868D89),
            fontSize: 14.5,
          ),
          prefixIcon: prefix == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 14, right: 4),
                  child: prefix,
                ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

class _RegionMark extends StatelessWidget {
  const _RegionMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'VIRUNGA',
            style: TextStyle(
              color: _LoginPageState._goldLight,
              letterSpacing: 2.1,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'UGANDA • RWANDA • DRC',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.0,
              fontSize: 9.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UgandaFlag extends StatelessWidget {
  const _UgandaFlag();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 24,
        height: 24,
        child: Column(
          children: const [
            Expanded(child: ColoredBox(color: Colors.black)),
            Expanded(child: ColoredBox(color: Color(0xFFFFD700))),
            Expanded(child: ColoredBox(color: Color(0xFFD90000))),
            Expanded(child: ColoredBox(color: Colors.black)),
            Expanded(child: ColoredBox(color: Color(0xFFFFD700))),
            Expanded(child: ColoredBox(color: Color(0xFFD90000))),
          ],
        ),
      ),
    );
  }
}

class ContainerDotIcon extends StatelessWidget {
  const ContainerDotIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _LoginPageState._gold.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: _LoginPageState._goldLight,
        size: 21,
      ),
    );
  }
}