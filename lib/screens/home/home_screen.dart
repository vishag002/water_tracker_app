import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';
import 'package:water_tracker_app/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      showAppBar: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Welcome", style: AppTextStyles.titleSemiBold),
                    Text("Vishag", style: AppTextStyles.headingSemiBold),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            //bottle here
            Center(
              child: SizedBox(
                width: 165.w,
                height: 400.h,
                child: Image.asset(ImageConstants.bottle, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//water painter
