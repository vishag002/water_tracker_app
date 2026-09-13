import 'package:drift/drift.dart';

import 'users_table.dart';

class WaterEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Links this entry to the owning profile in the Users table.
  IntColumn get userId => integer().references(Users, #id)();

  /// The amount consumed, in whatever `unit` says.
  IntColumn get amount => integer()();

  /// e.g. 'ml' or 'oz'.
  TextColumn get unit => text().withLength(min: 1, max: 5)();

  DateTimeColumn get addedAt => dateTime()();
}
