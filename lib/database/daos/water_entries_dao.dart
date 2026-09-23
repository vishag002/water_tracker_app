import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/water_entries_table.dart';

part 'water_entries_dao.g.dart';

@DriftAccessor(tables: [WaterEntries])
class WaterEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$WaterEntriesDaoMixin {
  WaterEntriesDao(super.db);

  Future<int> addEntry({
    required int userId,
    required int amount,
    required String unit,
    DateTime? addedAt,
  }) {
    return into(waterEntries).insert(
      WaterEntriesCompanion.insert(
        userId: userId,
        amount: amount,
        unit: unit,
        addedAt: addedAt ?? DateTime.now(),
      ),
    );
  }

  Future<List<WaterEntry>> getEntries(int userId) {
    return (select(waterEntries)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();
  }

  Stream<List<WaterEntry>> watchEntries(int userId) {
    return (select(waterEntries)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .watch();
  }

  Future<List<WaterEntry>> getEntriesForDay(int userId, DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(waterEntries)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.addedAt.isBiggerOrEqualValue(start) &
                t.addedAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();
  }

  Stream<List<WaterEntry>> watchEntriesForDay(int userId, DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(waterEntries)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.addedAt.isBiggerOrEqualValue(start) &
                t.addedAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .watch();
  }

  /// Entries in [start, end) — end-exclusive, same convention as the
  /// single-day queries above. Used for the History Week tab so the
  /// whole week is fetched in one query instead of seven.
  Future<List<WaterEntry>> getEntriesForRange(
    int userId,
    DateTime start,
    DateTime end,
  ) {
    return (select(waterEntries)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.addedAt.isBiggerOrEqualValue(start) &
                t.addedAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();
  }

  Stream<List<WaterEntry>> watchEntriesForRange(
    int userId,
    DateTime start,
    DateTime end,
  ) {
    return (select(waterEntries)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.addedAt.isBiggerOrEqualValue(start) &
                t.addedAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .watch();
  }

  Future<int> deleteEntry(int id) {
    return (delete(waterEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Updates only the amount for an existing entry — `addedAt` is left
  /// untouched, matching the "time can't be edited" rule for the History
  /// timeline edit dialog.
  Future<int> updateAmount(int id, int amount) {
    return (update(waterEntries)..where((t) => t.id.equals(id))).write(
      WaterEntriesCompanion(amount: Value(amount)),
    );
  }
}
