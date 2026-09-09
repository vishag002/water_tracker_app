import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/section_header.dart';

/// Weight entry as a stepper (-/value/+) instead of a free-text field,
/// matching the approved design.
class WeightStepperCard extends StatelessWidget {
  const WeightStepperCard({
    super.key,
    required this.weightKg,
    required this.canDecrement,
    required this.canIncrement,
    required this.onDecrement,
    required this.onIncrement,
  });

  final double weightKg;
  final bool canDecrement;
  final bool canIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

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
          const SectionHeader(
            icon: Icons.monitor_weight_outlined,
            title: 'Your weight',
            subtitle: 'Enter your body weight',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove,
                onTap: canDecrement ? onDecrement : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    weightKg.toStringAsFixed(0),
                    style: AppTextStyles.subtitleSemiBold.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              _StepButton(
                icon: Icons.add,
                onTap: canIncrement ? onIncrement : null,
              ),
              SizedBox(width: 12.w),
              Text(
                'kg',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }
}
