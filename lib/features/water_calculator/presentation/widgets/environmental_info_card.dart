import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/water_calculator/domain/constants/water_calculator_constants.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/section_header.dart';

/// Displays fixed environmental defaults. These are NOT live weather
/// data and currently do not affect the calculation result — see the
/// architecture note on [WaterCalculatorConstants].
class EnvironmentalInfoCard extends StatelessWidget {
  const EnvironmentalInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.thermostat_outlined,
            title: 'Environmental conditions',
            subtitle: 'Using default estimates (not live weather data)',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _EnvValue(
                  label: 'Temperature',
                  value:
                      '${WaterCalculatorConstants.defaultTemperatureCelsius.toStringAsFixed(0)}°C',
                ),
              ),
              Expanded(
                child: _EnvValue(
                  label: 'Humidity',
                  value:
                      '${WaterCalculatorConstants.defaultHumidityPercent.toStringAsFixed(0)}%',
                ),
              ),
              Expanded(
                child: _EnvValue(
                  label: 'Altitude',
                  value:
                      '${WaterCalculatorConstants.defaultAltitudeMeters.toStringAsFixed(0)} m',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EnvValue extends StatelessWidget {
  const _EnvValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodySmallSemiBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.captionXsRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
