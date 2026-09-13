import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/features/history/domain/calculators/monthly_history_calculator.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';
import 'package:water_tracker_app/providers/water_goal_provider.dart';

/// Same default the app seeds on first launch (see HomeScreen) — used
/// only as a display fallback before the real goal has loaded. Mirrors
/// weeklyHistoryProvider's fallback.
const int _defaultGoalLiters = 2;

/// Combines this month's entries with the current goal and runs them
/// through [MonthlyHistoryCalculator]. This is the single entry point
/// the Month tab's widgets watch — it does no calculation itself, only
/// wires reactive data together and hands it to the pure calculator.
///
/// Keyed by [monthStart], which must already be date-only and
/// normalized to the 1st of the month — see
/// [MonthlyHistoryCalculator.startOfMonth].
final monthlyHistoryProvider =
    Provider.family<AsyncValue<MonthlyHistoryResult>, DateTime>((
      ref,
      monthStart,
    ) {
      final normalizedStart = DateTime(monthStart.year, monthStart.month, 1);

      final entriesAsync = ref.watch(
        waterEntriesForMonthProvider(normalizedStart),
      );
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
      // liters for V1, same assumption HomeScreen and the Daily/Week
      // tabs make.
      final goalMl = (goalAsync.value?.goal ?? _defaultGoalLiters) * 1000;

      final result = MonthlyHistoryCalculator.calculate(
        monthStart: normalizedStart,
        entries: entries
            .map(
              (e) =>
                  MonthlyEntryInput(addedAt: e.addedAt, amountMl: e.amount),
            )
            .toList(),
        goalMl: goalMl,
      );

      return AsyncValue.data(result);
    });
