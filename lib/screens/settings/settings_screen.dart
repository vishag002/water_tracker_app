import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/components/settings_card.dart';
import 'package:water_tracker_app/components/theme_mode_button.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';
import 'package:water_tracker_app/l10n/app_localizations.dart';
import 'package:water_tracker_app/screens/settings/reminder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ScaffoldCustom(
      title: localizations.settingsTitle,
      centerTitle: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localizations.settingsMode,
                  style: AppTextStyles.bodyRegular,
                ),
              ),
              SizedBox(height: 8.h),
              ThemeToggleButton(),
              SizedBox(height: 12.h),

              SettingsCard(
                leadingAsset: ImageConstants.notificationOutline,
                title: localizations.settingsReminders,
                subtitle: localizations.settingsNextReminderAt('10:00 AM'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReminderScreen()),
                  );
                },
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.calendarIcon,
                title: localizations.settingsStreakCalendar,
                subtitle: localizations.settingsStreakCalendarSubtitle,
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.waterDrop1,
                title: localizations.settingsManageWaterGoal,
                subtitle: localizations.settingsWaterGoalSubtitle('2 L'),
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.calculatorIcon,
                title: localizations.settingsWaterCalculator,
                subtitle: localizations.settingsWaterCalculatorSubtitle,
                onTap: () {},
              ),
              // SizedBox(height: 12.h),
              // SettingsCard(
              //   leadingAsset: ImageConstants.bottle,
              //   title: localizations.settingsHistory,
              //   subtitle: localizations.settingsHistorySubtitle,
              //   onTap: () {},
              // ),
              SizedBox(height: 12.h),
              Container(
                height: 115.h,
                width: 320.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: Image.asset(ImageConstants.crownIcon),
                      ),
                      SizedBox(width: 18.w),
                      //
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.settingsRemoveAds,
                              style: AppTextStyles.bodySmallSemiBold,
                            ),
                            Text(
                              localizations.settingsRemoveAdsSubtitle,
                              style: AppTextStyles.captionRegular,
                            ),
                            Text(
                              localizations.settingsRemoveAdsPriceSubtitle,
                              style: AppTextStyles.captionRegular,
                            ),
                          ],
                        ),
                      ),

                      //
                      Container(
                        width: 70.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: AppColors.colour368AE9,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            // horizontal: 20.w,
                            // vertical: 15.h,
                          ),
                          child: Center(
                            child: Text(
                              localizations.settingsRemoveAdsPrice('₹19'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
