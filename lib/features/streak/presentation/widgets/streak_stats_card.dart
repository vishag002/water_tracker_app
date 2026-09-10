import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class StreakStatsCard extends StatelessWidget {
  const StreakStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.local_fire_department_outlined,
                  value: '12',
                  title: 'Current Streak',
                  subtitle: 'days',
                ),
              ),

              const _VerticalDivider(),

              Expanded(
                child: _StatItem(
                  icon: Icons.emoji_events_outlined,
                  value: '24',
                  title: 'Longest Streak',
                  subtitle: 'days',
                ),
              ),

              const _VerticalDivider(),

              Expanded(
                child: _StatItem(
                  icon: Icons.pie_chart_outline,
                  value: '80%',
                  title: 'Completion Rate',
                  subtitle: 'this month',
                ),
              ),
            ],
          ),
        ],
      ),
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
