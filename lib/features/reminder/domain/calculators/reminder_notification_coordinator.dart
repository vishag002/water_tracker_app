import 'package:water_tracker_app/database/app_database.dart';
import 'package:water_tracker_app/features/reminder/domain/calculators/next_reminder_calculator.dart';
import 'package:water_tracker_app/features/reminder/domain/notification/notification_service.dart';

/// Bridges reminder *configuration* (Drift, via [Reminder]) plus
/// today's intake/goal to actual scheduled OS notifications. Contains
/// no business rules of its own — applicability and the valid time
/// slots come entirely from [NextReminderCalculator
/// .remainingSlotsToday], the same source of truth the on-screen
/// "Next Reminder" UI is built from.
///
/// Notification IDs are deterministic (`_idBase + minuteOfDay`), so no
/// notification state needs to live in Drift, and a full re-sync is
/// always safe to call — stale slots are cancelled before new ones are
/// scheduled.
class ReminderNotificationCoordinator {
  ReminderNotificationCoordinator(this._notificationService);

  final NotificationService _notificationService;

  /// Reserved notification-id range: 1000..2439 (minutes-in-a-day - 1
  /// added to base 1000). Chosen to never collide with
  /// `showTestNotification`'s id (0) or any future non-reminder use.
  static const int _idBase = 1000;
  static const int _idRangeExclusiveEnd = _idBase + 1440;

  bool _isReminderNotificationId(int id) =>
      id >= _idBase && id < _idRangeExclusiveEnd;

  int _idForSlot(int minutesSinceMidnight) => _idBase + minutesSinceMidnight;

  /// Cancels every currently-scheduled hydration reminder, then — if
  /// [reminder] is present and [NextReminderCalculator] says there's at
  /// least one valid slot left today given [todayIntakeMl] and
  /// [todayGoalMl] — schedules exactly those remaining slots.
  ///
  /// All applicability rules (enabled, goal reached, window ended) live
  /// solely in [NextReminderCalculator.remainingSlotsToday] — this
  /// method does not re-derive them, so notification scheduling and
  /// the on-screen "next reminder" UI can never disagree.
  ///
  /// Safe to call any time the reminder config, today's intake, or
  /// today's goal changes, and safe to call redundantly (idempotent).
  Future<void> sync({
    required Reminder? reminder,
    required int todayIntakeMl,
    required int todayGoalMl,
  }) async {
    await _cancelExistingReminderNotifications();

    if (reminder == null) return;

    final slots = NextReminderCalculator.remainingSlotsToday(
      now: DateTime.now(),
      startTimeMinutes: reminder.startTimeMinutes,
      endTimeMinutes: reminder.endTimeMinutes,
      intervalMinutes: reminder.intervalMinutes,
      isEnabled: reminder.isEnabled,
      todayIntakeMl: todayIntakeMl,
      todayGoalMl: todayGoalMl,
    );

    if (slots.isEmpty) return;

    await _notificationService.requestPermission();
    // await _notificationService.requestExactAlarmsPermission();

    for (final slot in slots) {
      final minuteOfDay = slot.hour * 60 + slot.minute;
      await _notificationService.scheduleReminder(
        id: _idForSlot(minuteOfDay),
        hour: slot.hour,
        minute: slot.minute,
      );
    }
  }

  Future<void> _cancelExistingReminderNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    final staleIds = pending
        .map((request) => request.id)
        .where(_isReminderNotificationId);

    for (final id in staleIds) {
      await _notificationService.cancelReminder(id);
    }
  }
}
