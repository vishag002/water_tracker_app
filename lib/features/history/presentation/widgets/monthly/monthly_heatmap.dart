import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class MonthlyHeatmap extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const MonthlyHeatmap({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  // Demo data for the UI phase.
  static const Map<int, double> _dailyIntake = {
    1: 1.8,
    2: 2.1,
    3: 2.4,
    4: 1.2,
    5: 0.8,
    6: 2.0,
    7: 2.3,
    8: 1.6,
    9: 2.2,
    10: 2.1,
    11: 1.4,
    12: 1.9,
    13: 2.5,
    14: 1.1,
    15: 2.0,
    16: 2.3,
    17: 1.7,
    18: 2.1,
    19: 2.6,
    20: 1.3,
    21: 2.0,
    22: 2.2,
    23: 1.8,
    24: 0.9,
    25: 2.4,
    26: 2.0,
    27: 1.5,
    28: 2.3,
    29: 1.9,
    30: 2.1,
  };

  static const double _dailyGoal = 2.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);

    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    // Monday = 1 ... Sunday = 7.
    final leadingEmptyDays = firstDay.weekday - 1;

    final totalCells = leadingEmptyDays + daysInMonth;
    final rows = (totalCells / 7).ceil();

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

          GridView.builder(
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

              final date = DateTime(
                selectedDate.year,
                selectedDate.month,
                dayNumber,
              );

              final intake = _dailyIntake[dayNumber];

              return _buildDay(
                theme,
                date: date,
                dayNumber: dayNumber,
                intake: intake,
              );
            },
          ),

          SizedBox(height: 16.h),

          _buildLegend(theme),
        ],
      ),
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
    required DateTime date,
    required int dayNumber,
    required double? intake,
  }) {
    final isSelected = _isSameDay(date, selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final dayColor = _getDayColor(theme, intake);

    return GestureDetector(
      onTap: () => onDateSelected(date),
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
            '$dayNumber',
            style: AppTextStyles.captionXsMedium.copyWith(
              color: _getTextColor(theme, dayColor, intake),
              fontWeight: isSelected || isToday
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// Intensity ramp derived from [ThemeData.colorScheme.primary] instead of
  /// fixed hex codes, so the heatmap adapts automatically to dark mode.
  Color _getDayColor(ThemeData theme, double? intake) {
    if (intake == null) {
      return theme.colorScheme.onSurface.withOpacity(0.04);
    }

    final ratio = (intake / _dailyGoal).clamp(0.0, 1.25);
    final t = ratio / 1.25;

    return Color.lerp(
      theme.colorScheme.primary.withOpacity(0.1),
      theme.colorScheme.primary,
      t,
    )!;
  }

  Color _getTextColor(ThemeData theme, Color dayColor, double? intake) {
    if (intake == null) {
      return theme.colorScheme.onSurface.withOpacity(0.4);
    }

    // Contrast against the computed cell color, not a fixed design token —
    // the background itself is dynamically blended above.
    final isDarkCell = ThemeData.estimateBrightnessForColor(dayColor) ==
        Brightness.dark;

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
