import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/streak/domain/calculators/streak_calculator.dart';
import 'package:water_tracker_app/features/streak/presentation/providers/streak_provider.dart';

/// Current/longest streak plus this month's Goal Days and Completion
/// Rate, sourced from [streakProvider] (real `water_entries` data).
/// Always reflects the *actual* current month/day — independent of
/// whichever month StreakCalendarCard has navigated to below it.
class CurrentStreakCard extends ConsumerWidget {
  const CurrentStreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final resultAsync = ref.watch(streakProvider(DateTime.now()));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: resultAsync.when(
        data: (result) => _buildContent(theme, result),
        loading: () => SizedBox(
          height: 190.h,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (error, stackTrace) => SizedBox(
          height: 190.h,
          child: Center(
            child: Text(
              'Couldn\'t load streak data.',
              style: AppTextStyles.bodyRegular.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, StreakResult result) {
    return Column(
      children: [
        // Streak icon
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.water_drop,
            size: 21.sp,
            color: theme.colorScheme.primary,
          ),
        ),

        SizedBox(height: 7.h),

        // Current streak label
        Text(
          'Current Streak',
          style: AppTextStyles.captionXsMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.65),
          ),
        ),

        SizedBox(height: 1.h),

        // Streak value
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${result.currentStreak}',
              style: AppTextStyles.headingSemiBold.copyWith(
                fontSize: 38.sp,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 7.w),
            Text(
              'Days',
              style: AppTextStyles.bodySmallSemiBold.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Longest streak pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 12.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 5.w),
              Text(
                'Longest Streak:',
                style: AppTextStyles.captionXsRegular.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                '${result.longestStreak} Days',
                style: AppTextStyles.captionXsSemiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // SizedBox(height: 14.h),

        // // Divider
        // Divider(
        //   height: 1.h,
        //   thickness: 1,
        //   color: theme.colorScheme.primary.withOpacity(0.08),
        // ),

        // SizedBox(height: 12.h),

        // Bottom statistics
        // Row(
        //   children: [
        //     Expanded(
        //       child: _StatItem(
        //         icon: Icons.water_drop_outlined,
        //         value: '${result.goalDays}',
        //         label: 'Goal Days',
        //       ),
        //     ),

        //     Container(
        //       width: 1,
        //       height: 32.h,
        //       color: theme.colorScheme.primary.withOpacity(0.08),
        //     ),

        //     Expanded(
        //       child: _StatItem(
        //         icon: Icons.water_outlined,
        //         value: '${result.completionPercent.round()}%',
        //         label: 'Completion Rate',
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20.sp, color: theme.colorScheme.primary),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.bodySmallSemiBold.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextStyles.captionXsRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
