import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  // Demo values for the UI phase.
  static const List<double> _weeklyIntake = [1.8, 2.1, 1.4, 2.0, 2.3, 1.7, 2.0];

  static const double _dailyGoal = 2.0;

  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedTextStyle = AppTextStyles.captionXsMedium.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
    );

    return SizedBox(
      height: 220.h,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 3,
          alignment: BarChartAlignment.spaceAround,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: theme.colorScheme.outlineVariant,
                strokeWidth: 0.7,
              );
            },
          ),

          borderData: FlBorderData(show: false),

          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: _dailyGoal,
                color: theme.colorScheme.primary,
                strokeWidth: 1.5,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(left: 4.w),
                  style: AppTextStyles.captionXsMedium.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  labelResolver: (_) => 'Goal',
                ),
              ),
            ],
          ),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32.w,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}L', style: mutedTextStyle);
                },
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.h,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= _days.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(_days[index], style: mutedTextStyle),
                  );
                },
              ),
            ),
          ),

          barGroups: List.generate(_weeklyIntake.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: _weeklyIntake[index],
                  width: 18.w,
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.r),
                    topRight: Radius.circular(5.r),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
