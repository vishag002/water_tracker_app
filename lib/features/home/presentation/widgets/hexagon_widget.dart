import 'dart:math';
import 'package:flutter/material.dart';

class HexagonWidget extends StatelessWidget {
  final double? radius;
  final Color color;
  final double strokeWidth;
  final double? cornerRadius; // now optional — scales automatically if null

  const HexagonWidget({
    super.key,
    this.radius,
    this.color = const Color(0xFFE7EAF9),
    this.strokeWidth = 14,
    this.cornerRadius, // <-- no fixed default anymore
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSide = min(constraints.maxWidth, constraints.maxHeight);
        final effectiveRadius = radius != null
            ? min(radius!, maxSide / 2)
            : maxSide / 2;

        // Scale corner rounding relative to the hexagon's own size,
        // so it always reads as a hexagon, not a circle, at any scale.
        final effectiveCornerRadius = cornerRadius ?? effectiveRadius * 0.15;

        return CustomPaint(
          size: Size(effectiveRadius * 2, effectiveRadius * 2),
          painter: _HexagonPainter(
            radius: effectiveRadius,
            color: color,
            strokeWidth: strokeWidth,
            cornerRadius: effectiveCornerRadius,
          ),
        );
      },
    );
  }
}

class _HexagonPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double strokeWidth;
  final double cornerRadius;

  _HexagonPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.cornerRadius,
  });

  List<Offset> _hexPoints(Offset center, double r) {
    final points = <Offset>[];
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 180) * (60 * i - 90);
      points.add(
        Offset(center.dx + r * cos(angle), center.dy + r * sin(angle)),
      );
    }
    return points;
  }

  Path _roundedPolygonPath(List<Offset> points, double cr) {
    final path = Path();
    final len = points.length;
    for (int i = 0; i < len; i++) {
      final curr = points[i];
      final prev = points[(i - 1 + len) % len];
      final next = points[(i + 1) % len];

      final toPrev = prev - curr;
      final toNext = next - curr;
      final toPrevUnit = toPrev / toPrev.distance;
      final toNextUnit = toNext / toNext.distance;

      final maxR = min(toPrev.distance, toNext.distance) / 2;
      final r = min(cr, maxR);

      final p1 = curr + toPrevUnit * r;
      final p2 = curr + toNextUnit * r;

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final effectiveRadius = radius - strokeWidth / 2;
    final points = _hexPoints(center, effectiveRadius);
    final path = _roundedPolygonPath(points, cornerRadius);

    final mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, mainPaint);
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter old) {
    return old.radius != radius ||
        old.color != color ||
        old.strokeWidth != strokeWidth ||
        old.cornerRadius != cornerRadius;
  }
}
