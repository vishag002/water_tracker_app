import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';

class WaterCalculatorSreen extends StatelessWidget {
  const WaterCalculatorSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      title: 'Water Calculator',
      centerTitle: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            //
            Container(
              width: 390.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _generalCard(context),
                  _generalCard(context),
                  _generalCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _generalCard(BuildContext context) {
  return SizedBox(
    height: 72.h,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            height: 30.h,
            width: 30.w,
            decoration: BoxDecoration(
              color: AppColors.colour368AE9.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.ac_unit_rounded, color: AppColors.colour368AE9),
          ),
          SizedBox(width: 5.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "weight",
                style: AppTextStyles.bodySmallSemiBold.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                "Your body weight",
                style: AppTextStyles.captionRegular.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Spacer(),
          trailingWidget(),
        ],
      ),
    ),
  );
}

Widget trailingWidget() {
  return Container();
}
