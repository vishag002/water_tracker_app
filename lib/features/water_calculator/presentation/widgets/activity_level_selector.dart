import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/activity_level.dart';

class ActivityLevelSelector extends StatelessWidget {
  const ActivityLevelSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ActivityLevel selected;
  final ValueChanged<ActivityLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ActivityLevel.values.map((level) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _ActivityTile(
            level: level,
            isSelected: level == selected,
            onTap: () => onSelected(level),
          ),
        );
      }).toList(),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: AppTextStyles.bodySmallSemiBold.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    level.description,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.4),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
