import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExactOverviewCard extends StatelessWidget {
  const ExactOverviewCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.caption,
    required this.lineColor,
    this.subtitle,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;
  final String caption;
  final Color lineColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTypography.small,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: iconColor,
                fontSize: AppTypography.tiny,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppTypography.tiny,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 34,
            child: CustomPaint(
              painter: _TinyChart(lineColor),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyChart extends CustomPainter {
  const _TinyChart(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final pts = [
      Offset(0, size.height * .80),
      Offset(size.width * .16, size.height * .66),
      Offset(size.width * .30, size.height * .70),
      Offset(size.width * .45, size.height * .48),
      Offset(size.width * .60, size.height * .54),
      Offset(size.width * .74, size.height * .30),
      Offset(size.width, size.height * .14),
    ];
    final p = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final a = pts[i - 1];
      final b = pts[i];
      final m = (a.dx + b.dx) / 2;
      p.cubicTo(m, a.dy, m, b.dy, b.dx, b.dy);
    }

    canvas.drawPath(
      p,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TinyChart oldDelegate) =>
      oldDelegate.color != color;
}
