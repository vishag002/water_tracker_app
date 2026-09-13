import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';
import 'package:water_tracker_app/providers/water_goal_provider.dart';
import 'package:water_tracker_app/screens/home/domain/calculators/daily_intake_calculator.dart';

class DailyProgressCard extends ConsumerWidget {
  const DailyProgressCard({super.key, required this.date});

  final DateTime date;

  // Same default the app seeds on first launch (see HomeScreen), used
  // only as a display fallback before the real goal has loaded.
  static const int _defaultGoalLiters = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dayKey = GeneralService.dateOnly(date);

    final entriesAsync = ref.watch(waterEntriesForDayProvider(dayKey));
    final goalAsync = ref.watch(currentWaterGoalProvider);

    final isLoading = entriesAsync.isLoading || goalAsync.isLoading;
    final error = entriesAsync.error ?? goalAsync.error;

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      child: Column(
        children: [
          Text(
            GeneralService.isToday(date) ? 'Today\'s Progress' : 'Progress',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 20.h),

          if (isLoading)
            _buildStatus(
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (error != null)
            _buildStatus(
              child: Text(
                'Couldn\'t load today\'s progress.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyRegular.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            )
          else
            _buildRing(
              theme,
              consumedMl: DailyIntakeCalculator.totalMl(
                (entriesAsync.value ?? const []).map((e) => e.amount).toList(),
              ),
              // The goal table's `unit` isn't user-selectable yet (see
              // WaterGoalEditDialog) — goals are always entered and stored
              // in liters for V1, same assumption HomeScreen makes.
              goalMl: (goalAsync.value?.goal ?? _defaultGoalLiters) * 1000,
            ),
        ],
      ),
    );
  }

  Widget _buildStatus({required Widget child}) {
    return SizedBox(width: 150.w, height: 150.w, child: Center(child: child));
  }

  Widget _buildRing(
    ThemeData theme, {
    required int consumedMl,
    required int goalMl,
  }) {
    final safeGoalMl = goalMl > 0 ? goalMl : 1;
    final progress = (consumedMl / safeGoalMl).clamp(0.0, 1.0);
    final percentage = ((consumedMl / safeGoalMl) * 100).round();

    return Column(
      children: [
        SizedBox(
          width: 150.w,
          height: 150.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150.w,
                height: 150.w,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 12.w,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(
                    theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ),

              SizedBox(
                width: 150.w,
                height: 150.w,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12.w,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(consumedMl / 1000).toStringAsFixed(1)} L',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'of ${(goalMl / 1000).toStringAsFixed(1)} L',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        Text(
          '$percentage% of daily goal',
          style: AppTextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
