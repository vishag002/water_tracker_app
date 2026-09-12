import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../repositories/water_goal_repository.dart';
import 'user_name_provider.dart';

final waterGoalRepositoryProvider = Provider<WaterGoalRepository>((ref) {
  return WaterGoalRepository(ref.watch(appDatabaseProvider));
});

/// Live view of the current user's goal. Depends on currentUserProvider
/// since a goal can't exist before a userId does.
final currentWaterGoalProvider = StreamProvider<WaterGoal?>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(null);

  return ref.watch(waterGoalRepositoryProvider).watchWaterGoal(user.id);
});
