import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker_app/features/reminder/domain/calculators/next_reminder_calculator.dart';

void main() {
  group('NextReminderCalculator', () {
    test(
      'Test 1: start 12:00, end 22:00, interval 60, current 14:08 -> 15:00',
      () {
        final now = DateTime(2026, 9, 14, 14, 8);
        final result = NextReminderCalculator.calculate(
          now: now,
          startTimeMinutes: 12 * 60,
          endTimeMinutes: 22 * 60,
          intervalMinutes: 60,
          isEnabled: true,
          todayIntakeMl: 500,
          todayGoalMl: 2000,
        );
        expect(result.nextReminder, DateTime(2026, 9, 14, 15, 0));
      },
    );

    test(
      'Test 2: start 08:00, end 20:00, interval 30, current 10:17 -> 10:30',
      () {
        final now = DateTime(2026, 9, 14, 10, 17);
        final result = NextReminderCalculator.calculate(
          now: now,
          startTimeMinutes: 8 * 60,
          endTimeMinutes: 20 * 60,
          intervalMinutes: 30,
          isEnabled: true,
          todayIntakeMl: 500,
          todayGoalMl: 2000,
        );
        expect(result.nextReminder, DateTime(2026, 9, 14, 10, 30));
      },
    );

    test('Test 3: current exactly 10:30 -> 11:00', () {
      final now = DateTime(2026, 9, 14, 10, 30);
      final result = NextReminderCalculator.calculate(
        now: now,
        startTimeMinutes: 8 * 60,
        endTimeMinutes: 20 * 60,
        intervalMinutes: 30,
        isEnabled: true,
        todayIntakeMl: 500,
        todayGoalMl: 2000,
      );
      expect(result.nextReminder, DateTime(2026, 9, 14, 11, 0));
    });

    test('Test 4: current after end time -> null', () {
      final now = DateTime(2026, 9, 14, 20, 30);
      final result = NextReminderCalculator.calculate(
        now: now,
        startTimeMinutes: 8 * 60,
        endTimeMinutes: 20 * 60,
        intervalMinutes: 30,
        isEnabled: true,
        todayIntakeMl: 500,
        todayGoalMl: 2000,
      );
      expect(result.nextReminder, isNull);
      expect(result.reason, NextReminderUnavailableReason.windowEnded);
    });

    test('Test 5: goal reached (intake == goal) -> null', () {
      final now = DateTime(2026, 9, 14, 14, 0);
      final result = NextReminderCalculator.calculate(
        now: now,
        startTimeMinutes: 8 * 60,
        endTimeMinutes: 20 * 60,
        intervalMinutes: 30,
        isEnabled: true,
        todayIntakeMl: 2000,
        todayGoalMl: 2000,
      );
      expect(result.nextReminder, isNull);
      expect(result.reason, NextReminderUnavailableReason.goalReached);
    });

    test('Test 6: goal exceeded -> null', () {
      final now = DateTime(2026, 9, 14, 14, 0);
      final result = NextReminderCalculator.calculate(
        now: now,
        startTimeMinutes: 8 * 60,
        endTimeMinutes: 20 * 60,
        intervalMinutes: 30,
        isEnabled: true,
        todayIntakeMl: 2300,
        todayGoalMl: 2000,
      );
      expect(result.nextReminder, isNull);
      expect(result.reason, NextReminderUnavailableReason.goalReached);
    });

    test('Test 7: reminder disabled -> null', () {
      final now = DateTime(2026, 9, 14, 14, 0);
      final result = NextReminderCalculator.calculate(
        now: now,
        startTimeMinutes: 8 * 60,
        endTimeMinutes: 20 * 60,
        intervalMinutes: 30,
        isEnabled: false,
        todayIntakeMl: 500,
        todayGoalMl: 2000,
      );
      expect(result.nextReminder, isNull);
      expect(result.reason, NextReminderUnavailableReason.disabled);
    });

    test(
      'Test 8: custom interval 90 minutes -> correct slot anchored to start',
      () {
        final now = DateTime(2026, 9, 14, 10, 0);
        final result = NextReminderCalculator.calculate(
          now: now,
          startTimeMinutes: 8 * 60, // 08:00
          endTimeMinutes: 22 * 60,
          intervalMinutes: 90,
          isEnabled: true,
          todayIntakeMl: 500,
          todayGoalMl: 2000,
        );
        // Slots: 08:00, 09:30, 11:00, 12:30... first strictly after 10:00 is 11:00.
        expect(result.nextReminder, DateTime(2026, 9, 14, 11, 0));
      },
    );

    test(
      'Test 9: start 08:00, end 10:00, interval 60, current 09:30 -> 10:00',
      () {
        final now = DateTime(2026, 9, 14, 9, 30);
        final result = NextReminderCalculator.calculate(
          now: now,
          startTimeMinutes: 8 * 60,
          endTimeMinutes: 10 * 60,
          intervalMinutes: 60,
          isEnabled: true,
          todayIntakeMl: 500,
          todayGoalMl: 2000,
        );
        expect(result.nextReminder, DateTime(2026, 9, 14, 10, 0));
      },
    );

    test(
      'Test 10: start 08:00, end 10:00, interval 60, current 10:01 -> null',
      () {
        final now = DateTime(2026, 9, 14, 10, 1);
        final result = NextReminderCalculator.calculate(
          now: now,
          startTimeMinutes: 8 * 60,
          endTimeMinutes: 10 * 60,
          intervalMinutes: 60,
          isEnabled: true,
          todayIntakeMl: 500,
          todayGoalMl: 2000,
        );
        expect(result.nextReminder, isNull);
      },
    );

    test('Upcoming list is capped and starts with nextReminder', () {
      final now = DateTime(2026, 9, 14, 7, 0);
      final result = NextReminderCalculator.calculate(
        now: now,
        startTimeMinutes: 8 * 60,
        endTimeMinutes: 22 * 60,
        intervalMinutes: 60,
        isEnabled: true,
        todayIntakeMl: 500,
        todayGoalMl: 2000,
      );
      expect(result.upcomingReminders.length, 4);
      expect(result.upcomingReminders.first, result.nextReminder);
    });
  });
}
