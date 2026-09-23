import 'package:drift/drift.dart';

import '../../../../database/app_database.dart';

/// Application-facing water-goal operations. Enforces the "one current
/// goal per user" rule so callers never have to think about insert-vs-update.
class WaterGoalRepository {
  WaterGoalRepository(this._db);
  final AppDatabase _db;

  Future<WaterGoal?> getWaterGoal(int userId) =>
      _db.waterGoalsDao.getWaterGoal(userId);

  Stream<WaterGoal?> watchWaterGoal(int userId) =>
      _db.waterGoalsDao.watchWaterGoal(userId);

  /// Creates a goal if [userId] has none yet; otherwise updates the
  /// existing one. Callers don't need to know which case applies.
  Future<void> createWaterGoal({
    required int userId,
    required double goal,
    required String unit,
  }) async {
    final existing = await getWaterGoal(userId);
    if (existing != null) {
      await updateWaterGoal(userId: userId, goal: goal, unit: unit);
      return;
    }
    await _db.waterGoalsDao.createWaterGoal(
      userId: userId,
      goal: goal,
      unit: unit,
    );
  }

  Future<void> updateWaterGoal({
    required int userId,
    double? goal,
    String? unit,
  }) async {
    await _db.waterGoalsDao.updateWaterGoal(
      userId: userId,
      goal: goal != null ? Value(goal) : const Value.absent(),
      unit: unit != null ? Value(unit) : const Value.absent(),
    );
  }
}
