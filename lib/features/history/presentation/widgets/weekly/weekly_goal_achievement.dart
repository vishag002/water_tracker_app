import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/domain/calculators/weekly_history_calculator.dart';
import 'package:water_tracker_app/features/history/presentation/providers/weekly_history_provider.dart';

/// "X of 7 days reached your daily goal" for the week containing [date],
/// sourced from [weeklyHistoryProvider].
class WeeklyGoalAchievement extends ConsumerWidget {
  const WeeklyGoalAchievement({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weekStart = WeeklyHistoryCalculator.startOfWeek(date);
    final resultAsync = ref.watch(weeklyHistoryProvider(weekStart));

    final message = resultAsync.when(
      data: (result) =>
          '${result.daysGoalReached} of ${result.days.length} days reached your daily goal',
      loading: () => 'Checking this week\'s goal progress…',
      error: (error, stackTrace) => 'Couldn\'t load this week\'s goal progress.',
    );

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
              message,
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
