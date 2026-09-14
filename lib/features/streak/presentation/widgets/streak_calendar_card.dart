import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/streak/domain/calculators/streak_calculator.dart';
import 'package:water_tracker_app/features/streak/presentation/providers/streak_provider.dart';

/// Monthly calendar of hydration outcomes, sourced from [streakProvider]
/// (real `water_entries` data) for whichever month [_focusedMonth] is
/// currently showing. Month navigation only changes which month's day
/// statuses are displayed here — it does not affect the current/longest
/// streak shown in CurrentStreakCard/StreakStatsCard, which are always
/// based on the full history relative to today.
///
/// Built as a plain `GridView`, the same approach the Month History
/// heatmap uses, rather than a third-party calendar package — keeps
/// this feature on the same architecture as the rest of the app instead
/// of introducing a new dependency for one screen.
class StreakCalendarCard extends ConsumerStatefulWidget {
  const StreakCalendarCard({super.key});

  @override
  ConsumerState<StreakCalendarCard> createState() =>
      _StreakCalendarCardState();
}

class _StreakCalendarCardState extends ConsumerState<StreakCalendarCard> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resultAsync = ref.watch(streakProvider(_focusedMonth));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.035),
            blurRadius: 12.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMonthHeader(theme),
          SizedBox(height: 12.h),
          _buildWeekdayHeader(theme),
          SizedBox(height: 8.h),
          resultAsync.when(
            data: (result) => _buildCalendarGrid(theme, result),
            loading: () => SizedBox(
              height: 260.h,
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
          SizedBox(height: 10.h),
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(ThemeData theme) {
    return Row(
      children: [
        Text(
          '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
          style: AppTextStyles.captionSemiBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        _buildNavigationButton(
          theme: theme,
          icon: Icons.chevron_left,
          onTap: () {
            setState(() {
              _focusedMonth = DateTime(
                _focusedMonth.year,
                _focusedMonth.month - 1,
                1,
              );
            });
          },
        ),
        _buildNavigationButton(
          theme: theme,
          icon: Icons.chevron_right,
          // Mirrors HistoryDateSelector's monthly "can't go forward past
          // the current month" rule — the streak calendar shouldn't
          // navigate into the future either.
          onTap: _canGoForward()
              ? () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month + 1,
                      1,
                    );
                  });
                }
              : null,
        ),
      ],
    );
  }

  bool _canGoForward() {
    final today = DateTime.now();
    return _focusedMonth.year < today.year ||
        (_focusedMonth.year == today.year &&
            _focusedMonth.month < today.month);
  }

  Widget _buildNavigationButton({
    required ThemeData theme,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        width: 28.w,
        height: 28.h,
        child: Icon(
          icon,
          size: 19.sp,
          color: onTap == null
              ? theme.colorScheme.onSurface.withOpacity(0.25)
              : theme.colorScheme.onSurface,
        ),
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
              style: AppTextStyles.captionXsRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme, StreakResult result) {
    // Monday = 0 ... Sunday = 6, so the grid lines up under the M T W T
    // F S S header above — same convention as MonthlyHeatmap.
    final firstWeekdayIndex =
        result.calendarMonthStart.weekday - DateTime.monday;
    final daysInMonth = result.dailyStatuses.length;
    final totalCells = firstWeekdayIndex + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows * 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4.h,
        crossAxisSpacing: 4.w,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekdayIndex + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        return _buildDayCell(theme, result.dailyStatuses[dayNumber - 1]);
      },
    );
  }

  Widget _buildDayCell(ThemeData theme, StreakDayStatus day) {
    if (day.isToday) {
      return _TodayDayCell(day: day.date);
    }

    switch (day.status) {
      case DayStreakStatus.success:
        return _CompletedDayCell(day: day.date);
      case DayStreakStatus.missed:
        return _MissedDayCell(day: day.date);
      case DayStreakStatus.noData:
        return Center(
          child: Text(
            '${day.date.day}',
            style: AppTextStyles.captionXsRegular.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        );
    }
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          icon: Icons.check_box,
          iconColor: theme.colorScheme.primary,
          label: 'Goal Completed',
        ),
        SizedBox(width: 22.w),
        _LegendItem(
          icon: Icons.radio_button_unchecked,
          iconColor: theme.colorScheme.onSurface.withOpacity(0.3),
          label: 'Missed',
        ),
        SizedBox(width: 22.w),
        _LegendItem(
          icon: Icons.circle,
          iconColor: theme.colorScheme.primary,
          label: 'Today',
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}

class _CompletedDayCell extends StatelessWidget {
  const _CompletedDayCell({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: 30.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(7.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: AppTextStyles.captionXsSemiBold.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _MissedDayCell extends StatelessWidget {
  const _MissedDayCell({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: 30.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: AppTextStyles.captionXsRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

class _TodayDayCell extends StatelessWidget {
  const _TodayDayCell({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: 30.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(7.r),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.water_drop,
          size: 16.sp,
          color: theme.colorScheme.surface,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11.sp, color: iconColor),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.captionXsRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
