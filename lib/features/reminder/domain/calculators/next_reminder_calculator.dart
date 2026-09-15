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

  /// Raw minute-of-day slots for `[startTimeMinutes, endTimeMinutes]`
  /// stepped by `intervalMinutes` — no "now" filtering, no goal check.
  /// This is the single source of truth for "what times does this
  /// window+interval config represent", shared by the on-screen
  /// calculator (below) and by notification scheduling, so the two
  /// never drift into disagreeing about the schedule.
  static List<int> generateSlotMinutes({
    required int startTimeMinutes,
    required int endTimeMinutes,
    required int intervalMinutes,
  }) {
    if (intervalMinutes <= 0) return const [];

    final slots = <int>[];
    var slotMinutes = startTimeMinutes;
    while (slotMinutes <= endTimeMinutes) {
      slots.add(slotMinutes);
      slotMinutes += intervalMinutes;
    }
    return slots;
  }

  /// Single source of truth for "which reminder slots are still valid
  /// today, right now" — shared by the on-screen [calculate] (which
  /// caps the result at `maxUpcoming` for the UI timeline) and by
  /// notification scheduling (which needs every remaining slot, since
  /// each one becomes a scheduled OS notification).
  ///
  /// Applies every gating rule exactly once:
  /// 1. `isEnabled` false -> empty.
  /// 2. `todayIntakeMl >= todayGoalMl` -> empty.
  /// 3. Slots are generated from the interval/start/end window via
  ///    [generateSlotMinutes] (already guards `intervalMinutes <= 0`).
  /// 4. Only slots strictly after `now` are returned — a slot exactly
  ///    equal to `now` is excluded, and nothing capped.
  static List<DateTime> remainingSlotsToday({
    required DateTime now,
    required int startTimeMinutes,
    required int endTimeMinutes,
    required int intervalMinutes,
    required bool isEnabled,
    required int todayIntakeMl,
    required int todayGoalMl,
  }) {
    if (!isEnabled) return const [];
    if (todayIntakeMl >= todayGoalMl) return const [];

    final slotMinutesList = generateSlotMinutes(
      startTimeMinutes: startTimeMinutes,
      endTimeMinutes: endTimeMinutes,
      intervalMinutes: intervalMinutes,
    );
    if (slotMinutesList.isEmpty) return const [];

    final slots = <DateTime>[];
    for (final minutes in slotMinutesList) {
      final slot = DateTime(
        now.year,
        now.month,
        now.day,
        minutes ~/ 60,
        minutes % 60,
      );
      if (slot.isAfter(now)) slots.add(slot);
    }
    return slots;
  }

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

    if (todayIntakeMl >= todayGoalMl) {
      return const NextReminderResult(
        nextReminder: null,
        upcomingReminders: [],
        reason: NextReminderUnavailableReason.goalReached,
      );
    }

    final slots = remainingSlotsToday(
      now: now,
      startTimeMinutes: startTimeMinutes,
      endTimeMinutes: endTimeMinutes,
      intervalMinutes: intervalMinutes,
      isEnabled: isEnabled,
      todayIntakeMl: todayIntakeMl,
      todayGoalMl: todayGoalMl,
    );

    if (slots.isEmpty) return _unavailable;

    final capped = slots.length > maxUpcoming
        ? slots.sublist(0, maxUpcoming)
        : slots;

    return NextReminderResult(
      nextReminder: capped.first,
      upcomingReminders: capped,
      reason: NextReminderUnavailableReason.none,
    );
  }
}
