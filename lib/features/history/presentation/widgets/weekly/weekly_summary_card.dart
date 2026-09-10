import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class WeeklySummaryCard extends StatelessWidget {
  const WeeklySummaryCard({super.key});

  // Demo values for the UI phase.
  static const double totalIntake = 13.3;
  static const int totalEntries = 42;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStat(
              theme,
              icon: Icons.water_drop_outlined,
              value: '${totalIntake.toStringAsFixed(1)} L',
              label: 'Total Intake',
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: _buildStat(
              theme,
              icon: Icons.local_drink_outlined,
              value: '$totalEntries',
              label: 'Total Entries',
            ),
          ),
        ],
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
