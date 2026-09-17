import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/features/water_calculator/domain/calculators/water_calculator.dart';
import 'package:water_tracker_app/features/water_calculator/domain/constants/water_calculator_constants.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/activity_level.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/water_calculator_input.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/water_calculator_result.dart';

/// Form state for the Water Calculator screen.
///
/// Deliberately dumb — holds only what the UI needs to render. All
/// calculation logic lives in [WaterCalculator]; this class never
/// contains a formula.
class WaterCalculatorFormState {
  const WaterCalculatorFormState({
    required this.weightKg,
    required this.activityLevel,
    required this.result,
  });

  final double weightKg;
  final ActivityLevel activityLevel;
  final WaterCalculatorResult? result;

  bool get canDecrementWeight =>
      weightKg > WaterCalculatorConstants.minWeightKg;
  bool get canIncrementWeight =>
      weightKg < WaterCalculatorConstants.maxWeightKg;
}

/// Coordinates weight, selected activity, and the resulting calculation
/// for the Water Calculator screen.
///
/// Weight is entered via a stepper (+/-) rather than free text, so it is
/// always kept within [WaterCalculatorConstants.minWeightKg] and
/// [WaterCalculatorConstants.maxWeightKg] — no separate validation step
/// is needed on this path.
///
/// UI -> Provider -> WaterCalculator -> WaterCalculatorResult.
/// The formula itself never appears here.
class WaterCalculatorNotifier extends Notifier<WaterCalculatorFormState> {
  static const _calculator = WaterCalculator();
  static const _stepKg = 1.0;
  static const _defaultWeightKg = 65.0;
  static const _defaultActivityLevel = ActivityLevel.noExercise;

  @override
  WaterCalculatorFormState build() {
    return WaterCalculatorFormState(
      weightKg: _defaultWeightKg,
      activityLevel: _defaultActivityLevel,
      result: _calculator.calculate(
        const WaterCalculatorInput(
          weightKg: _defaultWeightKg,
          activityLevel: _defaultActivityLevel,
        ),
      ),
    );
  }

  void incrementWeight() => _setWeight(state.weightKg + _stepKg);

  void decrementWeight() => _setWeight(state.weightKg - _stepKg);

  /// Entry point for typed weight input (the value box is directly
  /// editable). Goes through the same clamp as the stepper buttons, so
  /// typed values are always kept within [WaterCalculatorConstants.minWeightKg]
  /// and [WaterCalculatorConstants.maxWeightKg].
  void setWeight(double weightKg) => _setWeight(weightKg);

  void selectActivityLevel(ActivityLevel level) {
    state = WaterCalculatorFormState(
      weightKg: state.weightKg,
      activityLevel: level,
      result: _calculator.calculate(
        WaterCalculatorInput(weightKg: state.weightKg, activityLevel: level),
      ),
    );
  }

  void _setWeight(double weightKg) {
    final clamped = _clampWeight(weightKg);
    state = WaterCalculatorFormState(
      weightKg: clamped,
      activityLevel: state.activityLevel,
      result: _calculator.calculate(
        WaterCalculatorInput(
          weightKg: clamped,
          activityLevel: state.activityLevel,
        ),
      ),
    );
  }

  double _clampWeight(double value) {
    if (value < WaterCalculatorConstants.minWeightKg) {
      return WaterCalculatorConstants.minWeightKg;
    }
    if (value > WaterCalculatorConstants.maxWeightKg) {
      return WaterCalculatorConstants.maxWeightKg;
    }
    return value;
  }
}

final waterCalculatorProvider =
    NotifierProvider<WaterCalculatorNotifier, WaterCalculatorFormState>(
      WaterCalculatorNotifier.new,
    );
