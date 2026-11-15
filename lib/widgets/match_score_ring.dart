import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../l10n/app_text.dart';

/// Vòng tròn hiển thị % phù hợp giữa hai sinh viên.
class MatchScoreRing extends StatelessWidget {
  final int percent;
  final double size;
  final bool showCaption;
  final String? caption;

  const MatchScoreRing({
    super.key,
    required this.percent,
    this.size = 58,
    this.showCaption = true,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final value = (percent / 100).clamp(0.0, 1.0).toDouble();
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          value: value,
          background: AppColors.border,
          colors: [AppColors.primary, AppColors.secondary],
          strokeWidth: size >= 80 ? 7 : 5,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: size * 0.26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  color: AppColors.ink,
                ),
              ),
              if (showCaption) ...[
                const SizedBox(height: 2),
                Text(
                  caption ?? tr('phù hợp'),
                  style: TextStyle(
                    fontSize: size * 0.135,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color background;
  final List<Color> colors;
  final double strokeWidth;

  _RingPainter({
    required this.value,
    required this.background,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (value <= 0) return;

    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: math.pi * 3 / 2,
      colors: colors,
      transform: const GradientRotation(-math.pi / 2),
    ).createShader(rect);

    final arcPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.colors != colors;
}
