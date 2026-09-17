import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DashboardFilterRow extends StatefulWidget {
  const DashboardFilterRow({super.key});

  @override
  State<DashboardFilterRow> createState() => _DashboardFilterRowState();
}

class _DashboardFilterRowState extends State<DashboardFilterRow> {
  int selected = 0;
  final labels = const ['All', '7d', '1m', '3m', '1y'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final active = selected == index;
        return Padding(
          padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 7),
          child: InkWell(
            onTap: () => setState(() => selected = index),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.black,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                labels[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.tiny,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
