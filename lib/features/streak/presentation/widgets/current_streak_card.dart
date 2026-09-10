import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class CurrentStreakCard extends StatelessWidget {
  const CurrentStreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      child: Column(
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
                '12',
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
                  '24 Days',
                  style: AppTextStyles.captionXsSemiBold.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Divider
          Divider(
            height: 1.h,
            thickness: 1,
            color: theme.colorScheme.primary.withOpacity(0.08),
          ),

          SizedBox(height: 12.h),

          // Bottom statistics
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.water_drop_outlined,
                  value: '96',
                  label: 'Goal Days',
                ),
              ),

              Container(
                width: 1,
                height: 32.h,
                color: theme.colorScheme.primary.withOpacity(0.08),
              ),

              Expanded(
                child: _StatItem(
                  icon: Icons.water_outlined,
                  value: '80%',
                  label: 'Completion Rate',
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
