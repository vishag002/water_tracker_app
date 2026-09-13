import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/domain/calculators/monthly_history_calculator.dart';
import 'package:water_tracker_app/features/history/presentation/providers/monthly_history_provider.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

/// Calendar heatmap for the month containing [selectedDate], sourced
/// from [monthlyHistoryProvider] (real `water_entries` data). Tapping a
/// day reports it back via [onDateSelected] — [selectedDate] is the
/// single source of truth for both which month is shown and which day
/// is highlighted; callers should not keep a second, separate "selected
/// day" state.
class MonthlyHeatmap extends ConsumerWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const MonthlyHeatmap({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final monthStart = MonthlyHistoryCalculator.startOfMonth(selectedDate);
    final resultAsync = ref.watch(monthlyHistoryProvider(monthStart));

    return HistoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hydration Calendar',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            'Daily intake compared to your goal',
            style: AppTextStyles.bodySmallMedium.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),

          SizedBox(height: 18.h),

          _buildWeekdayHeader(theme),

          SizedBox(height: 8.h),

          resultAsync.when(
            data: (result) => _buildGrid(theme, result),
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
                'Couldn\'t load this month\'s calendar.',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildGrid(ThemeData theme, MonthlyHistoryResult result) {
    final leadingEmptyDays = result.firstWeekdayIndex;
    final daysInMonth = result.days.length;
    final totalCells = leadingEmptyDays + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows * 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 6.w,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - leadingEmptyDays + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final day = result.days[dayNumber - 1];

        return _buildDay(theme, day: day, goalMl: result.goalMl);
      },
    );
  }

  Widget _buildWeekdayHeader(ThemeData theme) {
    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: AppTextStyles.captionXsSemiBold.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDay(
    ThemeData theme, {
    required MonthlyDayBreakdown day,
    required int? goalMl,
  }) {
    final isSelected = _isSameDay(day.date, selectedDate);
    final isToday = _isSameDay(day.date, DateTime.now());
    final hasEntries = day.entryCount > 0;
    final dayColor = _getDayColor(theme, day: day, goalMl: goalMl);

    return GestureDetector(
      onTap: () => onDateSelected(day.date),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: dayColor,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2.w)
              : null,
        ),
        child: Center(
          child: Text(
            '${day.date.day}',
            style: AppTextStyles.captionXsMedium.copyWith(
              color: _getTextColor(theme, dayColor, hasEntries),
              fontWeight: isSelected || isToday
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// Intensity ramp derived from [ThemeData.colorScheme.primary] instead
  /// of fixed hex codes, so the heatmap adapts automatically to dark
  /// mode. No entries → "no data" tint; otherwise the shade ramps with
  /// intake relative to the goal (capped so it's visibly "full" once the
  /// goal is reached).
  Color _getDayColor(
    ThemeData theme, {
    required MonthlyDayBreakdown day,
    required int? goalMl,
  }) {
    if (day.entryCount == 0) {
      return theme.colorScheme.onSurface.withOpacity(0.04);
    }

    if (goalMl == null || goalMl <= 0) {
      return theme.colorScheme.primary.withOpacity(0.5);
    }

    final ratio = (day.totalMl / goalMl).clamp(0.0, 1.25);
    final t = ratio / 1.25;

    return Color.lerp(
      theme.colorScheme.primary.withOpacity(0.1),
      theme.colorScheme.primary,
      t,
    )!;
  }

  Color _getTextColor(ThemeData theme, Color dayColor, bool hasEntries) {
    if (!hasEntries) {
      return theme.colorScheme.onSurface.withOpacity(0.4);
    }

    // Contrast against the computed cell color, not a fixed design token —
    // the background itself is dynamically blended above.
    final isDarkCell =
        ThemeData.estimateBrightnessForColor(dayColor) == Brightness.dark;

    return isDarkCell ? Colors.white : theme.colorScheme.onSurface;
  }

  Widget _buildLegend(ThemeData theme) {
    const steps = [0.0, 0.25, 0.5, 0.75, 1.0];

    return Row(
      children: [
        Text(
          'Less',
          style: AppTextStyles.captionXsMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),

        SizedBox(width: 6.w),

        ...steps.map(
          (t) => Container(
            width: 16.w,
            height: 16.w,
            margin: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: Color.lerp(
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.primary,
                t,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),

        Text(
          'More',
          style: AppTextStyles.captionXsMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
