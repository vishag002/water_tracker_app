import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class DailyTimeline extends StatelessWidget {
  const DailyTimeline({super.key});

  // Demo data for the UI phase.
  static const List<_WaterEntry> _entries = [
    _WaterEntry(time: '8:00 AM', amount: 300),
    _WaterEntry(time: '10:30 AM', amount: 250),
    _WaterEntry(time: '1:00 PM', amount: 400),
    _WaterEntry(time: '4:30 PM', amount: 350),
    _WaterEntry(time: '7:00 PM', amount: 500),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HistoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Water Intake',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 20.h),

          ...List.generate(
            _entries.length,
            (index) => _buildTimelineItem(
              context,
              theme: theme,
              entry: _entries[index],
              isLast: index == _entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required ThemeData theme,
    required _WaterEntry entry,
    required bool isLast,
  }) {
    return SizedBox(
      height: 62.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Column(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
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

          SizedBox(width: 12.w),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.time,
                        style: AppTextStyles.bodySemiBold.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '${entry.amount} ml',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildEditButton(context, theme, entry),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(
    BuildContext context,
    ThemeData theme,
    _WaterEntry entry,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Open edit water entry dialog.
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34.w,
        height: 34.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(
          Icons.edit_outlined,
          size: 17.sp,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _WaterEntry {
  final String time;
  final int amount;

  const _WaterEntry({required this.time, required this.amount});
}
