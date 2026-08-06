import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/components/settings_card.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';

enum ReminderInterval { thirtyMin, oneHour, twoHours, custom }

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isReminderOn = false;
  bool isSmartPauseOn = true;
  ReminderInterval selectedInterval = ReminderInterval.thirtyMin;

  void _onIntervalSelected(ReminderInterval interval) {
    if (interval == ReminderInterval.custom) {
      _showCustomIntervalSheet();
      return;
    }
    setState(() {
      selectedInterval = interval;
    });
  }

  void _showCustomIntervalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        // TODO: build custom interval picker UI
        return SizedBox(
          height: 300.h,
          child: Center(child: Text('Custom interval picker')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      title: 'Reminders',
      centerTitle: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            SettingsCard(
              height: 55.h,
              leadingAsset: ImageConstants.notificationBEll,
              leading: Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.colour368AE9.withValues(alpha: .1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Image.asset(
                    ImageConstants.notificationBEll,
                    color: AppColors.colour368AE9,
                  ),
                ),
              ),
              title: 'Reminders',
              subtitle: 'Get notified to drink water',
              onTap: () {
                //
              },
              trailing: Switch(
                value: isReminderOn,
                onChanged: (value) {
                  setState(() {
                    isReminderOn = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15.h),
            //time interval card
            TimeIntervalCard(
              selectedInterval: selectedInterval,
              onIntervalSelected: _onIntervalSelected,
            ),
            SizedBox(height: 15.h),

            //start time and end time card
            //start time
            startTimeAndEndTimeCard(
              context,
              'Start Time',
              'When should reminders start?',
              '08:00 AM',
            ),
            SizedBox(height: 5.h),
            //end time
            startTimeAndEndTimeCard(
              context,
              'End Time',
              'When should reminders stop?',
              '10:00 PM',
            ),
            SizedBox(height: 15.h),

            //summary card
            SizedBox(height: 15.h),

            //motivation card
            TipCard(
              title: "We've got your back!",
              message:
                  "You'll only get reminded if you haven't logged enough water.",
            ),
            SizedBox(height: 15.h),

            //next reminder card
            NextReminderCard(
              nextReminderTime: '10:00 AM',
              upcomingTimes: const [
                '10:00 AM',
                '10:30 AM',
                '11:00 AM',
                '11:30 AM',
              ],
              activeIndex: 0,
            ),
            SizedBox(height: 20.h),

            //no button will save automatically

            // SizedBox(
            //   width: double.infinity,
            //   height: 52.h,
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       //
            //     },
            //     icon: Icon(Icons.check_circle, size: 18.sp),
            //     label: Text('Save Changes'),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.colour368AE9,
            //       foregroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(15.r),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

//time interval card
class TimeIntervalCard extends StatelessWidget {
  final ReminderInterval selectedInterval;
  final ValueChanged<ReminderInterval> onIntervalSelected;

  const TimeIntervalCard({
    super.key,
    required this.selectedInterval,
    required this.onIntervalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminder Interval',
              style: AppTextStyles.bodySmallSemiBold.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'Choose how often you want to be reminded',
              style: AppTextStyles.captionRegular.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: intervalOptionWidget(
                    context,
                    title: '30 min',
                    icon: Icons.access_time,
                    isSelected: selectedInterval == ReminderInterval.thirtyMin,
                    onTap: () => onIntervalSelected(ReminderInterval.thirtyMin),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: intervalOptionWidget(
                    context,
                    title: '1 hour',
                    icon: Icons.access_time,
                    isSelected: selectedInterval == ReminderInterval.oneHour,
                    onTap: () => onIntervalSelected(ReminderInterval.oneHour),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: intervalOptionWidget(
                    context,
                    title: '2 hours',
                    icon: Icons.access_time,
                    isSelected: selectedInterval == ReminderInterval.twoHours,
                    onTap: () => onIntervalSelected(ReminderInterval.twoHours),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: intervalOptionWidget(
                    context,
                    title: 'Custom',
                    icon: Icons.tune,
                    isSelected: selectedInterval == ReminderInterval.custom,
                    onTap: () => onIntervalSelected(ReminderInterval.custom),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //interval option widget
  Widget intervalOptionWidget(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final selectedColor = AppColors.colour368AE9;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isSelected
                    ? selectedColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: 5.h),
              Text(
                title,
                style: AppTextStyles.captionRegular.copyWith(
                  color: isSelected
                      ? selectedColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//start time and end time card
Widget startTimeAndEndTimeCard(BuildContext context, title, subtitle, time) {
  return Container(
    height: 70.h,
    width: 390.w,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        width: 1.w,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.captionRegular.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                subtitle,
                style: AppTextStyles.captionRegular.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColors.colour368AE9.withValues(alpha: .1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.colour368AE9),
                  SizedBox(width: 3.w),
                  Text(
                    time,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.colour368AE9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.chevron_right,
            size: 22.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
    ),
  );
}

//tip / motivation card
class TipCard extends StatelessWidget {
  final String title;
  final String message;

  const TipCard({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.colour368AE9;
    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36.h,
              width: 36.w,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 18.sp,
                color: accentColor,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmallSemiBold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    message,
                    style: AppTextStyles.captionRegular.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
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
}

//next reminder card
class NextReminderCard extends StatelessWidget {
  final String nextReminderTime;
  final List<String> upcomingTimes;
  final int activeIndex;

  const NextReminderCard({
    super.key,
    required this.nextReminderTime,
    required this.upcomingTimes,
    this.activeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.colour368AE9;
    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Reminder',
                        style: AppTextStyles.bodySmallSemiBold.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'You will be reminded at',
                        style: AppTextStyles.captionRegular.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 14.sp,
                        color: accentColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        nextReminderTime,
                        style: AppTextStyles.captionRegular.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: List.generate(upcomingTimes.length, (index) {
                final isActive = index == activeIndex;
                return Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 28.h,
                            width: 28.w,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? accentColor
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications,
                              size: 14.sp,
                              color: isActive
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            upcomingTimes[index],
                            style: AppTextStyles.captionRegular.copyWith(
                              fontSize: 9.sp,
                              color: isActive
                                  ? accentColor
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      if (index != upcomingTimes.length - 1)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 18.h),
                            child: CustomPaint(
                              size: Size(double.infinity, 1.h),
                              painter: _DashedLinePainter(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
