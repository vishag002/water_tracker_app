import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/users_table.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  /// Single-user app: the "current user" is simply the only row, if any.
  Future<User?> getCurrentUser() => select(users).getSingleOrNull();

  Stream<User?> watchCurrentUser() => select(users).watchSingleOrNull();

  Future<int> createUser({required String name, int? age, double? weight}) {
    final now = DateTime.now();
    return into(users).insert(
      UsersCompanion.insert(
        name: name,
        age: Value(age),
        weight: Value(weight),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Partial update — pass `Value.absent()` (the default) for any field
  /// you don't want to touch, or `Value(newValue)` to change it.
  Future<bool> updateUser({
    required int id,
    Value<String> name = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<double?> weight = const Value.absent(),
  }) async {
    final rows = await (update(users)..where((t) => t.id.equals(id))).write(
      UsersCompanion(
        name: name,
        age: age,
        weight: weight,
        updatedAt: Value(DateTime.now()),
      ),
    );
    return rows > 0;
  }
}
