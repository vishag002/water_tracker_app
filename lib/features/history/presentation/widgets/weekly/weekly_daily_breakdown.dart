import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/features/history/domain/calculators/weekly_history_calculator.dart';
import 'package:water_tracker_app/features/history/presentation/providers/weekly_history_provider.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

/// Lists all 7 days of the week containing [date] — Monday through
/// Sunday, including days with no entries — with each day's total
/// intake, entry count, and whether it reached the goal.
class WeeklyDailyBreakdown extends ConsumerWidget {
  const WeeklyDailyBreakdown({super.key, required this.date});

  final DateTime date;

  static final DateFormat _dayNameFormat = DateFormat('EEEE');
  static final DateFormat _dateFormat = DateFormat('MMM d');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weekStart = WeeklyHistoryCalculator.startOfWeek(date);
    final resultAsync = ref.watch(weeklyHistoryProvider(weekStart));

    return HistoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Breakdown',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 16.h),

          resultAsync.when(
            data: (result) => Column(
              children: List.generate(
                result.days.length,
                (index) => _buildDayRow(
                  theme,
                  day: result.days[index],
                  isLast: index == result.days.length - 1,
                ),
              ),
            ),
            loading: () => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'Couldn\'t load this week\'s daily breakdown.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(
    ThemeData theme, {
    required WeeklyDayBreakdown day,
    required bool isLast,
  }) {
    final isToday = GeneralService.isToday(day.date);
    final hasEntries = day.entryCount > 0;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 84.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dayNameFormat.format(day.date),
                  style: AppTextStyles.bodySmallSemiBold.copyWith(
                    color: isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isToday ? 'Today' : _dateFormat.format(day.date),
                  style: AppTextStyles.captionXsMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  GeneralService.formatWater(day.totalMl),
                  style: AppTextStyles.bodySmallSemiBold.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${day.entryCount} ${day.entryCount == 1 ? 'entry' : 'entries'}',
                  style: AppTextStyles.captionXsMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: day.goalReached
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              !hasEntries
                  ? 'No data'
                  : (day.goalReached ? 'Reached' : 'Not reached'),
              style: AppTextStyles.captionXsMedium.copyWith(
                color: day.goalReached
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
