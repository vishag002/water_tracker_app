import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class SettingsCard extends StatelessWidget {
  final String leadingAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final dynamic height;

  const SettingsCard({
    super.key,
    required this.leadingAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leading,
    this.trailing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height ?? 80.h,
        width: 332.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            leading ?? Image.asset(leadingAsset, width: 25.w, height: 25.h),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmallSemiBold.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  size: 22.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
          ],
        ),
      ),
    );
  }
}
