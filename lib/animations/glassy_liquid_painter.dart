import 'package:flutter/material.dart';
import 'glassy_water_controller.dart';

class GlassyLiquidPainter extends CustomPainter {
  GlassyLiquidPainter({
    required this.controller,
    this.topColor = const Color(0xFF9FE1CB),
    this.bottomColor = const Color(0xFF0F6E56),
    this.highlightColor = Colors.white,
    this.segments = 10, // Catmull-Rom needs fewer points than quadratic
  }) : super(repaint: controller);

  final GlassyWaterController controller;
  final Color topColor;
  final Color bottomColor;
  final Color highlightColor;
  final int segments;

  // Catmull-Rom → cubic Bézier conversion.
  // Produces a perfectly smooth curve with zero visible segment joints.
  Path _catmullRomPath(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = pts[i > 0 ? i - 1 : 0];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = pts[i < pts.length - 2 ? i + 2 : pts.length - 1];

      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Build surface points from controller
    final points = <Offset>[];
    for (int i = 0; i <= segments; i++) {
      final nx = i / segments;
      points.add(Offset(nx * size.width, controller.surfaceYAt(nx)));
    }

    final surfacePath = _catmullRomPath(points);

    // Fill path = surface curve + close down to bottom corners
    final fillPath = Path.from(surfacePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Water gradient fill
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Inner depth shimmer — brighter near surface, fades toward bottom
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            highlightColor.withValues(alpha: 0.10),
            highlightColor.withValues(alpha: 0.02),
            Colors.black.withValues(alpha: 0.08),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Soft glow blur behind the surface line — driven by energy
    final energy = controller.energy;
    canvas.drawPath(
      surfacePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 + energy * 5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 + energy * 4)
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            highlightColor.withValues(alpha: 0),
            highlightColor.withValues(alpha: 0.28 + energy * 0.20),
            highlightColor.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Crisp thin line on top of the glow
    canvas.drawPath(
      surfacePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            highlightColor.withValues(alpha: 0),
            highlightColor.withValues(alpha: 0.55 + energy * 0.25),
            highlightColor.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(covariant GlassyLiquidPainter old) => true;
}