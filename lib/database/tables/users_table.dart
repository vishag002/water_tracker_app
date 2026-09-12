import 'package:drift/drift.dart';

/// Single-profile local storage — no auth, no multi-user support.
/// SQLite generates the id; there is never more than one row in practice.
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30)();
  IntColumn get age => integer().nullable()();
  RealColumn get weight => real().nullable()(); // kg
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
