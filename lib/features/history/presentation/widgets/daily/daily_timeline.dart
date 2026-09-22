import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/database/app_database.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/history_card.dart';
import 'package:water_tracker_app/providers/water_entry_provider.dart';

class DailyTimeline extends ConsumerWidget {
  const DailyTimeline({super.key, required this.date});

  final DateTime date;

  static final DateFormat _timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dayKey = GeneralService.dateOnly(date);
    final entriesAsync = ref.watch(waterEntriesForDayProvider(dayKey));

    return HistoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Water Intake',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 20.h),

          entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return _buildEmptyState(
                  theme,
                  isToday: GeneralService.isToday(date),
                );
              }

              // The DAO returns newest first; the timeline reads top-to-
              // bottom as the day happened, so flip to chronological order.
              final chronological = entries.reversed.toList();

              return Column(
                children: List.generate(
                  chronological.length,
                  (index) => _buildTimelineItem(
                    context,
                    ref,
                    theme: theme,
                    entry: chronological[index],
                    isLast: index == chronological.length - 1,
                  ),
                ),
              );
            },
            loading: () => SizedBox(
              height: 62.h,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'Couldn\'t load entries for this day.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, {required bool isToday}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        isToday
            ? 'No entries yet today. Add some water to see it here.'
            : 'No entries for this day.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    WidgetRef ref, {
    required ThemeData theme,
    required WaterEntry entry,
    required bool isLast,
  }) {
    return SizedBox(
      height: 62.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Column(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.w,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _timeFormat.format(entry.addedAt),
                        style: AppTextStyles.bodySemiBold.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '${entry.amount} ${entry.unit}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildEditButton(context, theme, entry),
                _buildDeleteButton(context, ref, theme, entry),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(
    BuildContext context,
    ThemeData theme,
    WaterEntry entry,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Open edit water entry dialog (post-MVP for this pass).
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34.w,
        height: 34.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(
          Icons.edit_outlined,
          size: 17.sp,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    WaterEntry entry,
  ) {
    return GestureDetector(
      onTap: () => _confirmDelete(context, ref, entry),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34.w,
        height: 34.w,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(
          Icons.delete_outline,
          size: 17.sp,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    WaterEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text(
          'Remove the ${entry.amount} ${entry.unit} entry at '
          '${_timeFormat.format(entry.addedAt)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(waterEntryRepositoryProvider).deleteEntry(entry.id);
    }
  }
}
