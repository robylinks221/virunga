import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExactPromoCard extends StatelessWidget {
  const ExactPromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryDeep,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 170,
            child: Image.asset(
              'assets/images/login_gorilla.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDeep,
                  AppColors.primaryDeep.withValues(alpha: .90),
                  AppColors.primaryDeep.withValues(alpha: .12),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stronger together',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTypography.h3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Building better communities\nfor a brighter tomorrow.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppTypography.small,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentLight,
                      foregroundColor: AppColors.primaryDeep,
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
