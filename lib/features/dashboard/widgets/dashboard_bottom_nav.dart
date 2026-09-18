import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DashboardNavItem {
  const DashboardNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DashboardNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDeep,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeep.withOpacity(0.20),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.zero,
          child: SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                items.length,
                    (index) {
                  final item = items[index];
                  final selected = index == currentIndex;

                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(index),
                      splashColor:
                      AppColors.accentLight.withOpacity(0.10),
                      highlightColor: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (selected)
                            Positioned(
                              top: 0,
                              left: 18,
                              right: 18,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.accentLight,
                                  borderRadius: BorderRadius.circular(
                                    99,
                                  ),
                                ),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.only(
                              top: 7,
                              bottom: 5,
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  selected
                                      ? item.selectedIcon
                                      : item.icon,
                                  size: 23,
                                  color: selected
                                      ? AppColors.accentLight
                                      : Colors.white70,
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.accentLight
                                        : Colors.white70,
                                    fontSize: AppTypography.tiny,
                                    height: 1.0,
                                    fontWeight: selected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}