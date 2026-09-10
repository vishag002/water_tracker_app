import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class StreakMotivationCard extends StatelessWidget {
  const StreakMotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 84.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            // Decorative water wave.
            Positioned(
              left: 55.w,
              right: -20.w,
              bottom: -2.h,
              height: 30.h,
              child: CustomPaint(
                painter: _WaterWavePainter(
                  color: theme.colorScheme.primary.withOpacity(0.14),
                ),
              ),
            ),

            // Decorative bubbles.
            Positioned(
              right: 28.w,
              top: 10.h,
              child: _Bubble(size: 6.w, color: theme.colorScheme.primary),
            ),
            Positioned(
              right: 58.w,
              top: 18.h,
              child: _Bubble(size: 5.w, color: theme.colorScheme.primary),
            ),
            Positioned(
              right: 14.w,
              top: 34.h,
              child: _Bubble(size: 7.w, color: theme.colorScheme.primary),
            ),
            Positioned(
              right: 40.w,
              top: 43.h,
              child: _Bubble(size: 4.w, color: theme.colorScheme.primary),
            ),

            // Content.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  _buildWaterDrop(theme),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keep it going!',
                            style: AppTextStyles.captionSemiBold.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Every sip brings you closer\n'
                            'to a healthier you.',
                            style: AppTextStyles.captionXsRegular.copyWith(
                              height: 1.35,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterDrop(ThemeData theme) {
    return Container(
      width: 54.w,
      height: 54.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.water_drop,
        size: 40.sp,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _WaterWavePainter extends CustomPainter {
  const _WaterWavePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.65);

    path.cubicTo(
      size.width * 0.18,
      size.height * 0.15,
      size.width * 0.30,
      size.height * 0.95,
      size.width * 0.47,
      size.height * 0.55,
    );

    path.cubicTo(
      size.width * 0.62,
      size.height * 0.15,
      size.width * 0.76,
      size.height * 0.70,
      size.width,
      size.height * 0.18,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaterWavePainter oldDelegate) =>
      oldDelegate.color != color;
}
