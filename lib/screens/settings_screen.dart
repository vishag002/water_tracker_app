import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/components/settings_card.dart';
import 'package:water_tracker_app/components/theme_mode_button.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      title: 'settings',
      centerTitle: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Mode", style: AppTextStyles.bodyRegular),
              ),
              SizedBox(height: 8.h),
              ThemeToggleButton(),
              SizedBox(height: 12.h),

              SettingsCard(
                leadingAsset: ImageConstants.bottle,
                title: 'Reminders',
                subtitle: 'Next reminder at 10:00 AM',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.bottle,
                title: 'Streak Calendar',
                subtitle: 'View your progress',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.bottle,
                title: 'Manage Water Goal',
                subtitle: '2 L per day',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.bottle,
                title: 'Water Calculator',
                subtitle: 'Calculate your daily water intake',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                leadingAsset: ImageConstants.bottle,
                title: 'History',
                subtitle: 'View your past intake',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              Container(
                height: 115.h,
                width: 320.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40.h,
                        width: 40.w,
                        color: AppColors.borderColor,
                      ),
                      //
                      Expanded(
                        child: Column(
                          children: [
                            Text("Remove Ads", style: AppTextStyles.bodyMedium),
                            Text(
                              "Enjoy an ad-free experience",
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              "One-time purchase",
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      //
                      Container(
                        width: 70.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.colour368AE9,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Center(child: Text('₹19')),
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
