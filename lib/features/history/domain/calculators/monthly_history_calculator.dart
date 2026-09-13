/// Pure calculation logic for the History Month tab — no Flutter, Drift,
/// or Riverpod dependency, same separation used by other calculator
/// engines (e.g. WeeklyHistoryCalculator, DailyIntakeCalculator).
library;

/// A single water entry reduced to only what this calculator needs.
/// Deliberately not the Drift-generated `WaterEntry` model, so this file
/// stays free of any database dependency and is trivial to unit test.
class MonthlyEntryInput {
  const MonthlyEntryInput({required this.addedAt, required this.amountMl});

  final DateTime addedAt;
  final int amountMl;
}

/// The calculated totals for a single day within the month.
class MonthlyDayBreakdown {
  const MonthlyDayBreakdown({
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
  /// [MonthlyHistoryCalculator.calculate]. Always `false` if no goal was
  /// supplied.
  final bool goalReached;
}

/// The full result for one calendar month.
class MonthlyHistoryResult {
  const MonthlyHistoryResult({
    required this.monthStart,
    required this.monthEnd,
    required this.days,
    required this.totalIntakeMl,
    required this.totalEntries,
    required this.daysGoalReached,
    required this.goalMl,
    required this.firstWeekdayIndex,
    required this.elapsedDays,
    required this.completionPercent,
  });

  /// Day 1 of this month, date-only.
  final DateTime monthStart;

  /// Day 1 of the *next* month, date-only — exclusive upper bound, same
  /// [start, end) convention as the range queries in WaterEntriesDao.
  final DateTime monthEnd;

  /// One entry per calendar day in the month (28–31), ordered from the
  /// 1st to the last day. Days with zero entries are still included.
  final List<MonthlyDayBreakdown> days;

  final int totalIntakeMl;
  final int totalEntries;

  /// How many days in the month reached the goal.
  final int daysGoalReached;

  /// The goal (in ml) each day was compared against, or `null` if none
  /// was supplied to [MonthlyHistoryCalculator.calculate].
  final int? goalMl;

  /// Index (0 = Monday ... 6 = Sunday) of [monthStart]'s weekday, i.e.
  /// how many leading blank cells a 7-column calendar grid needs before
  /// day 1 so weekdays line up under a Mon–Sun header.
  final int firstWeekdayIndex;

  /// The day count [completionPercent] is measured against: "today"'s
  /// day-of-month for the current month, the full day count for a past
  /// month, or `0` for a month that hasn't started yet. See
  /// [MonthlyHistoryCalculator.calculate] for the exact rule.
  final int elapsedDays;

  /// `daysGoalReached / elapsedDays * 100`, or `0` if [elapsedDays] is
  /// `0` (an unstarted future month). Not persisted — recalculated every
  /// time from [days].
  final double completionPercent;
}

class MonthlyHistoryCalculator {
  const MonthlyHistoryCalculator._();

  /// Day 1 of the calendar month containing [date], normalized to
  /// date-only (no time-of-day component).
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Day 1 of the month *after* the one containing [date] — the
  /// exclusive end of the [startOfMonth, endOfMonth) range.
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1);
  }

  /// Number of days in the calendar month starting at [monthStart].
  /// [monthStart] must already be date-only and normalized to the 1st —
  /// see [startOfMonth]. Correctly handles 28/29-day Februaries and
  /// 30/31-day months via Drift/Dart's day-0-of-next-month trick.
  static int daysInMonth(DateTime monthStart) {
    return DateTime(monthStart.year, monthStart.month + 1, 0).day;
  }

  /// Buckets [entries] into every day of the month starting at
  /// [monthStart] and derives the monthly summary alongside them.
  ///
  /// [monthStart] must already be date-only and normalized to the 1st
  /// (see [startOfMonth]) — this method does not re-derive it. [entries]
  /// is expected to already be restricted to this month by the caller's
  /// range query; entries outside the range are ignored defensively
  /// rather than throwing.
  ///
  /// [goalMl] is optional so callers that don't yet have a goal loaded
  /// can still get totals back; every day's `goalReached` is simply
  /// `false` in that case.
  ///
  /// [now] defaults to [DateTime.now] and only affects
  /// [MonthlyHistoryResult.completionPercent] — see that field and
  /// [_elapsedDays] for the exact rule. Exposed as a parameter purely so
  /// this stays unit-testable without depending on the real clock.
  static MonthlyHistoryResult calculate({
    required DateTime monthStart,
    required List<MonthlyEntryInput> entries,
    int? goalMl,
    DateTime? now,
  }) {
    final normalizedStart = DateTime(monthStart.year, monthStart.month, 1);
    final totalDays = daysInMonth(normalizedStart);

    final totalsMl = List<int>.filled(totalDays, 0);
    final counts = List<int>.filled(totalDays, 0);

    for (final entry in entries) {
      final dayIndex = entry.addedAt.difference(normalizedStart).inDays;
      if (dayIndex < 0 || dayIndex >= totalDays) continue;
      totalsMl[dayIndex] += entry.amountMl;
      counts[dayIndex] += 1;
    }

    final hasGoal = goalMl != null && goalMl > 0;

    final days = List.generate(totalDays, (index) {
      final totalMl = totalsMl[index];
      return MonthlyDayBreakdown(
        date: normalizedStart.add(Duration(days: index)),
        totalMl: totalMl,
        entryCount: counts[index],
        goalReached: hasGoal && totalMl >= goalMl,
      );
    });

    final daysGoalReached = days.where((day) => day.goalReached).length;
    final elapsedDays = _elapsedDays(
      normalizedStart: normalizedStart,
      totalDays: totalDays,
      now: now ?? DateTime.now(),
    );
    final completionPercent = elapsedDays > 0
        ? (daysGoalReached / elapsedDays) * 100
        : 0.0;

    return MonthlyHistoryResult(
      monthStart: normalizedStart,
      monthEnd: DateTime(normalizedStart.year, normalizedStart.month + 1, 1),
      days: days,
      totalIntakeMl: totalsMl.fold(0, (sum, ml) => sum + ml),
      totalEntries: counts.fold(0, (sum, count) => sum + count),
      daysGoalReached: daysGoalReached,
      goalMl: hasGoal ? goalMl : null,
      // DateTime.weekday is 1 (Monday) .. 7 (Sunday); shift to a
      // 0-based Monday-first index for grid math.
      firstWeekdayIndex: normalizedStart.weekday - DateTime.monday,
      elapsedDays: elapsedDays,
      completionPercent: completionPercent,
    );
  }

  /// The denominator for [MonthlyHistoryResult.completionPercent]:
  /// - Current month (same year+month as [now]): the number of days
  ///   elapsed so far, i.e. `now.day` (today counts as elapsed).
  /// - A month entirely before [now]'s month: the full [totalDays] —
  ///   it's over, so completion is measured against every day it had.
  /// - A month entirely after [now]'s month (shouldn't normally be
  ///   reachable from the UI, but handled defensively): `0`, since none
  ///   of its days have happened yet.
  static int _elapsedDays({
    required DateTime normalizedStart,
    required int totalDays,
    required DateTime now,
  }) {
    final isCurrentMonth =
        normalizedStart.year == now.year && normalizedStart.month == now.month;
    if (isCurrentMonth) return now.day;

    final isFutureMonth = normalizedStart.isAfter(
      DateTime(now.year, now.month, now.day),
    );
    if (isFutureMonth) return 0;

    return totalDays;
  }
}
