import 'package:flutter/material.dart';
import 'glassy_water_controller.dart';

/// Paints the glassy minimal-wave liquid surface: a smooth Bézier curve
/// through the controller's wave samples, filled with a soft vertical
/// gradient, plus a faint highlight stroke right along the surface line.
///
/// Mirrors the JS demo's buildPath()/render(): same sample count, same
/// quadratic-through-midpoints smoothing, same gradient direction.
class GlassyLiquidPainter extends CustomPainter {
  GlassyLiquidPainter({
    required this.controller,
    this.topColor = const Color(0xFF9FE1CB),
    this.bottomColor = const Color(0xFF0F6E56),
    this.highlightColor = Colors.white,
    this.segments = 40,
  }) : super(repaint: controller);

  final GlassyWaterController controller;
  final Color topColor;
  final Color bottomColor;
  final Color highlightColor;
  final int segments;

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];
    for (int i = 0; i <= segments; i++) {
      final normalizedX = i / segments;
      final x = normalizedX * size.width;
      final y = controller.surfaceYAt(normalizedX);
      points.add(Offset(x, y));
    }
    if (points.isEmpty) return;

    final surfacePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      final midY = (p0.dy + p1.dy) / 2;
      surfacePath.quadraticBezierTo(p0.dx, p0.dy, midX, midY);
      if (i == points.length - 2) {
        surfacePath.quadraticBezierTo(midX, midY, p1.dx, p1.dy);
      }
    }

    final fillPath = Path.from(surfacePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [topColor, bottomColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Faint highlight band along the surface, brighter in the middle and
    // fading at the edges (matches the highlightGrad in the JS demo).
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          highlightColor.withValues(alpha: 0),
          highlightColor.withValues(alpha: 0.55),
          highlightColor.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(surfacePath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant GlassyLiquidPainter oldDelegate) => true;
}
