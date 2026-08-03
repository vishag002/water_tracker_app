import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/animations/glassy_water_bottle.dart';
import 'package:water_tracker_app/animations/glassy_water_controller.dart';
import 'package:water_tracker_app/components/hexagon_widget.dart';
import 'package:water_tracker_app/components/quick_add_button_widget.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';
import 'package:water_tracker_app/l10n/app_localizations.dart';
import 'package:water_tracker_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Adjust min/max/initial to your real daily-goal units (liters, ml, etc).
  // waveAmount / easeFactor / waveSpeed are the knobs from the demo sliders
  // -- tweak these directly as you dial in the feel.
  late final GlassyWaterController _waterController = GlassyWaterController(
    minLevel: 0,
    maxLevel: 5.0,
    initialLevel: 1.1,
    waveAmount: 4.0,
    // idle amplitude — raise for more movement
    easeFactor: 0.04,
    //time taken for filling or removing
    waveSpeed: 0.01, // idle speed — raise to speed up the breathing
  );

  @override
  void dispose() {
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ScaffoldCustom(
      showAppBar: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.homeWelcome,
                      style: AppTextStyles.subtitleSemiBold,
                    ),
                    Text(
                      "Vishag",
                      style: AppTextStyles.headingSemiBold,
                      maxLines: 1,
                    ),
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
            Stack(
              children: [
                Positioned(
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    width: 50.w,
                    child: HexagonWidget(strokeWidth: 2.w),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 200.w,
                    height: 380.h,
                    child: GlassyWaterBottle(
                      controller: _waterController,
                      bottleAsset: ImageConstants.bottle,
                      width: 200.w,
                      height: 380.h,
                      // Matches the Figma palette's primary blue (368AE9), with
                      // a slightly deeper shade at the bottom for a touch of
                      // depth rather than the dramatic two-tone green before.
                      topColor: const Color(0xFF4A99E8),
                      bottomColor: const Color(0xFF2B7AD1),
                      imagePadding: const EdgeInsets.fromLTRB(0, 0.09, 0, 0.02),
                      // top: lowered from 0.18 -> 0.10. A large top inset pushes
                      // the liquid box down into the neck's straight section,
                      // where the neck is narrower than the body -- causing the
                      // overflow you saw, regardless of shoulderFraction.
                      wallInset: const EdgeInsets.fromLTRB(
                        0.16,
                        0.10,
                        0.17,
                        0.05,
                      ),
                      // A short, sharp taper -- most bottles widen out quickly.
                      shoulderFraction: 0.2,
                      // The actual fix: neck width as a fraction of body width.
                      // 0.68 means the neck is most of the body's width,
                      // dramatically narrow taper -- start here and adjust:
                      // raise toward 0.85 if you still see a small overflow,
                      // lower toward 0.55 if there's a visible gap instead.
                      neckWidthRatio: 0.58,
                      bottomRadius: 0.12,
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.homeGoalLabel(2),
                  style: AppTextStyles.bodySmallRegular,
                ),
                SizedBox(width: 5.w),
                Icon(Icons.edit_outlined, size: 12.sp),
              ],
            ),
            SizedBox(height: 25.h),
            Text(localizations.homeQuickAdd, style: AppTextStyles.bodySemiBold),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickAddButtonWidget(
                  onTap: () => _waterController.addLevel(0.05),
                  imageUrl: ImageConstants.waterGlassIcon,
                  title: '50 ml',
                ),
                QuickAddButtonWidget(
                  onTap: () => _waterController.addLevel(0.5),
                  imageUrl: ImageConstants.waterBottleIcon,
                  title: '+500 ml',
                ),
                QuickAddButtonWidget(
                  onTap: () => _waterController.addLevel(0.25),
                  imageUrl: ImageConstants.waterBottleIcon2,
                  title: '+250 ml',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//water painter
