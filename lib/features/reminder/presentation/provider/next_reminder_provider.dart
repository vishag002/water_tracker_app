import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/features/reminder/domain/calculators/next_reminder_calculator.dart';
import 'package:water_tracker_app/features/reminder/presentation/provider/reminder_provider.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';
import 'package:water_tracker_app/providers/water_goal_provider.dart';

/// Same "goal is stored in liters" convention used throughout Home and
/// History — the goal table's `unit` isn't user-editable yet.
const double _defaultGoalLiters = 2.0;

/// Combines the reminder configuration, today's goal, and today's intake
/// into the real next-reminder result via [NextReminderCalculator].
///
/// Fully reactive: recomputes whenever the reminder config changes
/// (toggling on/off, editing interval/start/end) OR whenever today's
/// water intake changes (a Quick Add on Home) — no manual refresh
/// needed, since both `currentReminderProvider` and
/// `todaysWaterIntakeMlProvider` are themselves backed by Drift streams.
///
/// `DateTime.now()` is read once per rebuild of this provider (i.e. each
/// time the reminder config or today's intake changes), rather than via
/// a running Timer — the screen doesn't need second-by-second ticking,
/// just to reflect the current schedule whenever something relevant
/// actually changes.
final nextReminderResultProvider = Provider<AsyncValue<NextReminderResult>>((
  ref,
) {
  final reminderAsync = ref.watch(currentReminderProvider);
  final goalAsync = ref.watch(currentWaterGoalProvider);
  // Provider<int>, not AsyncValue<int> — already resolved for "today" in
  // water_entry_provider.dart, defaults to 0 while its underlying stream
  // is still loading.
  final todayIntakeMl = ref.watch(todaysWaterIntakeMlProvider);

  if (reminderAsync.isLoading || goalAsync.isLoading) {
    return const AsyncValue.loading();
  }
  if (reminderAsync.hasError) {
    return AsyncValue.error(
      reminderAsync.error!,
      reminderAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (goalAsync.hasError) {
    return AsyncValue.error(
      goalAsync.error!,
      goalAsync.stackTrace ?? StackTrace.current,
    );
  }

  final reminder = reminderAsync.value;
  final goalMl = ((goalAsync.value?.goal ?? _defaultGoalLiters) * 1000)
      .round();

  final result = NextReminderCalculator.calculate(
    now: DateTime.now(),
    startTimeMinutes: reminder?.startTimeMinutes ?? 0,
    endTimeMinutes: reminder?.endTimeMinutes ?? 0,
    intervalMinutes: reminder?.intervalMinutes ?? 0,
    isEnabled: reminder?.isEnabled ?? false,
    todayIntakeMl: todayIntakeMl,
    todayGoalMl: goalMl,
  );

  return AsyncValue.data(result);
});
