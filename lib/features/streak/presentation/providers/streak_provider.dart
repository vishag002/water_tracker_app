import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/features/streak/domain/calculators/streak_calculator.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';
import 'package:water_tracker_app/providers/water_goal_provider.dart';

/// Same default the app seeds on first launch (see HomeScreen) — used
/// only as a display fallback before the real goal has loaded. Mirrors
/// weeklyHistoryProvider/monthlyHistoryProvider's fallback.
const int _defaultGoalLiters = 2;

/// Combines the user's *entire* entry history with the current goal and
/// runs them through [StreakCalculator]. This is the single entry point
/// every Streak widget watches — it does no calculation itself, only
/// wires reactive data together and hands it to the pure calculator.
///
/// Keyed by [calendarMonth] (any date within the month the calendar UI
/// is currently showing) — this only affects the returned
/// [StreakResult.dailyStatuses]/[StreakResult.goalDays]/
/// [StreakResult.completionPercent]. `currentStreak`/`longestStreak`
/// always come from the full history regardless of which month is
/// passed in, per the calculator's contract.
///
/// Deliberately watches [currentUserWaterEntriesProvider] (the same
/// all-history stream Home/DailyHistory already rely on) rather than a
/// month-bounded range query — current/longest streak need the whole
/// history, and this keeps it to one stream instead of a second query
/// mechanism just for Streak.
final streakProvider =
    Provider.family<AsyncValue<StreakResult>, DateTime>((ref, calendarMonth) {
      final entriesAsync = ref.watch(currentUserWaterEntriesProvider);
      final goalAsync = ref.watch(currentWaterGoalProvider);

      if (entriesAsync.isLoading || goalAsync.isLoading) {
        return const AsyncValue.loading();
      }
      if (entriesAsync.hasError) {
        return AsyncValue.error(
          entriesAsync.error!,
          entriesAsync.stackTrace ?? StackTrace.current,
        );
      }
      if (goalAsync.hasError) {
        return AsyncValue.error(
          goalAsync.error!,
          goalAsync.stackTrace ?? StackTrace.current,
        );
      }

      final entries = entriesAsync.value ?? const [];
      // The goal table's `unit` isn't user-selectable yet (see
      // WaterGoalEditDialog) — goals are always entered and stored in
      // liters for V1, same assumption Daily/Week/Month make.
      final goalMl = (goalAsync.value?.goal ?? _defaultGoalLiters) * 1000;

      final result = StreakCalculator.calculate(
        entries: entries
            .map(
              (e) => StreakEntryInput(addedAt: e.addedAt, amountMl: e.amount),
            )
            .toList(),
        calendarMonth: calendarMonth,
        goalMl: goalMl,
      );

      return AsyncValue.data(result);
    });
