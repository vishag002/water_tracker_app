import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class WeightInputField extends StatelessWidget {
  const WeightInputField({
    super.key,
    required this.initialValue,
    required this.errorText,
    required this.onChanged,
  });

  final String initialValue;
  final String? errorText;
  final ValueChanged<String> onChanged;

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
            'Your weight',
            style: AppTextStyles.bodySmallSemiBold.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.subtitleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. 65',
              hintStyle: AppTextStyles.subtitleMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              suffixText: 'kg',
              suffixStyle: AppTextStyles.bodyRegular.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              errorText: errorText,
              errorMaxLines: 2,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
