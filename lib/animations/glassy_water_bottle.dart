import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'glassy_water_controller.dart';
import 'glassy_liquid_painter.dart';

/// The animated, see-through bottle: glassy liquid painted underneath,
/// your transparent bottle PNG layered on top. Wherever the PNG is
/// transparent, the liquid below shows through.
class GlassyWaterBottle extends StatefulWidget {
  const GlassyWaterBottle({
    super.key,
    required this.controller,
    required this.bottleAsset,
    required this.width,
    required this.height,
    this.topColor = const Color(0xFF9FE1CB),
    this.bottomColor = const Color(0xFF0F6E56),
    this.highlightColor = Colors.white,
    this.imagePadding = EdgeInsets.zero,
    this.wallInset = const EdgeInsets.fromLTRB(0.16, 0.20, 0.16, 0.05),
    this.shoulderFraction = 0.08,
    this.neckWidthRatio = 0.68,
    this.bottomRadius = 0.10,
    this.fit = BoxFit.cover,
  });

  final GlassyWaterController controller;
  final String bottleAsset;
  final double width;
  final double height;
  final Color topColor;
  final Color bottomColor;

  /// Color of the faint highlight stroke along the liquid's surface line.
  final Color highlightColor;

  /// How the bottle PNG fills its box. Must match whatever fit you use
  /// elsewhere for this asset -- if you change this, the insets below will
  /// likely need re-tuning, since cover/contain/fill all crop or letterbox
  /// the image differently within the same box.
  final BoxFit fit;

  /// Fractional padding (0..1 of width/height) around the bottle
  /// illustration *inside the PNG itself* -- i.e. the transparent margin
  /// between the image edge and where the glass actually starts. This is
  /// a property of the asset, not the glass shape, so tune it once per
  /// asset and it should hold regardless of the bottle's neck/body
  /// proportions. If the glass appears to "float" with a gap above/below
  /// where you'd expect it to touch the box edge, increase the matching
  /// side here.
  final EdgeInsets imagePadding;

  /// Fractional insets (0..1), measured from the edges of the bottle
  /// illustration *after* [imagePadding] is removed -- i.e. how far the
  /// glass's inner wall sits from the glass's outer silhouette. `top`
  /// should land roughly where the shoulder/neck taper begins, `left`/
  /// `right` on the body's inner wall, `bottom` on the inner base.
  ///
  /// IMPORTANT: `top` controls where the liquid box *starts*. If `top` is
  /// too large, the box starts below the shoulder, inside the straight
  /// neck section -- and since the neck is narrower than the body, the
  /// liquid (which fills its whole box width before any shoulder taper
  /// is applied) will overflow past the glass walls right at the start.
  /// If you see overflow at the very top corners of the liquid, lower
  /// `wallInset.top` first before touching anything else.
  final EdgeInsets wallInset;

  /// How much of the interior's height (0..1) is the sloped shoulder
  /// transitioning from the narrow neck down to the full body width.
  /// Larger = a more gradual taper. This only changes the *shape* of the
  /// transition -- it does NOT fix overflow caused by wallInset.top being
  /// too large or neckWidthRatio being too small.
  final double shoulderFraction;

  /// Neck width as a fraction of the full body width (0..1). This is the
  /// most common source of overflow: if this is too small, the top of the
  /// liquid box is narrower than the actual glass neck in your artwork,
  /// but more importantly, the curve still has to reach full body width
  /// by `shoulderFraction` down -- if the real shoulder in your art is
  /// short and the neck is wide, set this higher (e.g. 0.7-0.85). If you
  /// see liquid spilling past the glass walls near the top, increase this
  /// value. If there's a visible gap between liquid and glass in the neck
  /// area, decrease it.
  final double neckWidthRatio;

  /// Corner radius for the bottom of the liquid clip, as a fraction
  /// (0..1) of the bottle's width. Since the bottle artwork sits on top
  /// and covers the clip edges, this just needs to roughly match your
  /// glass's base curvature -- tune by eye.
  final double bottomRadius;

  @override
  State<GlassyWaterBottle> createState() => _GlassyWaterBottleState();
}

class _GlassyWaterBottleState extends State<GlassyWaterBottle>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();

    final interiorHeight = _interiorHeight();
    widget.controller.attach(topY: 0, bottomY: interiorHeight);

    _ticker = createTicker((_) => widget.controller.tick());
    _ticker.start();
  }

  /// Combined height fraction consumed by [imagePadding] + [wallInset] on
  /// the top/bottom, converted to actual pixels for the current height.
  double _interiorHeight() {
    final pad = widget.imagePadding;
    final wall = widget.wallInset;
    return widget.height * (1 - pad.top - pad.bottom - wall.top - wall.bottom);
  }

  @override
  void didUpdateWidget(GlassyWaterBottle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.height != widget.height ||
        oldWidget.imagePadding != widget.imagePadding ||
        oldWidget.wallInset != widget.wallInset) {
      widget.controller.attach(topY: 0, bottomY: _interiorHeight());
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.imagePadding;
    final wall = widget.wallInset;

    // Total fraction consumed on each side = the asset's own transparent
    // margin (imagePadding) plus the glass wall thickness (wallInset).
    final leftFrac = pad.left + wall.left;
    final rightFrac = pad.right + wall.right;
    final topFrac = pad.top + wall.top;
    final bottomFrac = pad.bottom + wall.bottom;

    final interiorWidth = widget.width * (1 - leftFrac - rightFrac);
    final interiorHeight = widget.height * (1 - topFrac - bottomFrac);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Positioned(
            left: widget.width * leftFrac,
            top: widget.height * topFrac,
            width: interiorWidth,
            height: interiorHeight,
            child: ClipPath(
              clipper: _BottleInteriorClipper(
                shoulderFraction: widget.shoulderFraction,
                neckWidthRatio: widget.neckWidthRatio,
                bottomRadius: widget.bottomRadius,
              ),
              child: CustomPaint(
                size: Size(interiorWidth, interiorHeight),
                painter: GlassyLiquidPainter(
                  controller: widget.controller,
                  topColor: widget.topColor,
                  bottomColor: widget.bottomColor,
                  highlightColor: widget.highlightColor,
                ),
              ),
            ),
          ),

          // Transparent bottle PNG on top -- glass body + reflections.
          Positioned.fill(
            child: Image.asset(widget.bottleAsset, fit: widget.fit),
          ),
        ],
      ),
    );
  }
}

/// Traces an approximate bottle-interior silhouette: narrower at the top
/// (the neck), widening through a short shoulder curve into the full
/// body width, then a plain rounded rectangle at the bottom -- since the
/// bottle artwork sits on top and covers the clip edges, the bottom
/// doesn't need its own taper, just a radius you can match to the real
/// glass's corner.
class _BottleInteriorClipper extends CustomClipper<Path> {
  _BottleInteriorClipper({
    this.shoulderFraction = 0.08,
    this.neckWidthRatio = 0.68,
    this.bottomRadius = 0.10,
  });

  /// How much of the interior's height (0..1) the neck-to-shoulder curve
  /// takes up before the wall goes straight down the body.
  final double shoulderFraction;

  /// Neck width as a fraction of the full body width (0..1).
  final double neckWidthRatio;

  /// Corner radius for the bottom, as a fraction (0..1) of the width.
  final double bottomRadius;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final shoulderH = h * shoulderFraction;
    final radius = w * bottomRadius;

    // Neck width at the very top of the interior box, as a fraction of
    // the body's full width. A neck that's too narrow relative to the
    // body -- combined with a short shoulderH -- is the #1 cause of
    // liquid overflowing past the glass walls near the top.
    final neckHalfWidth = w * 0.5 * neckWidthRatio;
    final neckLeft = w / 2 - neckHalfWidth;
    final neckRight = w / 2 + neckHalfWidth;

    final path = Path()
      ..moveTo(neckLeft, 0)
      ..lineTo(neckRight, 0)
      // Shoulder: one smooth curve out from the neck to the full body
      // width, following the glass's actual curve instead of a flat cut.
      ..cubicTo(neckRight, shoulderH * 0.3, w, shoulderH * 0.55, w, shoulderH)
      // Straight body wall down to the bottom-right corner.
      ..lineTo(w, h - radius)
      ..quadraticBezierTo(w, h, w - radius, h)
      ..lineTo(radius, h)
      ..quadraticBezierTo(0, h, 0, h - radius)
      // Straight body wall back up to the shoulder.
      ..lineTo(0, shoulderH)
      ..cubicTo(0, shoulderH * 0.55, neckLeft, shoulderH * 0.3, neckLeft, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant _BottleInteriorClipper oldClipper) =>
      oldClipper.shoulderFraction != shoulderFraction ||
      oldClipper.neckWidthRatio != neckWidthRatio ||
      oldClipper.bottomRadius != bottomRadius;
}
