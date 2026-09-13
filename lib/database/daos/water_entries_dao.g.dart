// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_entries_dao.dart';

// ignore_for_file: type=lint
mixin _$WaterEntriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $WaterEntriesTable get waterEntries => attachedDatabase.waterEntries;
  WaterEntriesDaoManager get managers => WaterEntriesDaoManager(this);
}

class WaterEntriesDaoManager {
  final _$WaterEntriesDaoMixin _db;
  WaterEntriesDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$WaterEntriesTableTableManager get waterEntries =>
      $$WaterEntriesTableTableManager(_db.attachedDatabase, _db.waterEntries);
}
