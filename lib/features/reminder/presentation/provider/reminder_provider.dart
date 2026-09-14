import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/database/app_database.dart';
import 'package:water_tracker_app/providers/user_name_provider.dart';
import 'package:water_tracker_app/repositories/reminder_repository.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(appDatabaseProvider));
});

/// Live view of the current user's reminder configuration. Depends on
/// currentUserProvider since a reminder can't exist before a userId
/// does. `null` means the user hasn't configured reminders yet — the UI
/// treats that as "off, with default settings", not as an error.
final currentReminderProvider = StreamProvider<Reminder?>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(null);

  return ref.watch(reminderRepositoryProvider).watchReminder(user.id);
});
