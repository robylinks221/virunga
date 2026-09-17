import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MiniTrendChart extends StatelessWidget {
  const MiniTrendChart({
    super.key,
    required this.values,
    this.height = 86,
  });

  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _TrendPainter(values),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs() < 0.0001
        ? 1.0
        : maxValue - minValue;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final normalized = (values[i] - minValue) / range;
      final y = size.height - (normalized * (size.height - 14)) - 7;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final midX = (previous.dx + current.dx) / 2;
      path.cubicTo(
        midX,
        previous.dy,
        midX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accent.withValues(alpha: 0.22),
          AppColors.accent.withValues(alpha: 0.01),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
