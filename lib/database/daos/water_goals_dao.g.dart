// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_goals_dao.dart';

// ignore_for_file: type=lint
mixin _$WaterGoalsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $WaterGoalsTable get waterGoals => attachedDatabase.waterGoals;
  WaterGoalsDaoManager get managers => WaterGoalsDaoManager(this);
}

class WaterGoalsDaoManager {
  final _$WaterGoalsDaoMixin _db;
  WaterGoalsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$WaterGoalsTableTableManager get waterGoals =>
      $$WaterGoalsTableTableManager(_db.attachedDatabase, _db.waterGoals);
}
