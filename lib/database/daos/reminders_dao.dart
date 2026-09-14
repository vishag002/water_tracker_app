import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/reminders_table.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Future<Reminder?> getReminder(int userId) => (select(
    reminders,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Stream<Reminder?> watchReminder(int userId) => (select(
    reminders,
  )..where((t) => t.userId.equals(userId))).watchSingleOrNull();

  Future<int> createReminder({
    required int userId,
    required int intervalMinutes,
    required int startTimeMinutes,
    required int endTimeMinutes,
    required bool isEnabled,
  }) {
    final now = DateTime.now();
    return into(reminders).insert(
      RemindersCompanion.insert(
        userId: userId,
        intervalMinutes: intervalMinutes,
        startTimeMinutes: startTimeMinutes,
        endTimeMinutes: endTimeMinutes,
        isEnabled: isEnabled,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Partial update, scoped to the one reminder row owned by [userId].
  /// Fields left as `Value.absent()` are left untouched.
  Future<bool> updateReminder({
    required int userId,
    Value<int> intervalMinutes = const Value.absent(),
    Value<int> startTimeMinutes = const Value.absent(),
    Value<int> endTimeMinutes = const Value.absent(),
    Value<bool> isEnabled = const Value.absent(),
  }) async {
    final rows =
        await (update(reminders)..where((t) => t.userId.equals(userId))).write(
          RemindersCompanion(
            intervalMinutes: intervalMinutes,
            startTimeMinutes: startTimeMinutes,
            endTimeMinutes: endTimeMinutes,
            isEnabled: isEnabled,
            updatedAt: Value(DateTime.now()),
          ),
        );
    return rows > 0;
  }

  Future<int> deleteReminder(int userId) =>
      (delete(reminders)..where((t) => t.userId.equals(userId))).go();
}
