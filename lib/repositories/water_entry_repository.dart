import '../database/app_database.dart';

/// Application-facing water-entry operations. Hides Drift from the UI,
/// same as UserRepository and WaterGoalRepository.
class WaterEntryRepository {
  WaterEntryRepository(this._db);
  final AppDatabase _db;

  Future<void> addEntry({
    required int userId,
    required int amount,
    required String unit,
  }) async {
    if (amount <= 0) return;
    await _db.waterEntriesDao.addEntry(
      userId: userId,
      amount: amount,
      unit: unit,
    );
  }

  Future<List<WaterEntry>> getEntries(int userId) =>
      _db.waterEntriesDao.getEntries(userId);

  Stream<List<WaterEntry>> watchEntries(int userId) =>
      _db.waterEntriesDao.watchEntries(userId);

  Future<List<WaterEntry>> getEntriesForDay(int userId, DateTime day) =>
      _db.waterEntriesDao.getEntriesForDay(userId, day);

  Stream<List<WaterEntry>> watchEntriesForDay(int userId, DateTime day) =>
      _db.waterEntriesDao.watchEntriesForDay(userId, day);

  Future<List<WaterEntry>> getEntriesForRange(
    int userId,
    DateTime start,
    DateTime end,
  ) => _db.waterEntriesDao.getEntriesForRange(userId, start, end);

  Stream<List<WaterEntry>> watchEntriesForRange(
    int userId,
    DateTime start,
    DateTime end,
  ) => _db.waterEntriesDao.watchEntriesForRange(userId, start, end);

  Future<void> deleteEntry(int id) => _db.waterEntriesDao.deleteEntry(id);
}
