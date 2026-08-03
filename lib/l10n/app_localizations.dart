import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Tracker'**
  String get appTitle;

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add Water'**
  String get addWater;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get homeWelcome;

  /// No description provided for @homeDayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get homeDayStreak;

  /// No description provided for @homeIntakeOfGoal.
  ///
  /// In en, this message translates to:
  /// **'of {goal}'**
  String homeIntakeOfGoal(Object goal);

  /// No description provided for @homeGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'{goal} Goal'**
  String homeGoalLabel(Object goal);

  /// No description provided for @homeQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get homeQuickAdd;

  /// No description provided for @homeQuickAdd50ml.
  ///
  /// In en, this message translates to:
  /// **'50 ml'**
  String get homeQuickAdd50ml;

  /// No description provided for @homeQuickAdd500ml.
  ///
  /// In en, this message translates to:
  /// **'+500 ml'**
  String get homeQuickAdd500ml;

  /// No description provided for @homeQuickAdd250ml.
  ///
  /// In en, this message translates to:
  /// **'+250 ml'**
  String get homeQuickAdd250ml;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get settingsMode;

  /// No description provided for @settingsLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsLightMode;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @settingsNextReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Next reminder at {time}'**
  String settingsNextReminderAt(Object time);

  /// No description provided for @settingsStreakCalendar.
  ///
  /// In en, this message translates to:
  /// **'Streak Calendar'**
  String get settingsStreakCalendar;

  /// No description provided for @settingsStreakCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your progress'**
  String get settingsStreakCalendarSubtitle;

  /// No description provided for @settingsManageWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Manage Water Goal'**
  String get settingsManageWaterGoal;

  /// No description provided for @settingsWaterGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{goal} per day'**
  String settingsWaterGoalSubtitle(Object goal);

  /// No description provided for @settingsWaterCalculator.
  ///
  /// In en, this message translates to:
  /// **'Water Calculator'**
  String get settingsWaterCalculator;

  /// No description provided for @settingsWaterCalculatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate your daily water intake'**
  String get settingsWaterCalculatorSubtitle;

  /// No description provided for @settingsHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get settingsHistory;

  /// No description provided for @settingsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your past intake'**
  String get settingsHistorySubtitle;

  /// No description provided for @settingsRemoveAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get settingsRemoveAds;

  /// No description provided for @settingsRemoveAdsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoy an ad-free experience'**
  String get settingsRemoveAdsSubtitle;

  /// No description provided for @settingsRemoveAdsPrice.
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String settingsRemoveAdsPrice(Object price);

  /// No description provided for @settingsRemoveAdsPriceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase'**
  String get settingsRemoveAdsPriceSubtitle;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyTabDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get historyTabDay;

  /// No description provided for @historyTabWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get historyTabWeek;

  /// No description provided for @historyTabMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get historyTabMonth;

  /// No description provided for @historyTabYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get historyTabYear;

  /// No description provided for @historyDateHeader.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String historyDateHeader(Object date);

  /// No description provided for @historyIntakeValue.
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String historyIntakeValue(Object value);

  /// No description provided for @historyIntakeOfGoal.
  ///
  /// In en, this message translates to:
  /// **'of {goal}'**
  String historyIntakeOfGoal(Object goal);

  /// No description provided for @historyPercentOfGoal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of daily goal'**
  String historyPercentOfGoal(Object percent);

  /// No description provided for @historyTotalIntake.
  ///
  /// In en, this message translates to:
  /// **'Total Intake'**
  String get historyTotalIntake;

  /// No description provided for @historyTotalEntries.
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get historyTotalEntries;

  /// No description provided for @historyQuickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get historyQuickStats;

  /// No description provided for @historyAverageIntake.
  ///
  /// In en, this message translates to:
  /// **'Average Intake'**
  String get historyAverageIntake;

  /// No description provided for @historyAverageIntakeValue.
  ///
  /// In en, this message translates to:
  /// **'{value}/day'**
  String historyAverageIntakeValue(Object value);

  /// No description provided for @historyBestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get historyBestDay;

  /// No description provided for @historyBestDayValue.
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String historyBestDayValue(Object value);

  /// No description provided for @historyBestDayDate.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String historyBestDayDate(Object date);

  /// No description provided for @historyGoalAchievement.
  ///
  /// In en, this message translates to:
  /// **'Goal Achievement'**
  String get historyGoalAchievement;

  /// No description provided for @historyGoalAchievementPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String historyGoalAchievementPercent(Object percent);

  /// No description provided for @historyGoalAchievementDetail.
  ///
  /// In en, this message translates to:
  /// **'{achieved} of {total} days'**
  String historyGoalAchievementDetail(Object achieved, Object total);

  /// No description provided for @historyEntryTotalIntake.
  ///
  /// In en, this message translates to:
  /// **'Total Intake'**
  String get historyEntryTotalIntake;

  /// No description provided for @historyEntryOfGoal.
  ///
  /// In en, this message translates to:
  /// **'of {goal} Goal'**
  String historyEntryOfGoal(Object goal);

  /// No description provided for @historyEntryTime.
  ///
  /// In en, this message translates to:
  /// **'{time}'**
  String historyEntryTime(Object time);

  /// No description provided for @historyEntryAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount}'**
  String historyEntryAmount(Object amount);

  /// No description provided for @historyTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Keep going!'**
  String get historyTip;

  /// No description provided for @historyTipMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great. Stay hydrated!'**
  String get historyTipMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ml': return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
