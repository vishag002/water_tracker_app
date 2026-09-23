import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_entry_provider.dart';
import 'package:water_tracker_app/features/home/domain/daily_intake_calculator.dart';

class DailySummaryCard extends ConsumerWidget {
  const DailySummaryCard({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dayKey = GeneralService.dateOnly(date);
    final entriesAsync = ref.watch(waterEntriesForDayProvider(dayKey));

    return HistoryCard(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GeneralService.isToday(date) ? 'Today\'s Summary' : 'Summary',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 18.h),

          entriesAsync.when(
            data: (entries) {
              final consumedMl = DailyIntakeCalculator.totalMl(
                entries.map((e) => e.amount).toList(),
              );

              return Row(
                children: [
                  Expanded(
                    child: _buildStat(
                      theme,
                      value: GeneralService.formatWater(consumedMl),
                      label: 'Total Intake',
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 48.h,
                    color: theme.colorScheme.outlineVariant,
                  ),

                  Expanded(
                    child: _buildStat(
                      theme,
                      value: '${entries.length}',
                      label: 'Entries',
                    ),
                  ),
                ],
              );
            },
            loading: () => _buildStatusRow(
              theme,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, stackTrace) => _buildStatusRow(
              theme,
              child: Text(
                'Couldn\'t load this day\'s summary.',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(ThemeData theme, {required Widget child}) {
    return SizedBox(
      height: 48.h,
      child: Center(child: child),
    );
  }

  Widget _buildStat(
    ThemeData theme, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodySemiBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          label,
          style: AppTextStyles.bodyRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
