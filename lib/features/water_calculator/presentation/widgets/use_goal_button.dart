import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

/// Pinned bottom call-to-action. Disabled until a result is available.
///
/// NOTE: this currently only invokes [onPressed] — it does not persist
/// anything. Wiring it up to the app's actual water goal (Hive) is
/// post-MVP, matching the TODO already on the Reminder screen's Save
/// Changes button.
class UseGoalButton extends StatelessWidget {
  const UseGoalButton({super.key, required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 13.sp,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Use This Goal',
              style: AppTextStyles.bodySmallSemiBold.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
