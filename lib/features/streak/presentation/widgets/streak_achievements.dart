import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/streak/presentation/providers/streak_provider.dart';

/// A single unlockable milestone. Purely a presentation-layer constant —
/// the underlying number being compared against (`longestStreak`) still
/// comes entirely from [streakProvider]/`StreakCalculator`.
class _Milestone {
  const _Milestone(this.days, this.label);

  final int days;
  final String label;
}

const List<_Milestone> _milestones = [
  _Milestone(15, 'Getting Started'),
  _Milestone(30, 'On Track'),
  _Milestone(50, 'Dedicated'),
  _Milestone(100, 'Disciplined'),
  _Milestone(150, 'Committed'),
  _Milestone(200, 'Unstoppable'),
  _Milestone(300, 'Legendary'),
];

/// Standalone "Streak Achievements" card: seven fixed milestones (15,
/// 30, 50, 100, 150, 200, 300 days), each unlocked purely by comparing
/// against the existing [streakProvider]'s `longestStreak` — never
/// `currentStreak`, goal days, entry counts, or total intake.
///
/// No new provider, model, or database access is introduced here; this
/// widget only maps a number that already exists (`longestStreak`) onto
/// a locked/unlocked visual. Nothing is persisted — every rebuild
/// re-evaluates `longestStreak >= milestone` from scratch, so newly
/// crossed milestones unlock automatically the moment `streakProvider`
/// recalculates (e.g. after a Quick Add from Home).
///
/// Standalone by design — not wired into `StreakCalendarScreen` here;
/// add `const StreakAchievementsWidget()` wherever it should sit
/// alongside `CurrentStreakCard`/`StreakStatsCard`/`StreakCalendarCard`.
class StreakAchievementsWidget extends ConsumerWidget {
  const StreakAchievementsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Same "current month" key CurrentStreakCard/StreakStatsCard use —
    // calendarMonth only affects the calendar-scoped fields on
    // StreakResult, never currentStreak/longestStreak (see
    // StreakCalculator's contract), so this is just piggy-backing on
    // the same cached provider instance rather than creating a second.
    final resultAsync = ref.watch(streakProvider(DateTime.now()));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          resultAsync.when(
            data: (result) => _buildHeader(theme, result.longestStreak),
            loading: () => _buildHeader(theme, null),
            error: (error, stackTrace) => _buildHeader(theme, null),
          ),

          SizedBox(height: 16.h),

          resultAsync.when(
            data: (result) => _buildAchievementsRow(theme, result.longestStreak),
            loading: () => SizedBox(
              height: 96.h,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, stackTrace) => SizedBox(
              height: 96.h,
              child: Center(
                child: Text(
                  'Couldn\'t load achievements.',
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, int? longestStreak) {
    final unlockedCount = longestStreak == null
        ? null
        : _milestones.where((m) => longestStreak >= m.days).length;

    return Row(
      children: [
        Text(
          'Streak Achievements',
          style: AppTextStyles.bodySmallSemiBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        if (unlockedCount != null)
          Text(
            '$unlockedCount of ${_milestones.length} unlocked',
            style: AppTextStyles.captionMedium.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildAchievementsRow(ThemeData theme, int longestStreak) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _milestones.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final milestone = _milestones[index];
          final unlocked = longestStreak >= milestone.days;

          return _AchievementBadge(milestone: milestone, unlocked: unlocked);
        },
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.milestone, required this.unlocked});

  final _Milestone milestone;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final badgeColor = unlocked
        ? theme.colorScheme.primary.withOpacity(0.1)
        : theme.colorScheme.onSurface.withOpacity(0.05);
    final borderColor = unlocked
        ? theme.colorScheme.primary.withOpacity(0.25)
        : theme.colorScheme.outlineVariant;
    final iconColor = unlocked
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(0.35);
    final numberColor = unlocked
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withOpacity(0.4);
    final labelColor = theme.colorScheme.onSurface.withOpacity(
      unlocked ? 0.6 : 0.35,
    );

    return SizedBox(
      width: 66.w,
      child: Column(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Icon(
              unlocked ? Icons.water_drop_outlined : Icons.lock_outline,
              size: 19.sp,
              color: iconColor,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            '${milestone.days}',
            style: AppTextStyles.captionSemiBold.copyWith(
              color: numberColor,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            milestone.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionXsRegular.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }
}
