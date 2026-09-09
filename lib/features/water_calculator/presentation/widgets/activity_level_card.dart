import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/activity_level.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/activity_level_selector.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/section_header.dart';

/// Card wrapping the "Activity level" header and the selectable list of
/// [ActivityLevel] options.
class ActivityLevelCard extends StatelessWidget {
  const ActivityLevelCard({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ActivityLevel selected;
  final ValueChanged<ActivityLevel> onSelected;

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
            icon: Icons.directions_run_rounded,
            title: 'Activity level',
            subtitle: 'Select your usual activity',
          ),
          SizedBox(height: 16.h),
          ActivityLevelSelector(selected: selected, onSelected: onSelected),
        ],
      ),
    );
  }
}
