import 'package:water_tracker_app/features/water_calculator/domain/constants/water_calculator_constants.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/activity_level.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/water_calculator_input.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/water_calculator_result.dart';

/// Pure Dart calculation engine for the Water Calculator feature.
///
/// Deliberately has no Flutter, Riverpod, HTTP, or persistence
/// dependencies, so it can be unit tested in isolation and reused
/// anywhere (UI, background isolate, tests) without side effects.
///
/// Formula:
/// ```
/// base               = weightKg * baselineMlPerKg
/// exerciseAdjustment = (exerciseDurationMinutes / 60) * exerciseMlPerHour
/// total              = base + exerciseAdjustment
/// ```
///
/// This produces an *estimated* daily hydration target for healthy
/// adults — deliberately not framed as an exact biological requirement.
///
/// NOTE: this is intentionally NOT the Yamada et al. (2022) water-turnover
/// equation (`WT x 0.85`). That equation is not used anywhere in this
/// calculator.
class WaterCalculator {
  const WaterCalculator();

  WaterCalculatorResult calculate(WaterCalculatorInput input) {
    final double baseWaterMl =
        input.weightKg * WaterCalculatorConstants.baselineMlPerKg;

    final int exerciseDurationMinutes =
        input.activityLevel.exerciseDurationMinutes;

    // Single source of truth for the exercise formula lives on the
    // ActivityLevel extension — not duplicated here.
    final double exerciseAdjustmentMl =
        input.activityLevel.exerciseAdjustmentMl;

    final double totalWaterMl = baseWaterMl + exerciseAdjustmentMl;

    return WaterCalculatorResult(
      baseWaterMl: baseWaterMl,
      exerciseAdjustmentMl: exerciseAdjustmentMl,
      totalWaterMl: totalWaterMl,
      exerciseDurationMinutes: exerciseDurationMinutes,
    );
  }
}
  