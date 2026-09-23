import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/features/history/domain/calculators/weekly_history_calculator.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_entry_provider.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_goal_provider.dart';

/// Same default the app seeds on first launch (see HomeScreen) — used
/// only as a display fallback before the real goal has loaded.
const double _defaultGoalLiters = 2.0;

/// Combines this week's entries with the current goal and runs them
/// through [WeeklyHistoryCalculator]. This is the single entry point the
/// Week tab's widgets watch — it does no calculation itself, only wires
/// reactive data together and hands it to the pure calculator.
///
/// Keyed by [weekStart], which must already be date-only and
/// Monday-normalized — see [WeeklyHistoryCalculator.startOfWeek].
final weeklyHistoryProvider =
    Provider.family<AsyncValue<WeeklyHistoryResult>, DateTime>((
      ref,
      weekStart,
    ) {
      final entriesAsync = ref.watch(waterEntriesForWeekProvider(weekStart));
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
      // liters for V1, same assumption HomeScreen and the Daily tab make.
      final goalMl = ((goalAsync.value?.goal ?? _defaultGoalLiters) * 1000)
          .round();

      final result = WeeklyHistoryCalculator.calculate(
        weekStart: weekStart,
        entries: entries
            .map(
              (e) =>
                  WeeklyEntryInput(addedAt: e.addedAt, amountMl: e.amount),
            )
            .toList(),
        goalMl: goalMl,
      );

      return AsyncValue.data(result);
    });
