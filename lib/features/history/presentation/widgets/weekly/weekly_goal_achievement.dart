import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';

class WeeklyGoalAchievement extends StatelessWidget {
  const WeeklyGoalAchievement({super.key});

  // Demo value for the UI phase.
  static const int goalDays = 4;
  static const int totalDays = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.track_changes,
              size: 19.sp,
              color: theme.colorScheme.primary,
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              '$goalDays of $totalDays days reached your daily goal',
              style: AppTextStyles.bodySmallMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
