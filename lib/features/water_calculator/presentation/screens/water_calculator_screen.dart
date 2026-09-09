import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/providers/water_calculator_provider.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/activity_level_card.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/environmental_info_card.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/hydration_result_card.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/methodology_card.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/use_goal_button.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/weight_stepper_card.dart';

/// Water Calculator screen (MVP).
///
/// UI -> [waterCalculatorProvider] -> `WaterCalculator` (pure Dart) ->
/// `WaterCalculatorResult`. No formula lives in this file.
///
/// Uses a custom header (title + subtitle stacked under a back button)
/// instead of `ScaffoldCustom`'s default AppBar, to match the approved
/// design.
class WaterCalculatorScreen extends ConsumerWidget {
  const WaterCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waterCalculatorProvider);
    final notifier = ref.read(waterCalculatorProvider.notifier);
    final theme = Theme.of(context);

    return ScaffoldCustom(
      showAppBar: false,
      body: Column(
        children: [
          _Header(theme: theme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeightStepperCard(
                    weightKg: state.weightKg,
                    canDecrement: state.canDecrementWeight,
                    canIncrement: state.canIncrementWeight,
                    onDecrement: notifier.decrementWeight,
                    onIncrement: notifier.incrementWeight,
                  ),
                  SizedBox(height: 16.h),
                  ActivityLevelCard(
                    selected: state.activityLevel,
                    onSelected: notifier.selectActivityLevel,
                  ),
                  SizedBox(height: 16.h),
                  HydrationResultCard(result: state.result),
                  SizedBox(height: 16.h),
                  const EnvironmentalInfoCard(),
                  SizedBox(height: 16.h),
                  const MethodologyCard(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: SafeArea(
              top: false,
              child: UseGoalButton(
                enabled: state.result != null,
                onPressed: state.result == null
                    ? null
                    : () {
                        // TODO(vishag): wire this up to the app's actual
                        // water goal (Hive) once persistence lands.
                        // For now, hand the calculated target back to
                        // whoever pushed this screen.
                        Navigator.of(context).pop(state.result!.totalWaterMl);
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.chevron_left,
                size: 28.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'Water Calculator',
                style: AppTextStyles.titleSemiBold.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Find your daily hydration target',
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
