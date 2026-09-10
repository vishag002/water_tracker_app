import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/features/streak/presentation/widgets/current_streak_card.dart';
import 'package:water_tracker_app/features/streak/presentation/widgets/streak_calendar_card.dart';
import 'package:water_tracker_app/features/streak/presentation/widgets/streak_motivation_card.dart';
import 'package:water_tracker_app/features/streak/presentation/widgets/streak_stats_card.dart';

class StreakCalendarScreen extends StatelessWidget {
  const StreakCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurrentStreakCard(),
            SizedBox(height: 5.h),
            StreakCalendarCard(),
            SizedBox(height: 5.h),
            StreakStatsCard(),
            SizedBox(height: 5.h),
            StreakMotivationCard(),
          ],
        ),
      ),
    );
  }
}
