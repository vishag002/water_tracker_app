import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/water_goals_table.dart';

part 'water_goals_dao.g.dart';

@DriftAccessor(tables: [WaterGoals])
class WaterGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$WaterGoalsDaoMixin {
  WaterGoalsDao(super.db);

  Future<WaterGoal?> getWaterGoal(int userId) => (select(
    waterGoals,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Stream<WaterGoal?> watchWaterGoal(int userId) => (select(
    waterGoals,
  )..where((t) => t.userId.equals(userId))).watchSingleOrNull();

  Future<int> createWaterGoal({
    required int userId,
    required double goal,
    required String unit,
  }) {
    final now = DateTime.now();
    return into(waterGoals).insert(
      WaterGoalsCompanion.insert(
        userId: userId,
        goal: goal,
        unit: unit,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Partial update, scoped to the one goal row owned by [userId].
  Future<bool> updateWaterGoal({
    required int userId,
    Value<double> goal = const Value.absent(),
    Value<String> unit = const Value.absent(),
  }) async {
    final rows =
        await (update(waterGoals)..where((t) => t.userId.equals(userId))).write(
          WaterGoalsCompanion(
            goal: goal,
            unit: unit,
            updatedAt: Value(DateTime.now()),
          ),
        );
    return rows > 0;
  }
}
