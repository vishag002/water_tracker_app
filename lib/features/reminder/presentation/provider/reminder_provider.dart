import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker_app/database/app_database.dart';
import 'package:water_tracker_app/features/reminder/domain/calculators/reminder_notification_coordinator.dart';
import 'package:water_tracker_app/features/reminder/domain/notification/notification_service.dart';
import 'package:water_tracker_app/providers/user_name_provider.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';
import 'package:water_tracker_app/providers/water_goal_provider.dart';
import 'package:water_tracker_app/repositories/reminder_repository.dart';

/// Same "goal is stored in liters" convention used in
/// `next_reminder_provider.dart` — the goal table's `unit` isn't
/// user-editable yet.
const int _defaultGoalLiters = 2;

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(appDatabaseProvider));
});

/// Thin wrapper around the existing singleton so it can be overridden
/// in tests / read like any other dependency.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final reminderNotificationCoordinatorProvider =
    Provider<ReminderNotificationCoordinator>((ref) {
      return ReminderNotificationCoordinator(
        ref.watch(notificationServiceProvider),
      );
    });

final currentReminderProvider = StreamProvider<Reminder?>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(null);

  return ref.watch(reminderRepositoryProvider).watchReminder(user.id);
});

/// The three pieces of state that determine whether hydration
/// notifications should be scheduled, and for when: the reminder
/// config, today's intake, and today's goal. `null` while the
/// underlying reminder/goal streams are still loading or erroring —
/// the always-mounted listener that drives [ReminderNotificationCoordinator
/// .sync] treats that as "nothing to sync yet" rather than as a
/// disabled reminder, so a transient loading state can never cancel a
/// user's real schedule.
///
/// Deliberately lives next to [reminderNotificationCoordinatorProvider]
/// rather than being folded into `nextReminderResultProvider` — the UI
/// timeline and the notification sync trigger both derive from the
/// same three underlying providers, but are read from different,
/// independently-rebuilding widgets.
final reminderSyncStateProvider = Provider<ReminderSyncState?>((ref) {
  final reminderAsync = ref.watch(currentReminderProvider);
  final goalAsync = ref.watch(currentWaterGoalProvider);
  final todayIntakeMl = ref.watch(todaysWaterIntakeMlProvider);

  if (reminderAsync.isLoading || goalAsync.isLoading) return null;
  if (reminderAsync.hasError || goalAsync.hasError) return null;

  final todayGoalMl = (goalAsync.value?.goal ?? _defaultGoalLiters) * 1000;

  return ReminderSyncState(
    reminder: reminderAsync.value,
    todayIntakeMl: todayIntakeMl,
    todayGoalMl: todayGoalMl,
  );
});

/// Value-equatable so `ref.listen(reminderSyncStateProvider, ...)` only
/// fires — and only re-syncs notifications — when one of the three
/// underlying values actually changes.
class ReminderSyncState {
  const ReminderSyncState({
    required this.reminder,
    required this.todayIntakeMl,
    required this.todayGoalMl,
  });

  final Reminder? reminder;
  final int todayIntakeMl;
  final int todayGoalMl;

  @override
  bool operator ==(Object other) =>
      other is ReminderSyncState &&
      other.reminder == reminder &&
      other.todayIntakeMl == todayIntakeMl &&
      other.todayGoalMl == todayGoalMl;

  @override
  int get hashCode => Object.hash(reminder, todayIntakeMl, todayGoalMl);
}
