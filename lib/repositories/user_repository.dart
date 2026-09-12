import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Application-facing user operations. UI code talks to this, never to
/// UsersDao or the database directly.
class UserRepository {
  UserRepository(this._db);
  final AppDatabase _db;

  Future<User?> getCurrentUser() => _db.usersDao.getCurrentUser();

  Stream<User?> watchCurrentUser() => _db.usersDao.watchCurrentUser();

  Future<bool> hasUser() async => await getCurrentUser() != null;

  Future<void> createUser(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await _db.usersDao.createUser(name: trimmed);
  }

  /// Only pass the fields you want to change; omitted ones are left as-is.
  Future<void> updateUser({String? name, int? age, double? weight}) async {
    final current = await getCurrentUser();
    if (current == null) return;

    await _db.usersDao.updateUser(
      id: current.id,
      name: name != null ? Value(name.trim()) : const Value.absent(),
      age: age != null ? Value(age) : const Value.absent(),
      weight: weight != null ? Value(weight) : const Value.absent(),
    );
  }
}
