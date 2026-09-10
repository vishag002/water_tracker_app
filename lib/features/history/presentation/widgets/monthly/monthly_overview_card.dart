import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class MonthlyOverviewCard extends StatelessWidget {
  const MonthlyOverviewCard({super.key});

  // Demo values for the UI phase.
  static const int goalDays = 22;
  static const double totalIntake = 45.2;
  static const int completionRate = 73;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Monthly Overview',
              style: AppTextStyles.titleMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          Row(
            children: [
              Expanded(
                child: _buildStat(
                  theme,
                  value: '$goalDays',
                  label: 'Goal Days',
                ),
              ),

              _buildDivider(theme),

              Expanded(
                child: _buildStat(
                  theme,
                  value: '${totalIntake.toStringAsFixed(1)} L',
                  label: 'Total Intake',
                ),
              ),

              _buildDivider(theme),

              Expanded(
                child: _buildStat(
                  theme,
                  value: '$completionRate%',
                  label: 'Completion',
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
          style: AppTextStyles.headingMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 4.h),

        Text(
          label,
          style: AppTextStyles.bodySmallMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(width: 1.w, height: 48.h, color: theme.colorScheme.outlineVariant);
  }
}
