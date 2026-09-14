import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/reminders_dao.dart';
import 'daos/users_dao.dart';
import 'daos/water_entries_dao.dart';
import 'daos/water_goals_dao.dart';
import 'tables/reminders_table.dart';
import 'tables/users_table.dart';
import 'tables/water_entries_table.dart';
import 'tables/water_goals_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Users, WaterGoals, WaterEntries, Reminders],
  daos: [UsersDao, WaterGoalsDao, WaterEntriesDao, RemindersDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Fresh installs: create every table at the current schema in one go.
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Each branch only adds what that version introduced — existing
      // rows in earlier tables (Users, WaterGoals, WaterEntries) are
      // never touched.
      if (from < 2) {
        await m.createTable(waterGoals);
      }
      if (from < 3) {
        await m.createTable(waterEntries);
      }
      if (from < 4) {
        await m.createTable(reminders);
      }
    },
    beforeOpen: (details) async {
      // Same as before: WaterGoals.userId, WaterEntries.userId, and now
      // Reminders.userId all reference Users.id, so foreign keys must
      // stay enforced.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'water_tracker_db');
}
