import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class SelectedDayHistory extends StatelessWidget {
  final DateTime selectedDate;

  const SelectedDayHistory({super.key, required this.selectedDate});

  // Demo data for the UI phase.
  static const List<_WaterEntry> _entries = [
    _WaterEntry(time: '8:00 AM', amount: 300),
    _WaterEntry(time: '10:30 AM', amount: 250),
    _WaterEntry(time: '1:00 PM', amount: 400),
    _WaterEntry(time: '4:30 PM', amount: 350),
    _WaterEntry(time: '7:00 PM', amount: 500),
    _WaterEntry(time: '9:00 PM', amount: 300),
  ];

  static const int dailyGoal = 2000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const totalIntake = 2100;

    final goalReached = totalIntake >= dailyGoal;
    final progress = (totalIntake / dailyGoal).clamp(0.0, 1.0);

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

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(totalIntake / 1000).toStringAsFixed(1)} L',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'of ${(dailyGoal / 1000).toStringAsFixed(1)} L',
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
                '${_entries.length} entries',
                style: AppTextStyles.captionXsMedium.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          ...List.generate(
            _entries.length,
            (index) => _buildEntry(
              theme,
              _entries[index],
              isLast: index == _entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(ThemeData theme, _WaterEntry entry, {required bool isLast}) {
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
                  entry.time,
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

class _WaterEntry {
  final String time;
  final int amount;

  const _WaterEntry({required this.time, required this.amount});
}
