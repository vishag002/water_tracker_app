import 'package:water_tracker_app/features/water_calculator/domain/constants/water_calculator_constants.dart';

/// The four activity levels used to estimate an additional exercise-based
/// fluid adjustment.
///
/// Each level maps to an assumed average daily exercise duration. These
/// are consumer-app estimation assumptions, not scientifically exact
/// categories.
enum ActivityLevel {
  noExercise,
  lightlyActive,
  moderatelyActive,
  veryFrequentIntense,
}

extension ActivityLevelX on ActivityLevel {
  /// Assumed average daily exercise duration, in minutes.
  int get exerciseDurationMinutes {
    switch (this) {
      case ActivityLevel.noExercise:
        return 0;
      case ActivityLevel.lightlyActive:
        return 30;
      case ActivityLevel.moderatelyActive:
        return 60;
      case ActivityLevel.veryFrequentIntense:
        return 120;
    }
  }

  /// Resulting exercise fluid adjustment, in millilitres.
  ///
  /// Derived from [exerciseDurationMinutes] and
  /// [WaterCalculatorConstants.exerciseMlPerHour] — defined here once so
  /// the same formula is never duplicated elsewhere (e.g. in
  /// [WaterCalculator] or in the UI).
  double get exerciseAdjustmentMl =>
      (exerciseDurationMinutes / 60) *
      WaterCalculatorConstants.exerciseMlPerHour;

  String get label {
    switch (this) {
      case ActivityLevel.noExercise:
        return 'No exercise';
      case ActivityLevel.lightlyActive:
        return 'Lightly active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately active';
      case ActivityLevel.veryFrequentIntense:
        return 'Very frequent & intense physical activity';
    }
  }

  String get description {
    switch (this) {
      case ActivityLevel.noExercise:
        return 'Little or no regular exercise';
      case ActivityLevel.lightlyActive:
        return 'Exercise 1-3 days per week';
      case ActivityLevel.moderatelyActive:
        return 'Exercise 3-6 days per week';
      case ActivityLevel.veryFrequentIntense:
        return 'Very frequent or intense physical activity';
    }
  }
}
