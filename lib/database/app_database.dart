import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/users_dao.dart';
import 'tables/users_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users], daos: [UsersDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Fresh schema — no prior release used this table, so no
  // MigrationStrategy is needed yet. Bump this and add one only once
  // a schema change ships to a version already in users' hands.
  @override
  int get schemaVersion => 1;
}

// drift_flutter's driftDatabase() resolves the app's documents directory
// via path_provider internally and opens a persistent NativeDatabase file
// there — this is what makes storage survive app close/restart.
QueryExecutor _openConnection() {
  return driftDatabase(name: 'water_tracker_db');
}
