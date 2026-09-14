import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Application-facing reminder-configuration operations. Enforces the
/// "one reminder configuration per user" rule so callers never have to
/// think about insert-vs-update, and validates the values Drift itself
/// doesn't constrain (interval positivity, time-of-day range).
///
/// This repository intentionally does NOT schedule notifications or
/// compute the next reminder time — see reminders_table.dart for why
/// that derived state is deliberately excluded from persistence. That
/// layer comes later, on top of this one.
class ReminderRepository {
  ReminderRepository(this._db);
  final AppDatabase _db;

  static const int _minutesInDay = 1440;

  Future<Reminder?> getReminder(int userId) =>
      _db.remindersDao.getReminder(userId);

  Stream<Reminder?> watchReminder(int userId) =>
      _db.remindersDao.watchReminder(userId);

  /// Creates a reminder configuration if [userId] has none yet;
  /// otherwise updates the existing one. Callers don't need to know
  /// which case applies — this is what keeps `createReminder` from ever
  /// producing a second row for the same user.
  Future<void> createReminder({
    required int userId,
    required int intervalMinutes,
    required int startTimeMinutes,
    required int endTimeMinutes,
    required bool isEnabled,
  }) async {
    _validate(
      intervalMinutes: intervalMinutes,
      startTimeMinutes: startTimeMinutes,
      endTimeMinutes: endTimeMinutes,
    );

    final existing = await getReminder(userId);
    if (existing != null) {
      await updateReminder(
        userId: userId,
        intervalMinutes: intervalMinutes,
        startTimeMinutes: startTimeMinutes,
        endTimeMinutes: endTimeMinutes,
        isEnabled: isEnabled,
      );
      return;
    }

    await _db.remindersDao.createReminder(
      userId: userId,
      intervalMinutes: intervalMinutes,
      startTimeMinutes: startTimeMinutes,
      endTimeMinutes: endTimeMinutes,
      isEnabled: isEnabled,
    );
  }

  Future<void> updateReminder({
    required int userId,
    int? intervalMinutes,
    int? startTimeMinutes,
    int? endTimeMinutes,
    bool? isEnabled,
  }) async {
    _validate(
      intervalMinutes: intervalMinutes,
      startTimeMinutes: startTimeMinutes,
      endTimeMinutes: endTimeMinutes,
    );

    await _db.remindersDao.updateReminder(
      userId: userId,
      intervalMinutes: intervalMinutes != null
          ? Value(intervalMinutes)
          : const Value.absent(),
      startTimeMinutes: startTimeMinutes != null
          ? Value(startTimeMinutes)
          : const Value.absent(),
      endTimeMinutes: endTimeMinutes != null
          ? Value(endTimeMinutes)
          : const Value.absent(),
      isEnabled: isEnabled != null ? Value(isEnabled) : const Value.absent(),
    );
  }

  Future<void> deleteReminder(int userId) =>
      _db.remindersDao.deleteReminder(userId);

  /// Structural validation only — positive interval, times within a
  /// single day. Deliberately does NOT enforce startTime < endTime; the
  /// task explicitly leaves scheduling rules for a later layer.
  void _validate({
    int? intervalMinutes,
    int? startTimeMinutes,
    int? endTimeMinutes,
  }) {
    if (intervalMinutes != null && intervalMinutes <= 0) {
      throw ArgumentError.value(
        intervalMinutes,
        'intervalMinutes',
        'must be greater than zero',
      );
    }
    if (startTimeMinutes != null &&
        (startTimeMinutes < 0 || startTimeMinutes >= _minutesInDay)) {
      throw ArgumentError.value(
        startTimeMinutes,
        'startTimeMinutes',
        'must be within 0–${_minutesInDay - 1} (a single day)',
      );
    }
    if (endTimeMinutes != null &&
        (endTimeMinutes < 0 || endTimeMinutes >= _minutesInDay)) {
      throw ArgumentError.value(
        endTimeMinutes,
        'endTimeMinutes',
        'must be within 0–${_minutesInDay - 1} (a single day)',
      );
    }
  }
}
