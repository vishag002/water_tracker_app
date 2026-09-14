import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/streak/domain/calculators/streak_calculator.dart';
import 'package:water_tracker_app/features/streak/presentation/providers/streak_provider.dart';

/// Current streak, longest streak, and this month's completion rate,
/// sourced from [streakProvider] (real `water_entries` data). Always
/// reflects the *actual* current month — independent of whichever month
/// StreakCalendarCard has navigated to.
class StreakStatsCard extends ConsumerWidget {
  const StreakStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final resultAsync = ref.watch(streakProvider(DateTime.now()));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Streak Stats',
            style: AppTextStyles.bodySmallSemiBold.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 18.h),
          resultAsync.when(
            data: (result) => _buildStatsRow(theme, result),
            loading: () => SizedBox(
              height: 108.h,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => SizedBox(
              height: 108.h,
              child: Center(
                child: Text(
                  'Couldn\'t load streak stats.',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, StreakResult result) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.local_fire_department_outlined,
            value: '${result.currentStreak}',
            title: 'Current Streak',
            subtitle: 'days',
          ),
        ),

        const _VerticalDivider(),

        Expanded(
          child: _StatItem(
            icon: Icons.emoji_events_outlined,
            value: '${result.longestStreak}',
            title: 'Longest Streak',
            subtitle: 'days',
          ),
        ),

        const _VerticalDivider(),

        Expanded(
          child: _StatItem(
            icon: Icons.pie_chart_outline,
            value: '${result.completionPercent.round()}%',
            title: 'Completion Rate',
            subtitle: 'this month',
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String value;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 21.sp, color: theme.colorScheme.primary),
        ),
        SizedBox(height: 9.h),
        Text(
          value,
          style: AppTextStyles.headingSemiBold.copyWith(
            fontSize: 28.sp,
            height: 1,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.captionMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.captionRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 1,
      height: 108.h,
      color: theme.colorScheme.primary.withOpacity(0.08),
    );
  }
}
