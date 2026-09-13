import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/screens/home/domain/calculators/daily_intake_calculator.dart';

import '../database/app_database.dart';
import '../repositories/water_entry_repository.dart';
import 'user_name_provider.dart';

final waterEntryRepositoryProvider = Provider<WaterEntryRepository>((ref) {
  return WaterEntryRepository(ref.watch(appDatabaseProvider));
});

/// Live list of all of the current user's entries, newest first.
final currentUserWaterEntriesProvider = StreamProvider<List<WaterEntry>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(const []);

  return ref.watch(waterEntryRepositoryProvider).watchEntries(user.id);
});

/// Live list of the current user's entries for one specific day.
/// Pass midnight-normalized or any DateTime for that calendar day.
final waterEntriesForDayProvider =
    StreamProvider.family<List<WaterEntry>, DateTime>((ref, day) {
      final user = ref.watch(currentUserProvider).value;
      if (user == null) return Stream.value(const []);

      return ref
          .watch(waterEntryRepositoryProvider)
          .watchEntriesForDay(user.id, day);
    });

/// Live list of the current user's entries for a 7-day window starting
/// at [weekStart]. [weekStart] must already be date-only and normalized
/// to Monday — see `WeeklyHistoryCalculator.startOfWeek`. Powers the
/// History Week tab.
final waterEntriesForWeekProvider =
    StreamProvider.family<List<WaterEntry>, DateTime>((ref, weekStart) {
      final user = ref.watch(currentUserProvider).value;
      if (user == null) return Stream.value(const []);

      final weekEnd = weekStart.add(const Duration(days: 7));
      return ref
          .watch(waterEntryRepositoryProvider)
          .watchEntriesForRange(user.id, weekStart, weekEnd);
    });

/// Live list of the current user's entries for the calendar month
/// starting at [monthStart]. [monthStart] must already be date-only and
/// normalized to the 1st of the month — see
/// `MonthlyHistoryCalculator.startOfMonth`. Powers the History Month tab.
/// Reuses the same generic `watchEntriesForRange` query as
/// [waterEntriesForWeekProvider] — one query for the whole month instead
/// of one per day.
final waterEntriesForMonthProvider =
    StreamProvider.family<List<WaterEntry>, DateTime>((ref, monthStart) {
      final user = ref.watch(currentUserProvider).value;
      if (user == null) return Stream.value(const []);

      final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 1);
      return ref
          .watch(waterEntryRepositoryProvider)
          .watchEntriesForRange(user.id, monthStart, monthEnd);
    });

/// "Today", resolved once per provider read. Note: this does not
/// automatically roll over at midnight while the app stays open in the
/// background — acceptable for MVP, worth revisiting if that becomes
/// a real issue in testing.
final todaysWaterEntriesProvider = Provider<AsyncValue<List<WaterEntry>>>((
  ref,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day); // date-only, stable
  return ref.watch(waterEntriesForDayProvider(today));
});

/// Derived from todaysWaterEntriesProvider — the actual sum lives in
/// DailyIntakeCalculator, not here or in the widget. This provider just
/// wires the reactive plumbing together.
final todaysWaterIntakeMlProvider = Provider<int>((ref) {
  final entries = ref.watch(todaysWaterEntriesProvider).value ?? const [];
  return DailyIntakeCalculator.totalMl(entries.map((e) => e.amount).toList());
});
