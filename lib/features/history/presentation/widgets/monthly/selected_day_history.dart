import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/database/app_database.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';
import 'package:water_tracker_app/providers/water_goal_provider.dart';
import 'package:water_tracker_app/screens/home/domain/calculators/daily_intake_calculator.dart';

/// Same default the app seeds on first launch (see HomeScreen) — used
/// only as a display fallback before the real goal has loaded. Mirrors
/// weeklyHistoryProvider's fallback.
const double _defaultGoalLiters = 2.0;

/// Real entries for [selectedDate], reusing the existing
/// [waterEntriesForDayProvider] — the same provider the Daily tab
/// watches — rather than a second day-query mechanism.
class SelectedDayHistory extends ConsumerWidget {
  final DateTime selectedDate;

  const SelectedDayHistory({super.key, required this.selectedDate});

  static final DateFormat _timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entriesAsync = ref.watch(waterEntriesForDayProvider(selectedDate));
    final goalAsync = ref.watch(currentWaterGoalProvider);

    return HistoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('d MMMM yyyy').format(selectedDate),
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 16.h),

          entriesAsync.when(
            data: (entries) => _buildBody(theme, entries, goalAsync.value),
            loading: () => Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Couldn\'t load this day\'s entries.',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    List<WaterEntry> entries,
    WaterGoal? goal,
  ) {
    final goalMl = ((goal?.goal ?? _defaultGoalLiters) * 1000).round();
    final totalIntake = DailyIntakeCalculator.totalMl(
      entries.map((e) => e.amount).toList(),
    );
    final goalReached = goalMl > 0 && totalIntake >= goalMl;
    final progress = goalMl > 0
        ? (totalIntake / goalMl).clamp(0.0, 1.0)
        : 0.0;

    // Oldest first, matching a chronological timeline read top-to-bottom.
    final sortedEntries = [...entries]
      ..sort((a, b) => a.addedAt.compareTo(b.addedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GeneralService.formatWater(totalIntake),
                    style: AppTextStyles.headingMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'of ${GeneralService.formatGoal(goalMl / 1000)}',
                    style: AppTextStyles.bodySmallMedium.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: goalReached
                    ? theme.colorScheme.primary.withOpacity(0.08)
                    : theme.colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                goalReached ? 'Goal Reached' : 'Goal Not Reached',
                style: AppTextStyles.captionXsMedium.copyWith(
                  color: goalReached
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
        ),

        SizedBox(height: 20.h),

        Row(
          children: [
            Text(
              'Intake History',
              style: AppTextStyles.titleMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              '${sortedEntries.length} '
              '${sortedEntries.length == 1 ? 'entry' : 'entries'}',
              style: AppTextStyles.captionXsMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        if (sortedEntries.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No entries for this day.',
              style: AppTextStyles.bodySmallMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          )
        else
          ...List.generate(
            sortedEntries.length,
            (index) => _buildEntry(
              theme,
              sortedEntries[index],
              isLast: index == sortedEntries.length - 1,
            ),
          ),
      ],
    );
  }

  Widget _buildEntry(
    ThemeData theme,
    WaterEntry entry, {
    required bool isLast,
  }) {
    return SizedBox(
      height: 52.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Column(
              children: [
                Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.w,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Row(
              children: [
                Text(
                  _timeFormat.format(entry.addedAt),
                  style: AppTextStyles.bodySmallSemiBold.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const Spacer(),

                Text(
                  '${entry.amount} ml',
                  style: AppTextStyles.bodySmallMedium.copyWith(
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
