/// Immutable output of the water calculation engine.
///
/// Represents an *estimated* daily hydration target for a healthy adult
/// — not an exact biological requirement.
class WaterCalculatorResult {
  const WaterCalculatorResult({
    required this.baseWaterMl,
    required this.exerciseAdjustmentMl,
    required this.totalWaterMl,
    required this.exerciseDurationMinutes,
  });

  final double baseWaterMl;
  final double exerciseAdjustmentMl;
  final double totalWaterMl;
  final int exerciseDurationMinutes;

  double get totalWaterLiters => totalWaterMl / 1000;
  double get baseWaterLiters => baseWaterMl / 1000;
  double get exerciseAdjustmentLiters => exerciseAdjustmentMl / 1000;

  @override
  String toString() =>
      'WaterCalculatorResult(base: $baseWaterMl mL, '
      'exercise: $exerciseAdjustmentMl mL, total: $totalWaterMl mL)';
}
