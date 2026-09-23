
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../data/repositories/user_repository.dart';

/// One AppDatabase instance for the app's lifetime; closed on dispose.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(appDatabaseProvider));
});

/// Live view of the single local profile — null until onboarding completes.
final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(userRepositoryProvider).watchCurrentUser();
});


