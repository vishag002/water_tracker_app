import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key});

  // Demo values for the UI phase.
  static const int consumedMl = 1800;
  static const int entryCount = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Summary',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 18.h),

          Row(
            children: [
              Expanded(
                child: _buildStat(
                  theme,
                  value: '${(consumedMl / 1000).toStringAsFixed(1)} L',
                  label: 'Total Intake',
                ),
              ),

              Container(
                width: 1,
                height: 48.h,
                color: theme.colorScheme.outlineVariant,
              ),

              Expanded(
                child: _buildStat(
                  theme,
                  value: '$entryCount',
                  label: 'Entries',
                ),
              ),
            ],
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
          style: AppTextStyles.bodySemiBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          label,
          style: AppTextStyles.bodyRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
