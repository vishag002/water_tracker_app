import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/screens/history_screens.dart';

class HistoryDateSelector extends StatelessWidget {
  final HistoryView selectedView;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const HistoryDateSelector({
    super.key,
    required this.selectedView,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _buildArrowButton(
          context,
          theme: theme,
          icon: Icons.chevron_left,
          onTap: () {
            onDateChanged(_getPreviousDate());
          },
        ),

        Expanded(
          child: Center(
            child: Text(
              _getDateLabel(),
              style: AppTextStyles.bodySemiBold.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),

        _buildArrowButton(
          context,
          theme: theme,
          icon: Icons.chevron_right,
          onTap: _canGoForward()
              ? () {
                  onDateChanged(_getNextDate());
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildArrowButton(
    BuildContext context, {
    required ThemeData theme,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: 22.sp,
          color: onTap == null
              ? theme.colorScheme.onSurface.withOpacity(0.25)
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  String _getDateLabel() {
    switch (selectedView) {
      case HistoryView.daily:
        return DateFormat('MMMM d, yyyy').format(selectedDate);

      case HistoryView.weekly:
        final startOfWeek = _startOfWeek(selectedDate);
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        if (startOfWeek.year == endOfWeek.year &&
            startOfWeek.month == endOfWeek.month) {
          return '${DateFormat('MMM d').format(startOfWeek)} – '
              '${DateFormat('d, yyyy').format(endOfWeek)}';
        }

        return '${DateFormat('MMM d').format(startOfWeek)} – '
            '${DateFormat('MMM d, yyyy').format(endOfWeek)}';

      case HistoryView.monthly:
        return DateFormat('MMMM yyyy').format(selectedDate);
    }
  }

  DateTime _getPreviousDate() {
    switch (selectedView) {
      case HistoryView.daily:
        return selectedDate.subtract(const Duration(days: 1));

      case HistoryView.weekly:
        return selectedDate.subtract(const Duration(days: 7));

      case HistoryView.monthly:
        return DateTime(selectedDate.year, selectedDate.month - 1, 1);
    }
  }

  DateTime _getNextDate() {
    switch (selectedView) {
      case HistoryView.daily:
        return selectedDate.add(const Duration(days: 1));

      case HistoryView.weekly:
        return selectedDate.add(const Duration(days: 7));

      case HistoryView.monthly:
        return DateTime(selectedDate.year, selectedDate.month + 1, 1);
    }
  }

  bool _canGoForward() {
    final today = DateTime.now();

    switch (selectedView) {
      case HistoryView.daily:
        return selectedDate.isBefore(
          DateTime(today.year, today.month, today.day),
        );

      case HistoryView.weekly:
        final currentWeekStart = _startOfWeek(today);
        final selectedWeekStart = _startOfWeek(selectedDate);

        return selectedWeekStart.isBefore(currentWeekStart);

      case HistoryView.monthly:
        return selectedDate.year < today.year ||
            (selectedDate.year == today.year &&
                selectedDate.month < today.month);
    }
  }

  DateTime _startOfWeek(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);

    return dateOnly.subtract(
      Duration(days: dateOnly.weekday - DateTime.monday),
    );
  }
}
