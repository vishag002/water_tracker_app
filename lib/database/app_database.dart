import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/users_dao.dart';
import 'daos/water_goals_dao.dart';
import 'tables/users_table.dart';
import 'tables/water_goals_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, WaterGoals], daos: [UsersDao, WaterGoalsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Fresh installs: create every table at the current schema in one go.
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Existing installs on v1 (Users table only) just need the new
      // WaterGoals table added — nothing touches existing user rows.
      if (from < 2) {
        await m.createTable(waterGoals);
      }
    },
    beforeOpen: (details) async {
      // WaterGoals.userId references Users.id — SQLite doesn't enforce
      // foreign keys unless this is turned on per connection.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'water_tracker_db');
}
