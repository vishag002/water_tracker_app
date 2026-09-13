import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/features/history/domain/calculators/monthly_history_calculator.dart';
import 'package:water_tracker_app/features/history/presentation/providers/monthly_history_provider.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

/// Goal-reached days, total intake, and completion percentage for the
/// month containing [date], sourced from [monthlyHistoryProvider] (real
/// `water_entries` data). Completion is calculated in
/// [MonthlyHistoryCalculator] — see `completionPercent` — not derived
/// here in the widget.
class MonthlyOverviewCard extends ConsumerWidget {
  const MonthlyOverviewCard({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final monthStart = MonthlyHistoryCalculator.startOfMonth(date);
    final resultAsync = ref.watch(monthlyHistoryProvider(monthStart));

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Monthly Overview',
              style: AppTextStyles.titleMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          resultAsync.when(
            data: (result) => Row(
              children: [
                Expanded(
                  child: _buildStat(
                    theme,
                    value: '${result.daysGoalReached}',
                    label: 'Goal Days',
                  ),
                ),

                _buildDivider(theme),

                Expanded(
                  child: _buildStat(
                    theme,
                    value: GeneralService.formatWater(result.totalIntakeMl),
                    label: 'Total Intake',
                  ),
                ),

                _buildDivider(theme),

                Expanded(
                  child: _buildStat(
                    theme,
                    value: '${result.completionPercent.round()}%',
                    label: 'Completion',
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
                  'Couldn\'t load this month\'s summary.',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    ThemeData theme, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headingMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 4.h),

        Text(
          label,
          style: AppTextStyles.bodySmallMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      width: 1.w,
      height: 48.h,
      color: theme.colorScheme.outlineVariant,
    );
  }
}
