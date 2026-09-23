import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/features/home/presentation/providers/user_name_provider.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_goal_provider.dart';

class WaterGoalScreen extends ConsumerStatefulWidget {
  const WaterGoalScreen({super.key});

  @override
  ConsumerState<WaterGoalScreen> createState() => _WaterGoalScreenState();
}

class _WaterGoalScreenState extends ConsumerState<WaterGoalScreen> {
  static const double _recommendedGoal = 2.0;
  static const List<double> _quickOptions = [1.5, 2.0, 2.5, 3.0];

  double goalLiters = _recommendedGoal;
  bool isCustomSelected = false;
  double customGoalLiters = 4.0;
  bool _isSaving = false;

  void _onQuickSelect(double liters) {
    setState(() {
      goalLiters = liters;
      isCustomSelected = false;
    });
  }

  void _onCustomSelect() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return _CustomGoalSheet(
          initialLiters: isCustomSelected ? goalLiters : customGoalLiters,
          onSave: (liters) {
            setState(() {
              goalLiters = liters;
              customGoalLiters = liters;
              isCustomSelected = true;
            });
          },
        );
      },
    );
  }

  void _onSliderChanged(double value) {
    setState(() {
      goalLiters = value;
      isCustomSelected = !_quickOptions.contains(value);
    });
  }

  Future<void> _onSaveGoal() async {
    if (_isSaving) return;
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(waterGoalRepositoryProvider)
          .createWaterGoal(userId: userId, goal: goalLiters, unit: 'L');
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.colour368AE9;
    return ScaffoldCustom(
      title: 'Water Goal',
      centerTitle: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            SizedBox(height: 5.h),
            //subtitle
            Text(
              'Set your daily water intake goal',
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 20.h),

            //daily goal card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    //icon
                    Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.water_drop,
                        size: 26.sp,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Text(
                      'Daily Goal',
                      style: AppTextStyles.bodySmallRegular.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      '${goalLiters.toStringAsFixed(1)} L',
                      style: AppTextStyles.headingSemiBold.copyWith(
                        fontSize: 34.sp,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(height: 20.h),

                    //slider with always-visible value bubble
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: accentColor,
                        inactiveTrackColor: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
                        thumbColor: accentColor,
                        overlayColor: accentColor.withValues(alpha: 0.15),
                        trackHeight: 4.h,
                        valueIndicatorColor: accentColor,
                        showValueIndicator: ShowValueIndicator.always,
                        valueIndicatorTextStyle: AppTextStyles.captionSemiBold
                            .copyWith(color: Colors.white),
                      ),
                      child: Slider(
                        value: goalLiters,
                        min: 1.0,
                        max: 3.5,
                        divisions: 5,
                        label: '${goalLiters.toStringAsFixed(1)} L',
                        onChanged: _onSliderChanged,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['1.0 L', '1.5 L', '2.0 L', '2.5 L', '3.5 L']
                            .map(
                              (label) => Text(
                                label,
                                style: AppTextStyles.captionXsRegular.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            //quick select
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Select',
                style: AppTextStyles.bodySmallSemiBold.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                for (final option in _quickOptions) ...[
                  Expanded(
                    child: _QuickSelectChip(
                      label: '${option.toStringAsFixed(1)} L',
                      isSelected: !isCustomSelected && goalLiters == option,
                      onTap: () => _onQuickSelect(option),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: _QuickSelectChip(
                    label: isCustomSelected
                        ? '${goalLiters.toStringAsFixed(1)} L'
                        : 'Custom',
                    isSelected: isCustomSelected,
                    onTap: _onCustomSelect,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            //why this goal info card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 36.h,
                      width: 36.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.water_drop,
                        size: 18.sp,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why this goal?',
                            style: AppTextStyles.bodySmallSemiBold.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Drinking ${goalLiters.toStringAsFixed(1)} liters of water daily helps maintain your body\'s balance and supports overall health.',
                            style: AppTextStyles.captionRegular.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),

            //save button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _onSaveGoal,
                icon: _isSaving
                    ? SizedBox(
                        height: 16.h,
                        width: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.check_circle, size: 18.sp),
                label: Text(
                  'Save Goal',
                  style: AppTextStyles.bodySmallSemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

//quick select chip
class _QuickSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickSelectChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.colour368AE9;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? accentColor
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.captionSemiBold.copyWith(
              color: isSelected
                  ? accentColor
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

//custom water goal bottom sheet content
class _CustomGoalSheet extends StatefulWidget {
  final double initialLiters;
  final ValueChanged<double> onSave;

  const _CustomGoalSheet({required this.initialLiters, required this.onSave});

  @override
  State<_CustomGoalSheet> createState() => _CustomGoalSheetState();
}

class _CustomGoalSheetState extends State<_CustomGoalSheet> {
  late double selectedLiters;

  @override
  void initState() {
    super.initState();
    selectedLiters = widget.initialLiters;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.colour368AE9;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 12.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //grabber + close button
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 4.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   child: GestureDetector(
                //     onTap: () => Navigator.pop(context),
                //     child: Container(
                //       height: 28.h,
                //       width: 28.w,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Theme.of(
                //           context,
                //         ).colorScheme.onSurface.withValues(alpha: 0.05),
                //       ),
                //       child: Icon(Icons.close, size: 16.sp),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 15.h),

            //icon
            Container(
              height: 56.h,
              width: 56.w,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.water_drop, size: 26.sp, color: accentColor),
            ),
            SizedBox(height: 12.h),

            //title
            Text(
              'Custom Water Goal',
              style: AppTextStyles.subtitleSemiBold.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Choose your daily water intake goal',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 20.h),

            //big value display
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: selectedLiters.toStringAsFixed(1),
                          style: AppTextStyles.headingSemiBold.copyWith(
                            color: accentColor,
                          ),
                        ),
                        TextSpan(
                          text: ' L',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Daily target',
                    style: AppTextStyles.captionRegular.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            //slider (0.5 L steps, 0.5 L - 10 L)
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: accentColor,
                inactiveTrackColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.1),
                thumbColor: accentColor,
                overlayColor: accentColor.withValues(alpha: 0.15),
                trackHeight: 4.h,
              ),
              child: Slider(
                value: selectedLiters,
                min: 0.5,
                max: 10,
                divisions: 19,
                onChanged: (value) {
                  setState(() {
                    selectedLiters = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0.5 L',
                    style: AppTextStyles.captionXsRegular.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    '${selectedLiters.toStringAsFixed(1)} L',
                    style: AppTextStyles.captionXsSemiBold.copyWith(
                      color: accentColor,
                    ),
                  ),
                  Text(
                    '10 L',
                    style: AppTextStyles.captionXsRegular.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            //recommended range info
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.water_drop, size: 14.sp, color: accentColor),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Recommended range   1.5 L ~ 4 L',
                      style: AppTextStyles.captionSemiBold.copyWith(
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            //how it works
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32.h,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 16.sp,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why this goal?',
                        style: AppTextStyles.bodySmallSemiBold.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Drinking ${selectedLiters.toStringAsFixed(1)} liters of water daily helps maintain your body's balance and supports overall health.",
                        style: AppTextStyles.captionRegular.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            //save button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(selectedLiters);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: Text(
                  'Save Goal',
                  style: AppTextStyles.bodySmallSemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
