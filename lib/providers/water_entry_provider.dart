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
