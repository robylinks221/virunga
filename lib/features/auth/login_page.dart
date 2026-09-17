import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dashboard/dashboard_page.dart';
import 'auth_exception.dart';
import 'auth_service.dart';
import 'login_credential_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _Country {
  const _Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.emoji,
  });

  final String name;
  final String code;
  final String dialCode;
  final String emoji;
}

class _LoginPageState extends State<LoginPage> {
  static const Color _background = Color(0xFF07100D);
  static const Color _panel = Color(0xF2141C19);
  static const Color _gold = Color(0xFFD7A845);
  static const Color _goldLight = Color(0xFFF0C96B);
  static const Color _textSecondary = Color(0xFFB7BDBA);

  static const List<_Country> _countries = [
    _Country(
      name: 'Uganda',
      code: 'UG',
      dialCode: '256',
      emoji: '🇺🇬',
    ),
    _Country(
      name: 'Rwanda',
      code: 'RW',
      dialCode: '250',
      emoji: '🇷🇼',
    ),
    _Country(
      name: 'DRC',
      code: 'CD',
      dialCode: '243',
      emoji: '🇨🇩',
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  _Country _selectedCountry = _countries.first;
  bool _hidePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  final LoginCredentialStorage _credentialStorage = LoginCredentialStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    final remember = await _credentialStorage.shouldRemember();

    if (!remember) return;

    final phone = await _credentialStorage.getPhone();
    final password = await _credentialStorage.getPassword();
    final countryCode = await _credentialStorage.getCountryCode();

    if (countryCode != null) {
      for (final country in _countries) {
        if (country.code == countryCode) {
          _selectedCountry = country;
          break;
        }
      }
    }

    _phoneController.text = phone ?? '';
    _passwordController.text = password ?? '';

    if (mounted) {
      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _normalisedPhoneNumber() {
    var digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (digits.startsWith(_selectedCountry.dialCode)) {
      return digits;
    }

    while (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    return '${_selectedCountry.dialCode}$digits';
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.authService.login(
        phoneNumber: _normalisedPhoneNumber(),
        password: _passwordController.text,
      );

      if (_rememberMe) {
        await _credentialStorage.save(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          countryCode: _selectedCountry.code,
        );
      } else {
        await _credentialStorage.clear();
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            authService: widget.authService,
          ),
        ),
        (_) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      _showError(error.message);
    } catch (_) {
      if (!mounted) return;
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF8C2D2D),
          content: Text(message),
        ),
      );
  }

  Future<void> _showCountryPicker() async {
    final selected = await showModalBottomSheet<_Country>(
      context: context,
      backgroundColor: const Color(0xFF111916),
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select country',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ..._countries.map(
                  (country) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: Text(
                      country.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                    title: Text(
                      country.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '+${country.dialCode}',
                      style: const TextStyle(
                        color: _goldLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, country),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCountry = selected;
      });
    }
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
              alignment: const Alignment(0.18, -0.95),
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
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.24),
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
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: _RegionMark(),
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
                          color: _gold.withValues(alpha: 0.35),
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
                          color: _gold.withValues(alpha: 0.24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.30),
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
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+\-\s()]'),
                              ),
                            ],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            cursorColor: _goldLight,
                            decoration: _fieldDecoration(
                              hintText: 'Enter your phone number',
                              prefix: InkWell(
                                onTap: _isLoading ? null : _showCountryPicker,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 14, right: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _selectedCountry.emoji,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+${_selectedCountry.dialCode}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: _textSecondary,
                                      ),
                                      const SizedBox(width: 7),
                                      const SizedBox(
                                        height: 28,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: Color(0xFF58615D),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your phone number.';
                              }

                              final phone = _normalisedPhoneNumber();

                              if (!RegExp(r'^\d{10,15}$').hasMatch(phone)) {
                                return 'Enter a valid phone number.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          const Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 17,
                                color: _gold,
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  'Your sign-in details are securely protected.',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12.5,
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
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!_isLoading) _login();
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            cursorColor: _goldLight,
                            decoration: _fieldDecoration(
                              hintText: 'Enter your password',
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 13),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your password.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: _isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                  activeColor: _gold,
                                  checkColor: const Color(0xFF11130F),
                                  side: const BorderSide(
                                    color: _goldLight,
                                    width: 1.4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Remember phone number and password',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _isLoading ? null : () {},
                              style: TextButton.styleFrom(
                                foregroundColor: _goldLight,
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: FilledButton(
                              onPressed: _isLoading ? null : _login,
                              style: FilledButton.styleFrom(
                                backgroundColor: _gold,
                                disabledBackgroundColor:
                                    _gold.withValues(alpha: 0.55),
                                foregroundColor: const Color(0xFF11130F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Color(0xFF11130F),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Log In',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
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
                              color: Colors.white.withValues(alpha: 0.035),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: const Row(
                              children: [
                                _LocationIcon(),
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
                        ],
                      ),
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

  InputDecoration _fieldDecoration({
    required String hintText,
    Widget? prefix,
    Widget? suffix,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(17),
      borderSide: BorderSide(
        color: _gold.withValues(alpha: 0.75),
      ),
    );

    return InputDecoration(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.18),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF868D89),
        fontSize: 14.5,
      ),
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 58,
      ),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(
          color: _goldLight,
          width: 1.4,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(
          color: Color(0xFFE47777),
        ),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(
          color: Color(0xFFE47777),
          width: 1.4,
        ),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFF0A0A0),
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
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
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

class _LocationIcon extends StatelessWidget {
  const _LocationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _LoginPageState._gold.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: _LoginPageState._goldLight,
        size: 21,
      ),
    );
  }}
