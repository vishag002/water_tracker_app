// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Water Tracker';

  @override
  String get addWater => 'Add Water';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeWelcome => 'Welcome';

  @override
  String get homeDayStreak => 'Day Streak';

  @override
  String homeIntakeOfGoal(Object goal) {
    return 'of $goal';
  }

  @override
  String homeGoalLabel(Object goal) {
    return '$goal Goal';
  }

  @override
  String get homeQuickAdd => 'Quick Add';

  @override
  String get homeQuickAdd50ml => '50 ml';

  @override
  String get homeQuickAdd500ml => '+500 ml';

  @override
  String get homeQuickAdd250ml => '+250 ml';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsMode => 'Mode';

  @override
  String get settingsLightMode => 'Light Mode';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String settingsNextReminderAt(Object time) {
    return 'Next reminder at $time';
  }

  @override
  String get settingsStreakCalendar => 'Streak Calendar';

  @override
  String get settingsStreakCalendarSubtitle => 'View your progress';

  @override
  String get settingsManageWaterGoal => 'Manage Water Goal';

  @override
  String settingsWaterGoalSubtitle(Object goal) {
    return '$goal per day';
  }

  @override
  String get settingsWaterCalculator => 'Water Calculator';

  @override
  String get settingsWaterCalculatorSubtitle => 'Calculate your daily water intake';

  @override
  String get settingsHistory => 'History';

  @override
  String get settingsHistorySubtitle => 'View your past intake';

  @override
  String get settingsRemoveAds => 'Remove Ads';

  @override
  String get settingsRemoveAdsSubtitle => 'Enjoy an ad-free experience';

  @override
  String settingsRemoveAdsPrice(Object price) {
    return '$price';
  }

  @override
  String get settingsRemoveAdsPriceSubtitle => 'One-time purchase';

  @override
  String get historyTitle => 'History';

  @override
  String get historyTabDay => 'Day';

  @override
  String get historyTabWeek => 'Week';

  @override
  String get historyTabMonth => 'Month';

  @override
  String get historyTabYear => 'Year';

  @override
  String historyDateHeader(Object date) {
    return '$date';
  }

  @override
  String historyIntakeValue(Object value) {
    return '$value';
  }

  @override
  String historyIntakeOfGoal(Object goal) {
    return 'of $goal';
  }

  @override
  String historyPercentOfGoal(Object percent) {
    return '$percent% of daily goal';
  }

  @override
  String get historyTotalIntake => 'Total Intake';

  @override
  String get historyTotalEntries => 'Total Entries';

  @override
  String get historyQuickStats => 'Quick Stats';

  @override
  String get historyAverageIntake => 'Average Intake';

  @override
  String historyAverageIntakeValue(Object value) {
    return '$value/day';
  }

  @override
  String get historyBestDay => 'Best Day';

  @override
  String historyBestDayValue(Object value) {
    return '$value';
  }

  @override
  String historyBestDayDate(Object date) {
    return '$date';
  }

  @override
  String get historyGoalAchievement => 'Goal Achievement';

  @override
  String historyGoalAchievementPercent(Object percent) {
    return '$percent%';
  }

  @override
  String historyGoalAchievementDetail(Object achieved, Object total) {
    return '$achieved of $total days';
  }

  @override
  String get historyEntryTotalIntake => 'Total Intake';

  @override
  String historyEntryOfGoal(Object goal) {
    return 'of $goal Goal';
  }

  @override
  String historyEntryTime(Object time) {
    return '$time';
  }

  @override
  String historyEntryAmount(Object amount) {
    return '$amount';
  }

  @override
  String get historyTip => 'Tip: Keep going!';

  @override
  String get historyTipMessage => 'You\'re doing great. Stay hydrated!';
}
