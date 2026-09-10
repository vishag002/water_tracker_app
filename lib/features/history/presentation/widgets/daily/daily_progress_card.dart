import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';

class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({super.key});

  // Demo values for the UI phase.
  static const int consumedMl = 1800;
  static const int goalMl = 2000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (consumedMl / goalMl).clamp(0.0, 1.0);
    final percentage = ((consumedMl / goalMl) * 100).round();

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      child: Column(
        children: [
          Text(
            'Today\'s Progress',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 20.h),

          SizedBox(
            width: 150.w,
            height: 150.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150.w,
                  height: 150.w,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 12.w,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                ),

                SizedBox(
                  width: 150.w,
                  height: 150.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12.w,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(consumedMl / 1000).toStringAsFixed(1)} L',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'of ${(goalMl / 1000).toStringAsFixed(1)} L',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            '$percentage% of daily goal',
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
