/// Centralized constants for the Water Calculator feature.
///
/// Every numeric assumption behind the calculator lives here, and only
/// here. The calculator, the UI, and the tests all read from this single
/// source of truth — if a value ever needs to change, this is the only
/// file to touch.
class WaterCalculatorConstants {
  WaterCalculatorConstants._();

  /// Weight-based baseline (mL of fluid per kg of body weight).
  ///
  /// Informed by clinical maintenance-fluid estimation guidance (e.g.
  /// ESPEN) for adults aged 18-60. This is a practical baseline
  /// *estimate*, not an exact or universally proven biological
  /// requirement.
  static const double baselineMlPerKg = 35.0;

  /// App-defined exercise fluid estimation parameter (mL per hour of
  /// exercise).
  ///
  /// This is an app estimation parameter, NOT a universal medical
  /// formula — it is not an exact figure mandated by ACSM or any other
  /// body. Real fluid needs during exercise vary with sweat rate,
  /// intensity, duration, and environment.
  static const double exerciseMlPerHour = 600.0;

  /// Valid input range for body weight, in kilograms.
  static const double minWeightKg = 30.0;
  static const double maxWeightKg = 250.0;

  // --- Environmental defaults ---
  //
  // These are fixed, display-only values for this version. They do NOT
  // affect `WaterCalculator`'s output. They exist so a future phase can
  // introduce a real environmental data source (e.g. a weather
  // provider) without rewriting the calculation engine — see the
  // "Future extensibility" note in the feature spec.
  static const double defaultTemperatureCelsius = 27.0;
  static const double defaultHumidityPercent = 60.0;
  static const double defaultAltitudeMeters = 0.0;
}
