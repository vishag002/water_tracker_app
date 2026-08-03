import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class QuickAddButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  final String title;

  const QuickAddButtonWidget({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 90.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,

          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageUrl,
              color: Theme.of(context).colorScheme.onSurface,
              width: 32.w,
              height: 32.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.h),
            Text(title, style: AppTextStyles.bodySmallSemiBold),
          ],
        ),
      ),
    );
  }
}
