import 'package:drift/drift.dart';

import 'users_table.dart';

/// One reminder configuration per user.
///
/// `startTime`/`endTime` are recurring daily clock times (e.g. "08:00"),
/// not timestamps — there's no calendar date attached to them. Drift
/// 2.34.0 has no built-in time-of-day column type, and the project
/// doesn't use custom SQLite types anywhere else (see WaterGoals/
/// WaterEntries — plain columns only), so the simplest fit is a plain
/// integer offset in minutes since midnight (0–1439), e.g. 08:00 -> 480.
///
/// Derived/notification state (next reminder, scheduled notification
/// ids, last-fired time, etc.) is intentionally NOT stored here — this
/// table only holds the user's configuration. That's computed later by
/// the notification/business-logic layer.
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Links this reminder configuration to the owning profile in the
  /// Users table.
  IntColumn get userId => integer().references(Users, #id)();

  IntColumn get intervalMinutes => integer()();

  /// Minutes since midnight (0–1439). e.g. 08:00 -> 480.
  IntColumn get startTimeMinutes => integer()();

  /// Minutes since midnight (0–1439). e.g. 20:00 -> 1200.
  IntColumn get endTimeMinutes => integer()();

  BoolColumn get isEnabled => boolean()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId}, // enforces the 1:1 relationship at the DB level
  ];
}