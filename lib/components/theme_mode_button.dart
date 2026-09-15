import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/core/theme/theme_provider.dart';
import 'package:water_tracker_app/enum/theme_type_enum.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    final isDark =
        themeType == ThemeType.dark ||
        (themeType == ThemeType.system &&
            platformBrightness == Brightness.dark);
    final isLightMode = !isDark;

    final theme = Theme.of(context);
    return Container(
      width: 320.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.surface.withOpacity(0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          children: [
            Expanded(
              child: _ModeCard(
                icon: Icons.wb_sunny_outlined,
                label: 'Light Mode',
                selected: isLightMode,
                onTap: () => ref
                    .read(themeProvider.notifier)
                    .changeTheme(ThemeType.light),
              ),
            ),
            Expanded(
              child: _ModeCard(
                icon: Icons.nightlight_round,
                label: 'Dark Mode',
                selected: !isLightMode,
                onTap: () => ref
                    .read(themeProvider.notifier)
                    .changeTheme(ThemeType.dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.colour368AE9.withOpacity(0.1)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26.sp,
              color: selected ? AppColors.colour368AE9 : AppColors.textLight,
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.colour368AE9 : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
