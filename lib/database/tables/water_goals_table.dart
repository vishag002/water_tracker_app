import 'package:drift/drift.dart';

import 'users_table.dart';

class WaterGoals extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Links this goal to the owning profile in the Users table.
  IntColumn get userId => integer().references(Users, #id)();

  /// Stored as a plain integer amount in whatever `unit` says, e.g. 2500.
  IntColumn get goal => integer()();

  /// e.g. 'ml' or 'oz'.
  TextColumn get unit => text().withLength(min: 1, max: 5)();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId}, // enforces the 1:1 relationship at the DB level
  ];
}
