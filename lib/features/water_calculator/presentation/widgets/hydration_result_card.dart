import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/water_calculator/domain/models/water_calculator_result.dart';

class HydrationResultCard extends StatelessWidget {
  const HydrationResultCard({super.key, required this.result});

  final WaterCalculatorResult? result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = result;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.06)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.water_drop_rounded,
                      color: theme.colorScheme.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Estimated Daily Hydration Target',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.captionSemiBold.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (r != null)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: r.totalWaterLiters.toStringAsFixed(2),
                            style: AppTextStyles.headingSemiBold.copyWith(
                              fontSize: 40.sp,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' L',
                            style: AppTextStyles.titleSemiBold.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' / day',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      '—',
                      style: AppTextStyles.headingSemiBold.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  if (r != null) ...[
                    SizedBox(height: 18.h),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _breakdown(
                              context,
                              label: 'Base hydration',
                              value: '${r.baseWaterLiters.toStringAsFixed(2)} L',
                            ),
                          ),
                          VerticalDivider(
                            color: theme.colorScheme.onSurface.withOpacity(0.12),
                            width: 24.w,
                            thickness: 1,
                          ),
                          Expanded(
                            child: _breakdown(
                              context,
                              label: 'Exercise adjustment',
                              value:
                                  '+${r.exerciseAdjustmentLiters.toStringAsFixed(2)} L',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 8.h),
                    Text(
                      'Enter your weight to see your estimate.',
                      style: AppTextStyles.captionRegular.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: 48.h,
              width: double.infinity,
              child: CustomPaint(
                painter: _WaterWavePainter(
                  waveColor: theme.colorScheme.primary.withOpacity(0.14),
                  bubbleColor: theme.colorScheme.primary.withOpacity(0.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breakdown(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.captionRegular.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.bodySmallSemiBold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Purely decorative wave with a couple of "bubble" rings, echoing the
/// hydration theme at the base of the result card. No data is encoded
/// in this painter — it is presentation-only.
class _WaterWavePainter extends CustomPainter {
  const _WaterWavePainter({required this.waveColor, required this.bubbleColor});

  final Color waveColor;
  final Color bubbleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()..color = waveColor;
    final path = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.1,
        size.width * 0.5,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.8,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, wavePaint);

    final bubblePaint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(Offset(size.width * 0.14, size.height * 0.72), 4, bubblePaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.6), 5, bubblePaint);
    canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.82), 3, bubblePaint);
  }

  @override
  bool shouldRepaint(covariant _WaterWavePainter oldDelegate) =>
      oldDelegate.waveColor != waveColor || oldDelegate.bubbleColor != bubbleColor;
}
