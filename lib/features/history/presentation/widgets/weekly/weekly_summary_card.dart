import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/features/history/domain/calculators/weekly_history_calculator.dart';
import 'package:water_tracker_app/features/history/presentation/providers/weekly_history_provider.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

/// Total intake and total entries for the week containing [date],
/// sourced from [weeklyHistoryProvider] (real `water_entries` data).
class WeeklySummaryCard extends ConsumerWidget {
  const WeeklySummaryCard({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weekStart = WeeklyHistoryCalculator.startOfWeek(date);
    final resultAsync = ref.watch(weeklyHistoryProvider(weekStart));

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      child: resultAsync.when(
        data: (result) => Row(
          children: [
            Expanded(
              child: _buildStat(
                theme,
                icon: Icons.water_drop_outlined,
                value: GeneralService.formatWater(result.totalIntakeMl),
                label: 'Total Intake',
              ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: _buildStat(
                theme,
                icon: Icons.local_drink_outlined,
                value: '${result.totalEntries}',
                label: 'Total Entries',
              ),
            ),
          ],
        ),
        loading: () => SizedBox(
          height: 62.h,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (error, stackTrace) => SizedBox(
          height: 62.h,
          child: Center(
            child: Text(
              'Couldn\'t load this week\'s summary.',
              style: AppTextStyles.bodyRegular.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(
    ThemeData theme, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp, color: theme.colorScheme.primary),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: AppTextStyles.captionXsMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
