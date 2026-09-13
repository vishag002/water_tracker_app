/// Pure calculation logic for the History Week tab — no Flutter, Drift,
/// or Riverpod dependency, same separation used by other calculator
/// engines (e.g. DailyIntakeCalculator, features/water_calculator/domain).
library;

/// A single water entry reduced to only what this calculator needs.
/// Deliberately not the Drift-generated `WaterEntry` model, so this file
/// stays free of any database dependency and is trivial to unit test.
class WeeklyEntryInput {
  const WeeklyEntryInput({required this.addedAt, required this.amountMl});

  final DateTime addedAt;
  final int amountMl;
}

/// The calculated totals for a single day within the week.
class WeeklyDayBreakdown {
  const WeeklyDayBreakdown({
    required this.date,
    required this.totalMl,
    required this.entryCount,
    required this.goalReached,
  });

  /// Date-only (midnight) representation of this calendar day.
  final DateTime date;
  final int totalMl;
  final int entryCount;

  /// Whether [totalMl] met or exceeded the goal passed into
  /// [WeeklyHistoryCalculator.calculate]. Always `false` if no goal was
  /// supplied.
  final bool goalReached;
}

/// The full Monday-through-Sunday result for one week.
class WeeklyHistoryResult {
  const WeeklyHistoryResult({
    required this.weekStart,
    required this.weekEnd,
    required this.days,
    required this.totalIntakeMl,
    required this.totalEntries,
    required this.daysGoalReached,
    required this.goalMl,
  });

  /// Monday of this week, date-only.
  final DateTime weekStart;

  /// Sunday of this week, date-only.
  final DateTime weekEnd;

  /// Always exactly 7 entries, ordered Monday first, Sunday last.
  final List<WeeklyDayBreakdown> days;

  final int totalIntakeMl;
  final int totalEntries;

  /// How many of the 7 days reached the goal.
  final int daysGoalReached;

  /// The goal (in ml) each day was compared against, or `null` if none
  /// was supplied to [WeeklyHistoryCalculator.calculate].
  final int? goalMl;
}

class WeeklyHistoryCalculator {
  const WeeklyHistoryCalculator._();

  static const int daysInWeek = 7;

  /// Monday of the calendar week containing [date], normalized to
  /// date-only (no time-of-day component).
  static DateTime startOfWeek(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.subtract(
      Duration(days: dateOnly.weekday - DateTime.monday),
    );
  }

  /// Sunday of the calendar week containing [date], normalized to
  /// date-only.
  static DateTime endOfWeek(DateTime date) {
    return startOfWeek(date).add(const Duration(days: daysInWeek - 1));
  }

  /// Buckets [entries] into the 7 days of the week starting at
  /// [weekStart] and derives the weekly summary alongside them.
  ///
  /// [weekStart] must already be date-only and Monday-normalized (see
  /// [startOfWeek]) — this method does not re-derive it. [entries] is
  /// expected to already be restricted to this week by the caller's
  /// query; entries outside the range are ignored defensively rather
  /// than throwing.
  ///
  /// [goalMl] is optional so callers that don't yet have a goal loaded
  /// can still get totals back; every day's `goalReached` is simply
  /// `false` in that case.
  static WeeklyHistoryResult calculate({
    required DateTime weekStart,
    required List<WeeklyEntryInput> entries,
    int? goalMl,
  }) {
    final totalsMl = List<int>.filled(daysInWeek, 0);
    final counts = List<int>.filled(daysInWeek, 0);

    for (final entry in entries) {
      final dayIndex = entry.addedAt.difference(weekStart).inDays;
      if (dayIndex < 0 || dayIndex >= daysInWeek) continue;
      totalsMl[dayIndex] += entry.amountMl;
      counts[dayIndex] += 1;
    }

    final hasGoal = goalMl != null && goalMl > 0;

    final days = List.generate(daysInWeek, (index) {
      final totalMl = totalsMl[index];
      return WeeklyDayBreakdown(
        date: weekStart.add(Duration(days: index)),
        totalMl: totalMl,
        entryCount: counts[index],
        goalReached: hasGoal && totalMl >= goalMl,
      );
    });

    return WeeklyHistoryResult(
      weekStart: weekStart,
      weekEnd: weekStart.add(const Duration(days: daysInWeek - 1)),
      days: days,
      totalIntakeMl: totalsMl.fold(0, (sum, ml) => sum + ml),
      totalEntries: counts.fold(0, (sum, count) => sum + count),
      daysGoalReached: days.where((day) => day.goalReached).length,
      goalMl: hasGoal ? goalMl : null,
    );
  }
}
