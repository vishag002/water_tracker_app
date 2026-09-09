import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

/// Opens the full methodology explanation and safety disclaimer as a
/// modal bottom sheet.
Future<void> showMethodologyDetailSheet(BuildContext context) {
  final theme = Theme.of(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: theme.scaffoldBackgroundColor,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (context) => const MethodologyDetailSheet(),
  );
}

class MethodologyDetailSheet extends StatelessWidget {
  const MethodologyDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'How your estimate is calculated',
              style: AppTextStyles.subtitleSemiBold.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Your baseline estimate uses 35 mL of fluid per kilogram of '
              'body weight. An additional exercise estimate is added based '
              'on your selected activity level.',
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Exercise fluid needs vary between people depending on '
              'factors such as sweat rate, exercise intensity, duration, '
              'and environmental conditions. This result is an estimate, '
              'not a medical prescription.',
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(14.w),
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
      ),
    );
  }
}
