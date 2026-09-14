/// Pure, side-effect-free reminder-scheduling calculator.
///
/// No Drift, no Riverpod, no Flutter, no notification APIs — only
/// DateTime math — so this is trivial to unit test on its own and safe
/// to reuse later from the native notification scheduler.
library;

/// Why [NextReminderResult.nextReminder] is `null`, when it is. Lets the
/// UI show a specific empty state without re-deriving the same
/// enabled/goal/window comparisons the calculator already made.
enum NextReminderUnavailableReason {
  /// Not applicable — `nextReminder` is non-null.
  none,

  /// `isEnabled` was false.
  disabled,

  /// Today's intake has already met or passed today's goal.
  goalReached,

  /// Reminders are enabled and the goal isn't reached yet, but every
  /// scheduled slot for today is either already past or the interval/
  /// window configuration produces no valid slot at all.
  windowEnded,
}

class NextReminderResult {
  const NextReminderResult({
    required this.nextReminder,
    required this.upcomingReminders,
    required this.reason,
  });

  /// The next scheduled reminder strictly after `now`, or `null` if none
  /// is due today.
  final DateTime? nextReminder;

  /// [nextReminder] plus a handful of subsequent slots today, for a UI
  /// timeline. Always empty when [nextReminder] is `null`. Never longer
  /// than the `maxUpcoming` passed to [NextReminderCalculator.calculate].
  final List<DateTime> upcomingReminders;

  /// Why there's no reminder, when there isn't one. [
  /// NextReminderUnavailableReason.none] whenever [nextReminder] is
  /// non-null.
  final NextReminderUnavailableReason reason;
}

class NextReminderCalculator {
  const NextReminderCalculator._();

  static const _unavailable = NextReminderResult(
    nextReminder: null,
    upcomingReminders: [],
    reason: NextReminderUnavailableReason.windowEnded,
  );

  /// Computes the next reminder (and a short upcoming list) for "today",
  /// where "today" is [now]'s calendar date.
  ///
  /// The schedule is anchored to [startTimeMinutes] and stepped by
  /// [intervalMinutes] — never `now + interval`, which would drift every
  /// time this is recalculated. A slot is valid if it falls within
  /// `[startTimeMinutes, endTimeMinutes]` (inclusive on both ends), and
  /// the returned reminder is always the first valid slot *strictly
  /// after* [now] — a slot equal to [now] doesn't count, per the
  /// "current time exactly on a slot" rule.
  ///
  /// Returns [NextReminderUnavailableReason.disabled] immediately if
  /// [isEnabled] is false, and [NextReminderUnavailableReason.goalReached]
  /// immediately if [todayIntakeMl] has met or passed [todayGoalMl] —
  /// neither check needs to look at the schedule at all.
  ///
  /// Only ever looks at today's slots; it does not roll over to
  /// tomorrow's start time once today's window has passed.
  static NextReminderResult calculate({
    required DateTime now,
    required int startTimeMinutes,
    required int endTimeMinutes,
    required int intervalMinutes,
    required bool isEnabled,
    required int todayIntakeMl,
    required int todayGoalMl,
    int maxUpcoming = 4,
  }) {
    if (!isEnabled) {
      return const NextReminderResult(
        nextReminder: null,
        upcomingReminders: [],
        reason: NextReminderUnavailableReason.disabled,
      );
    }

    // The goal is a target, not a ceiling: reaching OR passing it stops
    // reminders for the rest of the day.
    if (todayIntakeMl >= todayGoalMl) {
      return const NextReminderResult(
        nextReminder: null,
        upcomingReminders: [],
        reason: NextReminderUnavailableReason.goalReached,
      );
    }

    // Defensive — the repository layer already rejects intervalMinutes
    // <= 0, but a calculator with no Drift/Riverpod visibility shouldn't
    // assume its caller always validated first.
    if (intervalMinutes <= 0) {
      return _unavailable;
    }

    final slots = <DateTime>[];
    var slotMinutes = startTimeMinutes;

    while (slotMinutes <= endTimeMinutes) {
      final slot = DateTime(
        now.year,
        now.month,
        now.day,
        slotMinutes ~/ 60,
        slotMinutes % 60,
      );

      // Strictly after `now` — a slot equal to `now` has already fired.
      if (slot.isAfter(now)) {
        slots.add(slot);
        if (slots.length >= maxUpcoming) break;
      }

      slotMinutes += intervalMinutes;
    }

    if (slots.isEmpty) {
      return _unavailable;
    }

    return NextReminderResult(
      nextReminder: slots.first,
      upcomingReminders: slots,
      reason: NextReminderUnavailableReason.none,
    );
  }
}
