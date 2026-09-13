import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

/// Purely presentational — all data comes from the caller
/// (WeeklyOverviewCard), which is the only widget in this feature that
/// talks to Riverpod for the bar chart.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.dailyIntakeLiters,
    required this.goalLiters,
    required this.dayLabels,
  });

  /// Exactly 7 values, Monday first, Sunday last.
  final List<double> dailyIntakeLiters;

  /// Exactly 7 short labels (e.g. 'Mon'..'Sun'), same order as
  /// [dailyIntakeLiters].
  final List<String> dayLabels;

  final double goalLiters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedTextStyle = AppTextStyles.captionXsMedium.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
    );

    final highestBar = dailyIntakeLiters.isEmpty
        ? 0.0
        : dailyIntakeLiters.reduce((a, b) => a > b ? a : b);
    // Keep the goal line comfortably inside the chart even on weeks
    // where every day is under goal, and make room above it when a day
    // exceeds the goal.
    final maxY = [highestBar, goalLiters, 1.0].reduce((a, b) => a > b ? a : b) +
        0.5;

    return SizedBox(
      height: 220.h,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: maxY,
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
                y: goalLiters,
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

                  if (index < 0 || index >= dayLabels.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(dayLabels[index], style: mutedTextStyle),
                  );
                },
              ),
            ),
          ),

          barGroups: List.generate(dailyIntakeLiters.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: dailyIntakeLiters[index],
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
