import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class MethodologySection extends StatelessWidget {
  const MethodologySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How your estimate is calculated',
            style: AppTextStyles.bodySmallSemiBold.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your baseline estimate uses 35 mL of fluid per kilogram of '
            'body weight. An additional exercise estimate is added based '
            'on your selected activity level.',
            style: AppTextStyles.captionRegular.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Exercise fluid needs vary between people depending on '
            'factors such as sweat rate, exercise intensity, duration, '
            'and environmental conditions. This result is an estimate, '
            'not a medical prescription.',
            style: AppTextStyles.captionRegular.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'This calculator provides a general estimate for healthy '
              'adults. Individual fluid needs can vary. If you have a '
              'medical condition that affects fluid intake or have been '
              'advised to restrict or increase fluids, follow your '
              'healthcare professional\'s guidance.',
              style: AppTextStyles.captionRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
