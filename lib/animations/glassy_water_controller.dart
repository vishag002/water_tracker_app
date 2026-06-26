import 'dart:math';
import 'package:flutter/material.dart';

/// Drives the "glassy minimal waves" liquid animation: an eased water
/// level plus two slow, low-amplitude sine waves blended together, with
/// a short-lived extra ripple that fades in on refill/drink actions.
///
/// This mirrors the JS demo 1:1 — `displayY` eases toward `baseY` each
/// frame (no spring/bounce), and `curveY()` is the same two-sine blend
/// plus an optional decaying "pulse" wave.
class GlassyWaterController extends ChangeNotifier {
  GlassyWaterController({
    required this.minLevel,
    required this.maxLevel,
    required double initialLevel,
    this.waveAmount = 1.5,
    this.easeFactor = 0.04,
    this.waveSpeed = 0.012,
  }) : level = initialLevel.clamp(minLevel, maxLevel),
       _displayY = 0,
       _baseY = 0;

  final double minLevel;
  final double maxLevel;

  /// 0 = perfectly flat, ~5 = noticeably rippling. Matches the demo slider.
  double waveAmount;

  /// How quickly the surface eases to a new level each frame. Smaller =
  /// slower, calmer transitions. 0.04 matches the demo's default feel.
  double easeFactor;

  /// How fast the wave phase advances each frame (radians-ish per tick).
  double waveSpeed;

  double level; // current water level, in the same units as min/maxLevel
  double _displayY; // smoothed pixel y of the surface (eases toward _baseY)
  double _baseY; // target pixel y of the surface for the current level
  double _t = 0; // wave phase accumulator
  double _refillPulse = 0; // 0..1, decays after a refill/drink action

  double _topY = 0;
  double _bottomY = 0;
  bool _attached = false;

  /// Call once layout is known (e.g. in didChangeDependencies or after the
  /// first frame) with the pixel bounds of the liquid's drawable area.
  void attach({required double topY, required double bottomY}) {
    _topY = topY;
    _bottomY = bottomY;
    _baseY = _levelToY(level);
    if (!_attached) {
      _displayY = _baseY; // snap on first attach, no animating from 0
      _attached = true;
    }
  }

  double _levelToY(double lvl) {
    final t = ((lvl - minLevel) / (maxLevel - minLevel)).clamp(0.0, 1.0);
    return _bottomY - t * (_bottomY - _topY);
  }

  /// Smoothly move to a new level. Also kicks off a short fade-out ripple
  /// so the action feels acknowledged (matches refillBtn in the demo).
  void setLevel(double newLevel, {bool pulse = true}) {
    level = newLevel.clamp(minLevel, maxLevel);
    _baseY = _levelToY(level);
    if (pulse) _refillPulse = 1.0;
    notifyListeners();
  }

  /// Convenience for a relative change, e.g. controller.addLevel(0.25).
  void addLevel(double delta, {bool pulse = true}) {
    setLevel(level + delta, pulse: pulse);
  }

  void minusLevel(double delta, {bool pulse = true}) {
    setLevel(level - delta, pulse: pulse);
  }

  /// Height of the surface at a given normalized x (0..1 across the width).
  /// Same two-sine blend as the JS demo's curveY(), plus the decaying pulse.
  double surfaceYAt(double normalizedX) {
    double y = _displayY;
    y += sin(_t * 0.4 + normalizedX * 3.2) * waveAmount;
    y += sin(_t * 0.7 - normalizedX * 5.5 + 1.3) * waveAmount * 0.5;
    if (_refillPulse > 0.001) {
      y += sin(_t * 1.6 + normalizedX * 8) * waveAmount * 2.5 * _refillPulse;
    }
    return y;
  }

  /// Advance one frame. Call this every tick from a Ticker.
  void tick() {
    _t += waveSpeed;
    _displayY += (_baseY - _displayY) * easeFactor;
    if (_refillPulse > 0) {
      _refillPulse *= 0.985;
      if (_refillPulse < 0.005) _refillPulse = 0;
    }
    notifyListeners();
  }
}
