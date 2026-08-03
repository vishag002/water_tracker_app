// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'വാട്ടർ ട്രാക്കർ';

  @override
  String get addWater => 'വെള്ളം ചേർക്കുക';

  @override
  String get dailyGoal => 'ദിവസേനയുള്ള ലക്ഷ്യം';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navHistory => 'ചരിത്രം';

  @override
  String get navSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get homeWelcome => 'സ്വാഗതം';

  @override
  String get homeDayStreak => 'ദിന തുടർച്ച';

  @override
  String homeIntakeOfGoal(Object goal) {
    return '$goal ൽ';
  }

  @override
  String homeGoalLabel(Object goal) {
    return '$goal ലക്ഷ്യം';
  }

  @override
  String get homeQuickAdd => 'പെട്ടെന്ന് ചേർക്കുക';

  @override
  String get homeQuickAdd50ml => '50 മി.ലി';

  @override
  String get homeQuickAdd500ml => '+500 മി.ലി';

  @override
  String get homeQuickAdd250ml => '+250 മി.ലി';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get settingsMode => 'മോഡ്';

  @override
  String get settingsLightMode => 'ലൈറ്റ് മോഡ്';

  @override
  String get settingsDarkMode => 'ഡാർക്ക് മോഡ്';

  @override
  String get settingsReminders => 'ഓർമ്മപ്പെടുത്തലുകൾ';

  @override
  String settingsNextReminderAt(Object time) {
    return 'അടുത്ത ഓർമ്മപ്പെടുത്തൽ $time ന്';
  }

  @override
  String get settingsStreakCalendar => 'സ്ട്രീക്ക് കലണ്ടർ';

  @override
  String get settingsStreakCalendarSubtitle => 'നിങ്ങളുടെ പുരോഗതി കാണുക';

  @override
  String get settingsManageWaterGoal => 'വാട്ടർ ലക്ഷ്യം കൈകാര്യം ചെയ്യുക';

  @override
  String settingsWaterGoalSubtitle(Object goal) {
    return 'ഒരു ദിവസം $goal';
  }

  @override
  String get settingsWaterCalculator => 'വാട്ടർ കാൽക്കുലേറ്റർ';

  @override
  String get settingsWaterCalculatorSubtitle => 'നിങ്ങളുടെ ദിവസേനയുള്ള ജല ഉപഭോഗം കണക്കാക്കുക';

  @override
  String get settingsHistory => 'ചരിത്രം';

  @override
  String get settingsHistorySubtitle => 'നിങ്ങളുടെ മുൻകാല ഉപഭോഗം കാണുക';

  @override
  String get settingsRemoveAds => 'പരസ്യങ്ങൾ നീക്കം ചെയ്യുക';

  @override
  String get settingsRemoveAdsSubtitle => 'പരസ്യ രഹിത അനുഭവം ആസ്വദിക്കുക';

  @override
  String settingsRemoveAdsPrice(Object price) {
    return '$price';
  }

  @override
  String get settingsRemoveAdsPriceSubtitle => 'ഒറ്റത്തവണ വാങ്ങൽ';

  @override
  String get historyTitle => 'ചരിത്രം';

  @override
  String get historyTabDay => 'ദിവസം';

  @override
  String get historyTabWeek => 'ആഴ്ച';

  @override
  String get historyTabMonth => 'മാസം';

  @override
  String get historyTabYear => 'വർഷം';

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
    return '$goal ൽ';
  }

  @override
  String historyPercentOfGoal(Object percent) {
    return 'ദിവസേനയുള്ള ലക്ഷ്യത്തിന്റെ $percent%';
  }

  @override
  String get historyTotalIntake => 'ആകെ ഉപഭോഗം';

  @override
  String get historyTotalEntries => 'ആകെ എൻട്രികൾ';

  @override
  String get historyQuickStats => 'പെട്ടെന്നുള്ള സ്ഥിതിവിവരക്കണക്കുകൾ';

  @override
  String get historyAverageIntake => 'ശരാശരി ഉപഭോഗം';

  @override
  String historyAverageIntakeValue(Object value) {
    return '$value/ദിവസം';
  }

  @override
  String get historyBestDay => 'മികച്ച ദിവസം';

  @override
  String historyBestDayValue(Object value) {
    return '$value';
  }

  @override
  String historyBestDayDate(Object date) {
    return '$date';
  }

  @override
  String get historyGoalAchievement => 'ലക്ഷ്യ നേട്ടം';

  @override
  String historyGoalAchievementPercent(Object percent) {
    return '$percent%';
  }

  @override
  String historyGoalAchievementDetail(Object achieved, Object total) {
    return '$total ദിവസങ്ങളിൽ $achieved എണ്ണം';
  }

  @override
  String get historyEntryTotalIntake => 'ആകെ ഉപഭോഗം';

  @override
  String historyEntryOfGoal(Object goal) {
    return '$goal ലക്ഷ്യത്തിൽ';
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
  String get historyTip => 'നുറുങ്ങ്: തുടരുക!';

  @override
  String get historyTipMessage => 'നിങ്ങൾ നന്നായി ചെയ്യുന്നു. ജലാംശം നിലനിർത്തുക!';
}
