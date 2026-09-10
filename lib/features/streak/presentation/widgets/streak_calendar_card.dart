import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class StreakCalendarCard extends StatefulWidget {
  const StreakCalendarCard({super.key});

  @override
  State<StreakCalendarCard> createState() => _StreakCalendarCardState();
}

class _StreakCalendarCardState extends State<StreakCalendarCard> {
  DateTime _focusedDay = DateTime(2026, 9, 10);
  DateTime? _selectedDay;

  // Temporary UI data.
  // This will later come from Drift.
  final Set<DateTime> _completedDays = {
    // August
    DateTime(2026, 8, 17),
    DateTime(2026, 8, 18),
    DateTime(2026, 8, 19),
    DateTime(2026, 8, 21),
    DateTime(2026, 8, 22),
    DateTime(2026, 8, 23),
    DateTime(2026, 8, 25),
    DateTime(2026, 8, 26),
    DateTime(2026, 8, 27),
    DateTime(2026, 8, 29),
    DateTime(2026, 8, 30),
    DateTime(2026, 8, 31),

    // September
    DateTime(2026, 9, 1),
    DateTime(2026, 9, 2),
    DateTime(2026, 9, 3),
    DateTime(2026, 9, 4),
    DateTime(2026, 9, 6),
    DateTime(2026, 9, 7),
    DateTime(2026, 9, 8),
    DateTime(2026, 9, 9),
  };

  final Set<DateTime> _missedDays = {
    // August
    DateTime(2026, 8, 20),
    DateTime(2026, 8, 24),
    DateTime(2026, 8, 28),

    // September
    DateTime(2026, 9, 5),
  };

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isCompleted(DateTime day) {
    return _completedDays.any((date) => _isSameDate(date, day));
  }

  bool _isMissed(DateTime day) {
    return _missedDays.any((date) => _isSameDate(date, day));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          SizedBox(height: 4.h),
          _buildCalendar(theme),
          SizedBox(height: 6.h),
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(ThemeData theme) {
    return Row(
      children: [
        Text(
          '${_monthName(_focusedDay.month)} ${_focusedDay.year}',
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
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month - 1,
                1,
              );
            });
          },
        ),
        _buildNavigationButton(
          theme: theme,
          icon: Icons.chevron_right,
          onTap: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month + 1,
                1,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required ThemeData theme,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        width: 28.w,
        height: 28.h,
        child: Icon(icon, size: 19.sp, color: theme.colorScheme.onSurface),
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    return TableCalendar<void>(
      firstDay: DateTime(2024),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,
      currentDay: DateTime(2026, 9, 10),

      headerVisible: false,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,

      availableGestures: AvailableGestures.none,

      rowHeight: 38.h,
      daysOfWeekHeight: 22.h,

      sixWeekMonthsEnforced: false,

      selectedDayPredicate: (day) {
        return _selectedDay != null && _isSameDate(day, _selectedDay!);
      },

      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: AppTextStyles.captionXsRegular.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.55),
        ),
        weekendStyle: AppTextStyles.captionXsRegular.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.55),
        ),
      ),

      calendarStyle: const CalendarStyle(
        outsideDaysVisible: true,
        cellMargin: EdgeInsets.zero,
        cellPadding: EdgeInsets.zero,

        defaultDecoration: BoxDecoration(),
        weekendDecoration: BoxDecoration(),
        outsideDecoration: BoxDecoration(),
        todayDecoration: BoxDecoration(),
        selectedDecoration: BoxDecoration(),

        // Rendered via calendarBuilders instead — kept transparent so the
        // package's own text painter never shows through.
        defaultTextStyle: TextStyle(color: Colors.transparent),
        weekendTextStyle: TextStyle(color: Colors.transparent),
        outsideTextStyle: TextStyle(color: Colors.transparent),
        todayTextStyle: TextStyle(color: Colors.transparent),
        selectedTextStyle: TextStyle(color: Colors.transparent),
      ),

      calendarBuilders: CalendarBuilders<void>(
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayCell(theme, day);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayCell(theme, day, isToday: true);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(theme, day, isSelected: true);
        },
        outsideBuilder: (context, day, focusedDay) {
          return _buildDayCell(theme, day, isOutside: true);
        },
      ),

      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }

  Widget _buildDayCell(
    ThemeData theme,
    DateTime day, {
    bool isToday = false,
    bool isOutside = false,
    bool isSelected = false,
  }) {
    if (isOutside) {
      return Center(
        child: Text(
          '${day.day}',
          style: AppTextStyles.captionXsRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      );
    }

    if (isToday) {
      return _TodayDayCell(day: day);
    }

    if (_isCompleted(day)) {
      return _CompletedDayCell(day: day);
    }

    if (_isMissed(day)) {
      return _MissedDayCell(day: day);
    }

    return Center(
      child: Text(
        '${day.day}',
        style: AppTextStyles.captionXsRegular.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
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
        child: Icon(Icons.water_drop, size: 16.sp, color: theme.colorScheme.surface),
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
