import 'dart:math';
import 'package:flutter/material.dart';

class GlassyWaterController extends ChangeNotifier {
  GlassyWaterController({
    required this.minLevel,
    required this.maxLevel,
    required double initialLevel,
    this.waveAmount = 4.0, // idle amplitude in pixels — tune this
    this.easeFactor = 0.04,
    this.waveSpeed = 0.012, // idle speed — tune this
  }) : level = initialLevel.clamp(minLevel, maxLevel),
       _displayY = 0,
       _baseY = 0;

  final double minLevel;
  final double maxLevel;

  double waveAmount; // idle surface amplitude (pixels)
  double easeFactor;
  double waveSpeed;

  double level;
  double _displayY;
  double _baseY;
  double _t = 0;
  double _energy = 0; // 0..1, small calm bump on add/remove, decays fast

  double _topY = 0;
  double _bottomY = 0;
  bool _attached = false;

  // Exposed to the painter
  double get energy => _energy;

  void attach({required double topY, required double bottomY}) {
    _topY = topY;
    _bottomY = bottomY;
    _baseY = _levelToY(level);
    if (!_attached) {
      _displayY = _baseY;
      _attached = true;
    }
  }

  double _levelToY(double lvl) {
    final t = ((lvl - minLevel) / (maxLevel - minLevel)).clamp(0.0, 1.0);
    return _bottomY - t * (_bottomY - _topY);
  }

  void setLevel(double newLevel, {bool pulse = true}) {
    level = newLevel.clamp(minLevel, maxLevel);
    _baseY = _levelToY(level);
    if (pulse) _energy = (_energy + 0.30).clamp(0.0, 1.0); // calm nudge
    notifyListeners();
  }

  void addLevel(double delta, {bool pulse = true}) =>
      setLevel(level + delta, pulse: pulse);

  void minusLevel(double delta, {bool pulse = true}) =>
      setLevel(level - delta, pulse: pulse);

  /// Gel morph surface — 3 layered sines at different frequencies/speeds.
  /// Idle: slow and barely moving. On add/remove: energy nudges amplitude
  /// slightly then decays in ~1 second back to calm idle.
  double surfaceYAt(double normalizedX) {
    final amp = waveAmount + _energy * waveAmount * 2.2;
    final spd = waveSpeed;

    double y = _displayY;
    y += sin(normalizedX * pi * 1.6 + _t * spd * 40) * amp;
    y += sin(normalizedX * pi * 2.9 + _t * spd * 40 * 0.55) * amp * 0.40;
    y += sin(normalizedX * pi * 0.8 + _t * spd * 40 * 0.82) * amp * 0.55;
    return y;
  }

  void tick() {
    _t += waveSpeed;
    _displayY += (_baseY - _displayY) * easeFactor;
    // Energy decays quickly — ~1 second back to idle
    if (_energy > 0) {
      _energy *= 0.97;
      if (_energy < 0.005) _energy = 0;
    }
    notifyListeners();
  }
}
