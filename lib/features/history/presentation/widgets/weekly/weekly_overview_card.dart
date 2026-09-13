import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/domain/calculators/weekly_history_calculator.dart';
import 'package:water_tracker_app/features/history/presentation/providers/weekly_history_provider.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

import 'weekly_bar_chart.dart';

/// Bar chart of daily intake for the week containing [date], sourced
/// from [weeklyHistoryProvider]. Passes plain values down to the
/// presentation-only [WeeklyBarChart].
class WeeklyOverviewCard extends ConsumerWidget {
  const WeeklyOverviewCard({super.key, required this.date});

  final DateTime date;

  static final DateFormat _shortDayFormat = DateFormat('EEE');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weekStart = WeeklyHistoryCalculator.startOfWeek(date);
    final resultAsync = ref.watch(weeklyHistoryProvider(weekStart));

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

          resultAsync.when(
            data: (result) => WeeklyBarChart(
              dailyIntakeLiters: result.days
                  .map((day) => day.totalMl / 1000)
                  .toList(),
              dayLabels: result.days
                  .map((day) => _shortDayFormat.format(day.date))
                  .toList(),
              goalLiters: (result.goalMl ?? 2000) / 1000,
            ),
            loading: () => SizedBox(
              height: 220.h,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => SizedBox(
              height: 220.h,
              child: Center(
                child: Text(
                  'Couldn\'t load this week\'s overview.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ),

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
