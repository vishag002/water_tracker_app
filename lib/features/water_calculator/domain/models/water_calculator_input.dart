import 'package:water_tracker_app/features/water_calculator/domain/models/activity_level.dart';

/// Reserved for a future personalization flow. Never used mathematically
/// by [WaterCalculator] in this version.
enum BiologicalSex { male, female, other }

/// Immutable input to the water calculation engine.
class WaterCalculatorInput {
  const WaterCalculatorInput({
    required this.weightKg,
    required this.activityLevel,
    this.age,
    this.sex,
  });

  /// Body weight in kilograms — the primary mathematical input.
  final double weightKg;

  final ActivityLevel activityLevel;

  /// Informational/future-personalization only. Never used in the
  /// calculation.
  final int? age;

  /// Informational/future-personalization only. Never used in the
  /// calculation.
  final BiologicalSex? sex;

  WaterCalculatorInput copyWith({
    double? weightKg,
    ActivityLevel? activityLevel,
    int? age,
    BiologicalSex? sex,
  }) {
    return WaterCalculatorInput(
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      age: age ?? this.age,
      sex: sex ?? this.sex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterCalculatorInput &&
          runtimeType == other.runtimeType &&
          weightKg == other.weightKg &&
          activityLevel == other.activityLevel &&
          age == other.age &&
          sex == other.sex;

  @override
  int get hashCode => Object.hash(weightKg, activityLevel, age, sex);
}
