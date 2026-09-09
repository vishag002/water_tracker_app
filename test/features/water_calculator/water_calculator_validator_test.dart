import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker_app/features/water_calculator/domain/validators/water_calculator_validator.dart';

void main() {
  group('WaterCalculatorValidator.validateWeight', () {
    test('rejects empty input', () {
      expect(WaterCalculatorValidator.validateWeight(''), isNotNull);
      expect(WaterCalculatorValidator.validateWeight(null), isNotNull);
    });

    test('rejects non-numeric input', () {
      expect(WaterCalculatorValidator.validateWeight('abc'), isNotNull);
    });

    test('rejects zero', () {
      expect(WaterCalculatorValidator.validateWeight('0'), isNotNull);
    });

    test('rejects negative values', () {
      expect(WaterCalculatorValidator.validateWeight('-10'), isNotNull);
    });

    test('rejects below minimum (30 kg)', () {
      expect(WaterCalculatorValidator.validateWeight('29'), isNotNull);
    });

    test('rejects above maximum (250 kg)', () {
      expect(WaterCalculatorValidator.validateWeight('251'), isNotNull);
    });

    test('accepts boundary values', () {
      expect(WaterCalculatorValidator.validateWeight('30'), isNull);
      expect(WaterCalculatorValidator.validateWeight('250'), isNull);
    });

    test('accepts a normal valid value', () {
      expect(WaterCalculatorValidator.validateWeight('65'), isNull);
    });
  });

  group('WaterCalculatorValidator.tryParseValidWeight', () {
    test('returns null for invalid input', () {
      expect(WaterCalculatorValidator.tryParseValidWeight('abc'), isNull);
      expect(WaterCalculatorValidator.tryParseValidWeight(''), isNull);
    });

    test('returns parsed value for valid input', () {
      expect(WaterCalculatorValidator.tryParseValidWeight('65'), 65.0);
    });
  });
}
