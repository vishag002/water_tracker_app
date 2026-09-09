import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker_app/features/water_calculator/domain/calculators/water_calculator.dart';
import 'package:water_tracker_app/features/water_calculator/domain/constants/water_calculator_constants.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/activity_level.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/water_calculator_input.dart';

void main() {
  const calculator = WaterCalculator();

  group('WaterCalculator - documented examples', () {
    test('65 kg, no exercise => 2275 mL', () {
      final result = calculator.calculate(
        const WaterCalculatorInput(
          weightKg: 65,
          activityLevel: ActivityLevel.noExercise,
        ),
      );
      expect(result.baseWaterMl, closeTo(2275, 0.001));
      expect(result.exerciseAdjustmentMl, 0);
      expect(result.totalWaterMl, closeTo(2275, 0.001));
    });

    test('65 kg, lightly active => 2575 mL (+300 mL)', () {
      final result = calculator.calculate(
        const WaterCalculatorInput(
          weightKg: 65,
          activityLevel: ActivityLevel.lightlyActive,
        ),
      );
      expect(result.baseWaterMl, closeTo(2275, 0.001));
      expect(result.exerciseAdjustmentMl, closeTo(300, 0.001));
      expect(result.totalWaterMl, closeTo(2575, 0.001));
    });

    test('65 kg, moderately active => 2875 mL (2.88 L/day)', () {
      final result = calculator.calculate(
        const WaterCalculatorInput(
          weightKg: 65,
          activityLevel: ActivityLevel.moderatelyActive,
        ),
      );
      expect(result.baseWaterMl, closeTo(2275, 0.001));
      expect(result.exerciseAdjustmentMl, closeTo(600, 0.001));
      expect(result.totalWaterMl, closeTo(2875, 0.001));
      expect(result.totalWaterLiters, closeTo(2.875, 0.001));
    });

    test('70 kg, very frequent & intense activity => 3650 mL (+1,200 mL)', () {
      final result = calculator.calculate(
        const WaterCalculatorInput(
          weightKg: 70,
          activityLevel: ActivityLevel.veryFrequentIntense,
        ),
      );
      expect(result.baseWaterMl, closeTo(2450, 0.001));
      expect(result.exerciseAdjustmentMl, closeTo(1200, 0.001));
      expect(result.totalWaterMl, closeTo(3650, 0.001));
      expect(result.totalWaterLiters, closeTo(3.65, 0.001));
    });

    test('50 kg, no exercise => 1750 mL', () {
      final result = calculator.calculate(
        const WaterCalculatorInput(
          weightKg: 50,
          activityLevel: ActivityLevel.noExercise,
        ),
      );
      expect(result.totalWaterMl, closeTo(1750, 0.001));
    });
  });

  group('WaterCalculator - activity progression', () {
    test('total increases monotonically with activity level, same weight', () {
      const weight = 70.0;
      final totals = ActivityLevel.values
          .map(
            (level) => calculator
                .calculate(
                  WaterCalculatorInput(weightKg: weight, activityLevel: level),
                )
                .totalWaterMl,
          )
          .toList();

      for (var i = 1; i < totals.length; i++) {
        expect(totals[i], greaterThan(totals[i - 1]));
      }
    });
  });

  group('WaterCalculator - exactly 4 activity options', () {
    test('ActivityLevel has exactly 4 values', () {
      expect(ActivityLevel.values.length, 4);
    });

    test('the four values are the expected ones, in order', () {
      expect(ActivityLevel.values, [
        ActivityLevel.noExercise,
        ActivityLevel.lightlyActive,
        ActivityLevel.moderatelyActive,
        ActivityLevel.veryFrequentIntense,
      ]);
    });

    test('the removed 90-minute "very active" tier no longer exists', () {
      // Regression guard: no activity level should map to 90 minutes.
      for (final level in ActivityLevel.values) {
        expect(level.exerciseDurationMinutes, isNot(90));
      }
    });
  });

  group('WaterCalculator - constants regression guard', () {
    test('baseline stays at 35 mL/kg', () {
      expect(WaterCalculatorConstants.baselineMlPerKg, 35.0);
    });

    test('exercise rate stays at 600 mL/hour', () {
      expect(WaterCalculatorConstants.exerciseMlPerHour, 600.0);
    });

    test('environmental defaults stay fixed', () {
      expect(WaterCalculatorConstants.defaultTemperatureCelsius, 27.0);
      expect(WaterCalculatorConstants.defaultHumidityPercent, 60.0);
      expect(WaterCalculatorConstants.defaultAltitudeMeters, 0.0);
    });

    test('activity durations stay at 0/30/60/120 minutes', () {
      expect(ActivityLevel.noExercise.exerciseDurationMinutes, 0);
      expect(ActivityLevel.lightlyActive.exerciseDurationMinutes, 30);
      expect(ActivityLevel.moderatelyActive.exerciseDurationMinutes, 60);
      expect(ActivityLevel.veryFrequentIntense.exerciseDurationMinutes, 120);
    });

    test('activity exercise adjustments stay at 0/300/600/1200 mL', () {
      expect(ActivityLevel.noExercise.exerciseAdjustmentMl, closeTo(0, 0.001));
      expect(
        ActivityLevel.lightlyActive.exerciseAdjustmentMl,
        closeTo(300, 0.001),
      );
      expect(
        ActivityLevel.moderatelyActive.exerciseAdjustmentMl,
        closeTo(600, 0.001),
      );
      expect(
        ActivityLevel.veryFrequentIntense.exerciseAdjustmentMl,
        closeTo(1200, 0.001),
      );
    });
  });

  group('WaterCalculator - no Yamada / no 0.85 regression', () {
    test('result does NOT match a Yamada-style (weight * 0.85) calculation', () {
      final result = calculator.calculate(
        const WaterCalculatorInput(
          weightKg: 65,
          activityLevel: ActivityLevel.noExercise,
        ),
      );
      const yamadaStyleResult = 65 * 0.85; // what the old calculator gave
      expect(result.totalWaterMl, isNot(closeTo(yamadaStyleResult, 0.001)));
      // Confirm we are actually using the 35 mL/kg baseline model.
      expect(result.totalWaterMl, closeTo(65 * 35.0, 0.001));
    });
  });
}
