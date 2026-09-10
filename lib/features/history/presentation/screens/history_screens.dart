import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/daily/daily_progress_card.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/daily/daily_summary_card.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/daily/daily_timeline.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/monthly/monthly_heatmap.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/monthly/monthly_overview_card.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/monthly/selected_day_history.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/weekly/weekly_goal_achievement.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/weekly/weekly_overview_card.dart';
import 'package:water_tracker_app/features/history/presentation/widgets/weekly/weekly_summary_card.dart';
import '../widgets/history_view_selector.dart';
import '../widgets/history_date_selector.dart';

enum HistoryView { daily, weekly, monthly }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryView _selectedView = HistoryView.daily;

  DateTime _selectedDate = DateTime.now();

  DateTime _selectedMonthDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      title: 'History',
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryViewSelector(
              selectedView: _selectedView,
              onViewChanged: (view) {
                setState(() {
                  _selectedView = view;
                });
              },
            ),

            SizedBox(height: 16.h),

            HistoryDateSelector(
              selectedView: _selectedView,
              selectedDate: _selectedDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),

            SizedBox(height: 20.h),

            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedView) {
      case HistoryView.daily:
        return Column(
          children: [
            const DailyProgressCard(),
            SizedBox(height: 12.h),
            const DailySummaryCard(),
            SizedBox(height: 12.h),
            const DailyTimeline(),
          ],
        );

      case HistoryView.weekly:
        return Column(
          children: [
            const WeeklyOverviewCard(),
            SizedBox(height: 12.h),
            const WeeklySummaryCard(),
            SizedBox(height: 12.h),
            const WeeklyGoalAchievement(),
          ],
        );

      case HistoryView.monthly:
        return Column(
          children: [
            MonthlyOverviewCard(),

            SizedBox(height: 12.h),

            MonthlyHeatmap(
              selectedDate: _selectedMonthDay,
              onDateSelected: (date) {
                setState(() {
                  _selectedMonthDay = date;
                });
              },
            ),

            SizedBox(height: 12.h),

            SelectedDayHistory(selectedDate: _selectedMonthDay),
          ],
        );
    }
  }
}
