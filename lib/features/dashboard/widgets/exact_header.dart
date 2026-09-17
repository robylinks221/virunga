import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExactDashboardHeader extends StatelessWidget {
  const ExactDashboardHeader({
    super.key,
    required this.name,
    required this.roleLabel,
  });

  final String name;
  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? 'V' : name.trim()[0].toUpperCase();

    return Container(
      height: 315,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.primaryDeep,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login_gorilla.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0.35, -0.35),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryDeep.withValues(alpha: .96),
                  AppColors.primaryDeep.withValues(alpha: .76),
                  AppColors.primaryDeep.withValues(alpha: .18),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _HeaderButton(icon: Icons.grid_view_rounded),
                      const Spacer(),
                      _HeaderButton(icon: Icons.search_rounded),
                      const SizedBox(width: 8),
                      const _HeaderButton(
                        icon: Icons.notifications_none_rounded,
                        badge: true,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppTypography.h3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Good morning,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$name 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 31,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: .8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          size: 17,
                          color: AppColors.accentLight,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          roleLabel,
                          style: const TextStyle(
                            color: AppColors.accentLight,
                            fontSize: AppTypography.small,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.success,
                        ),
                      ],
                    ),
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

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, this.badge = false});
  final IconData icon;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .20),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (badge)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: AppColors.primaryDeep,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
