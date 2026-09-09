import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/methodology_detail_sheet.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/section_header.dart';

/// Compact, tappable summary row. Tapping opens
/// [MethodologyDetailSheet] with the full explanation and the safety
/// disclaimer — kept off the main screen to match the approved design,
/// but never removed from the app.
class MethodologyCard extends StatelessWidget {
  const MethodologyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => showMethodologyDetailSheet(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SectionHeader(
          icon: Icons.lightbulb_outline_rounded,
          title: 'How your estimate is calculated',
          subtitle: 'Your baseline uses 35 mL per kg of body weight. An '
              'additional exercise allowance is added based on your '
              'selected activity level.',
          trailing: Icon(
            Icons.chevron_right,
            size: 20.sp,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}
