/// Pure calculation logic for the Streak screen — no Flutter, Drift, or
/// Riverpod dependency, same separation used by other calculator engines
/// (e.g. WeeklyHistoryCalculator, MonthlyHistoryCalculator,
/// DailyIntakeCalculator).
library;

/// A single water entry reduced to only what this calculator needs.
/// Deliberately not the Drift-generated `WaterEntry` model, so this file
/// stays free of any database dependency and is trivial to unit test.
class StreakEntryInput {
  const StreakEntryInput({required this.addedAt, required this.amountMl});

  final DateTime addedAt;
  final int amountMl;
}

/// Hydration outcome for a single calendar day.
///
/// [noData] covers both "before the user ever logged anything" and
/// "a future day that hasn't happened yet" — both are rendered with the
/// same neutral calendar appearance and neither counts as a missed day.
enum DayStreakStatus { noData, missed, success }

/// One calendar day as shown on the Streak calendar.
class StreakDayStatus {
  const StreakDayStatus({
    required this.date,
    required this.status,
    required this.isToday,
  });

  /// Date-only (midnight) representation of this calendar day.
  final DateTime date;
  final DayStreakStatus status;
  final bool isToday;
}

/// The full result the Streak screen watches.
class StreakResult {
  const StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.calendarMonthStart,
    required this.dailyStatuses,
    required this.goalDays,
    required this.elapsedDays,
    required this.completionPercent,
    required this.goalMl,
  });

  /// Consecutive successful days ending TODAY. `0` if today hasn't (yet)
  /// reached the goal, or if the user has no entries at all. Calculated
  /// over the user's *entire* stored history, independent of
  /// [calendarMonthStart].
  final int currentStreak;

  /// The longest run of consecutive successful days anywhere in the
  /// user's stored history, up to and including today. Never resets
  /// when [currentStreak] breaks — it's the best-ever run.
  final int longestStreak;

  /// Day 1 of the month the calendar is currently showing (date-only).
  final DateTime calendarMonthStart;

  /// One entry per calendar day in [calendarMonthStart]'s month,
  /// ordered from the 1st to the last day.
  final List<StreakDayStatus> dailyStatuses;

  /// Days within [calendarMonthStart]'s month where the goal was
  /// reached. Days with no entries are not counted.
  final int goalDays;

  /// The day count [completionPercent] is measured against: "today"'s
  /// day-of-month if [calendarMonthStart] is the current month, the
  /// full day count for a past month, or `0` for a month that hasn't
  /// started yet.
  final int elapsedDays;

  /// `goalDays / elapsedDays * 100` for [calendarMonthStart]'s month,
  /// or `0` if [elapsedDays] is `0`. Not persisted — recalculated every
  /// time from [dailyStatuses].
  final double completionPercent;

  /// The goal (in ml) each day was compared against, or `null` if none
  /// was supplied to [StreakCalculator.calculate].
  final int? goalMl;
}

class StreakCalculator {
  const StreakCalculator._();

  /// Buckets [entries] by calendar day, then derives:
  /// - [StreakResult.currentStreak] and [StreakResult.longestStreak]
  ///   over the user's *entire* history (from their earliest entry
  ///   through today — never before they started logging, never past
  ///   today).
  /// - [StreakResult.dailyStatuses], [StreakResult.goalDays], and
  ///   [StreakResult.completionPercent] scoped to the single month
  ///   containing [calendarMonth] (whatever month the calendar UI is
  ///   currently showing).
  ///
  /// [entries] should be the user's full, unfiltered history — this
  /// method does its own day-bucketing and range restriction, so the
  /// caller does not need to pre-filter by month.
  ///
  /// [goalMl] is optional so callers that don't yet have a goal loaded
  /// can still get a result back; no day is ever "successful" without a
  /// goal.
  ///
  /// [now] defaults to [DateTime.now] and is exposed as a parameter
  /// purely so this stays unit-testable without depending on the real
  /// clock.
  static StreakResult calculate({
    required List<StreakEntryInput> entries,
    required DateTime calendarMonth,
    int? goalMl,
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final hasGoal = goalMl != null && goalMl > 0;

    // Sum intake per calendar day across the whole history in one pass.
    final totalsByDate = <DateTime, int>{};
    for (final entry in entries) {
      final date = _dateOnly(entry.addedAt);
      totalsByDate[date] = (totalsByDate[date] ?? 0) + entry.amountMl;
    }

    bool isSuccess(DateTime date) {
      final total = totalsByDate[date];
      return hasGoal && total != null && total >= goalMl;
    }

    // Earliest day the user ever logged anything — days before this are
    // simply never scanned, so they can't count as "missed" or break a
    // streak. A brand-new user with no entries at all falls through to
    // the `earliestDate == null` branches below, giving 0/0/no-data.
    DateTime? earliestDate;
    for (final date in totalsByDate.keys) {
      if (earliestDate == null || date.isBefore(earliestDate)) {
        earliestDate = date;
      }
    }

    final currentStreak = _currentStreak(
      earliestDate: earliestDate,
      today: today,
      isSuccess: isSuccess,
    );

    final longestStreak = _longestStreak(
      earliestDate: earliestDate,
      today: today,
      isSuccess: isSuccess,
    );

    final calendarMonthStart = DateTime(
      calendarMonth.year,
      calendarMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      calendarMonthStart.year,
      calendarMonthStart.month + 1,
      0,
    ).day;

    final dailyStatuses = List.generate(daysInMonth, (index) {
      final date = calendarMonthStart.add(Duration(days: index));
      final isToday = date == today;

      // A future day hasn't happened yet — neutral "no data", same as
      // before the user's history starts. It must never read as missed.
      if (date.isAfter(today)) {
        return StreakDayStatus(
          date: date,
          status: DayStreakStatus.noData,
          isToday: isToday,
        );
      }

      final total = totalsByDate[date];
      final status = total == null
          ? DayStreakStatus.noData
          : (hasGoal && total >= goalMl)
          ? DayStreakStatus.success
          : DayStreakStatus.missed;

      return StreakDayStatus(date: date, status: status, isToday: isToday);
    });

    final goalDays = dailyStatuses
        .where((day) => day.status == DayStreakStatus.success)
        .length;

    final elapsedDays = _elapsedDays(
      normalizedStart: calendarMonthStart,
      totalDays: daysInMonth,
      today: today,
    );
    final completionPercent = elapsedDays > 0
        ? (goalDays / elapsedDays) * 100
        : 0.0;

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      calendarMonthStart: calendarMonthStart,
      dailyStatuses: dailyStatuses,
      goalDays: goalDays,
      elapsedDays: elapsedDays,
      completionPercent: completionPercent,
      goalMl: hasGoal ? goalMl : null,
    );
  }

  /// Consecutive successful days walking backward from [today]. Stops
  /// (without counting) the moment a day is missing or unsuccessful, or
  /// once it steps before [earliestDate] — so a user with no history at
  /// all, or whose today hasn't reached the goal yet, always gets `0`.
  static int _currentStreak({
    required DateTime? earliestDate,
    required DateTime today,
    required bool Function(DateTime date) isSuccess,
  }) {
    if (earliestDate == null) return 0;

    var streak = 0;
    var date = today;
    while (!date.isBefore(earliestDate)) {
      if (!isSuccess(date)) break;
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// The longest run of consecutive successful days anywhere between
  /// [earliestDate] and [today] inclusive. A day with no entries (or
  /// one below goal) resets the running count, exactly like a missed
  /// day — it just never runs before [earliestDate], per the "don't
  /// treat pre-history as missed" rule.
  static int _longestStreak({
    required DateTime? earliestDate,
    required DateTime today,
    required bool Function(DateTime date) isSuccess,
  }) {
    if (earliestDate == null) return 0;

    var longest = 0;
    var running = 0;
    var date = earliestDate;
    while (!date.isAfter(today)) {
      if (isSuccess(date)) {
        running++;
        if (running > longest) longest = running;
      } else {
        running = 0;
      }
      date = date.add(const Duration(days: 1));
    }
    return longest;
  }

  /// The denominator for [StreakResult.completionPercent] — same rule
  /// as MonthlyHistoryCalculator's completion:
  /// - Current month (same year+month as [today]): days elapsed so far,
  ///   i.e. `today.day` (today counts as elapsed).
  /// - A month entirely before [today]'s month: the full [totalDays].
  /// - A month entirely after [today]'s month (defensive — the Streak
  ///   calendar shouldn't normally navigate past the current month):
  ///   `0`, since none of its days have happened yet.
  static int _elapsedDays({
    required DateTime normalizedStart,
    required int totalDays,
    required DateTime today,
  }) {
    final isCurrentMonth =
        normalizedStart.year == today.year &&
        normalizedStart.month == today.month;
    if (isCurrentMonth) return today.day;

    if (normalizedStart.isAfter(today)) return 0;

    return totalDays;
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
