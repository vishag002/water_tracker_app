import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/history/presentation/screens/history_screens.dart';

class HistoryViewSelector extends StatelessWidget {
  final HistoryView selectedView;
  final ValueChanged<HistoryView> onViewChanged;

  const HistoryViewSelector({
    super.key,
    required this.selectedView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildItem(theme, HistoryView.daily, 'Daily'),
          _buildItem(theme, HistoryView.weekly, 'Week'),
          _buildItem(theme, HistoryView.monthly, 'Month'),
        ],
      ),
    );
  }

  Widget _buildItem(ThemeData theme, HistoryView view, String label) {
    final isSelected = selectedView == view;

    return Expanded(
      child: GestureDetector(
        onTap: () => onViewChanged(view),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmallSemiBold.copyWith(
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
