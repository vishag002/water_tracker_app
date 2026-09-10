import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

import 'weekly_bar_chart.dart';

class WeeklyOverviewCard extends StatelessWidget {
  const WeeklyOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HistoryCard(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Overview',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            'Daily water intake',
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),

          SizedBox(height: 12.h),

          const WeeklyBarChart(),

          SizedBox(height: 4.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                'Daily intake',
                style: AppTextStyles.captionXsMedium.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 18.w,
                height: 1.5.h,
                decoration: BoxDecoration(color: theme.colorScheme.primary),
              ),
              SizedBox(width: 5.w),
              Text(
                'Goal',
                style: AppTextStyles.captionXsMedium.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
