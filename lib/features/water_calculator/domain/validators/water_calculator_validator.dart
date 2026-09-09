import 'package:water_tracker_app/features/water_calculator/domain/constants/water_calculator_constants.dart';

/// Validates raw user input for the Water Calculator form.
///
/// Returns a human-readable error message, or `null` when the input is
/// valid — compatible with `TextFormField.validator`.
class WaterCalculatorValidator {
  WaterCalculatorValidator._();

  static String? validateWeight(String? rawValue) {
    final value = rawValue?.trim() ?? '';

    if (value.isEmpty) {
      return 'Please enter your weight.';
    }

    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'Enter a valid number.';
    }

    if (parsed <= 0) {
      return 'Weight must be greater than zero.';
    }

    if (parsed < WaterCalculatorConstants.minWeightKg) {
      return 'Weight must be at least '
          '${WaterCalculatorConstants.minWeightKg.toStringAsFixed(0)} kg.';
    }

    if (parsed > WaterCalculatorConstants.maxWeightKg) {
      return 'Weight must be no more than '
          '${WaterCalculatorConstants.maxWeightKg.toStringAsFixed(0)} kg.';
    }

    return null;
  }

  /// Returns the parsed weight only when [rawValue] passes
  /// [validateWeight]; otherwise `null`.
  static double? tryParseValidWeight(String? rawValue) {
    if (validateWeight(rawValue) != null) return null;
    return double.parse(rawValue!.trim());
  }
}
