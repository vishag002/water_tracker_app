/// Pure calculation logic for today's water intake — no Flutter or Drift
/// dependency, same separation used by the other calculator engines
/// (e.g. features/water_calculator/domain/calculators).
class DailyIntakeCalculator {
  const DailyIntakeCalculator._();

  /// Sums a list of entry amounts (all assumed to already be in the same
  /// unit — currently always 'ml') into a single total.
  static int totalMl(List<int> entryAmountsMl) {
    return entryAmountsMl.fold(0, (sum, amount) => sum + amount);
  }
}
