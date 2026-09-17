import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PremiumIndicatorCard extends StatelessWidget {
  const PremiumIndicatorCard({
    super.key,
    required this.title,
    required this.value,
    required this.label,
    required this.progress,
    this.trailingValue,
  });

  final String title;
  final String value;
  final String label;
  final double progress;
  final String? trailingValue;

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            height: 84,
            child: CustomPaint(
              painter: _GaugePainter(progress: safeProgress),
              child: Align(
                alignment: const Alignment(0, 0.62),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(safeProgress * 100).round()}%',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Live',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppTypography.small,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  trailingValue ?? label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppTypography.tiny,
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

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const segments = 11;
    final center = Offset(size.width / 2, size.height * 0.88);
    final radius = math.min(size.width * 0.42, size.height * 0.72);

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < segments; i++) {
      final fraction = i / (segments - 1);
      final start = math.pi + (math.pi * fraction);
      final active = fraction <= progress;

      backgroundPaint.color = active
          ? Color.lerp(
              AppColors.success,
              AppColors.accent,
              fraction,
            )!
          : AppColors.divider;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        math.pi / (segments * 1.45),
        false,
        backgroundPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
