import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'water_reminders';
  static const String _channelName = 'Water Reminders';
  static const String _channelDescription =
      'Reminders to help you stay hydrated.';

  Future<void> initialize() async {
    // Initialize timezone database.
    tz.initializeTimeZones();

    // Set device timezone.
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    // Android initialization.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      onDidReceiveNotificationResponse: _onNotificationTapped,
      settings: settings,
    );

    // Create notification channel.
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<void> requestPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  /// Required on Android 12+ for `AndroidScheduleMode.exactAllowWhileIdle`.
  /// Without this, exact reminders silently fall back to inexact timing
  /// (or are skipped, depending on OS version) once the permission is
  /// revoked or was never granted.
  Future<void> requestExactAlarmsPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: 0,
      title: 'Water Habit 💧',
      body: 'This is a test notification!',
      notificationDetails: details,
    );
  }

  /// Schedules a notification that repeats daily at [hour]:[minute]
  /// (device local time). [id] should be stable per reminder slot so
  /// re-scheduling (e.g. after the user edits the time) overwrites the
  /// same pending request instead of stacking duplicates.
  // Future<void> scheduleDailyReminder({
  //   required int id,
  //   required int hour,
  //   required int minute,
  // }) async {
  //   final scheduledDate = _nextInstanceOfTime(hour: hour, minute: minute);

  //   const androidDetails = AndroidNotificationDetails(
  //     _channelId,
  //     _channelName,
  //     channelDescription: _channelDescription,
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   const details = NotificationDetails(android: androidDetails);

  //   await _plugin.zonedSchedule(
  //     id: id,
  //     title: 'Time to hydrate 💧',
  //     body: 'Take a moment to drink some water.',
  //     scheduledDate: scheduledDate,
  //     notificationDetails: details,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  /// Returns the next occurrence of [hour]:[minute] in device local time,
  /// rolling over to tomorrow if that time has already passed today.
  tz.TZDateTime _nextInstanceOfTime({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // We will handle notification navigation later.
  }

  Future<void> scheduleReminder({
    required int id,
    required int hour,
    required int minute,
  }) async {
    await cancelReminder(id);

    final scheduledDate = _nextInstanceOfTime(hour: hour, minute: minute);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id: id,
      title: 'Time to hydrate 💧',
      body: 'Take a moment to drink some water.',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
