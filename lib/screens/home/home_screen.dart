import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/animations/glassy_water_bottle.dart';
import 'package:water_tracker_app/animations/glassy_water_controller.dart';
import 'package:water_tracker_app/components/hexagon_widget.dart';
import 'package:water_tracker_app/components/quick_add_button_widget.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';
import 'package:water_tracker_app/l10n/app_localizations.dart';

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

  // TODO: wire this up to your real streak-tracking source.
  final int _streakDays = 3;

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
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
            // Bottle area: instead of a fixed 200x380 box, this now
            // claims whatever vertical space is actually left between
            // the header above and the goal/quick-add block below, and
            // an AspectRatio keeps the bottle's shape correct while it
            // grows or shrinks to fit. That's what removes the need to
            // scroll -- the layout adapts to the screen instead of
            // assuming a fixed height that may not exist.
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 200 / 380,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bottleWidth = constraints.maxWidth;
                      final bottleHeight = constraints.maxHeight;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Streak badge: hexagon outline with a droplet
                          // icon + day count stacked inside it, and a
                          // "Day Streak" label underneath. Sized off
                          // .w/.h/.sp (not raw px) so it scales the same
                          // way the rest of the screen does, and the
                          // whole badge is one column so the label stays
                          // centered under the hexagon at any size.
                          Positioned(
                            top: 40.h,
                            left: -36.w,
                            child: SizedBox(
                              width: 64.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 50.w,
                                    width: 50.w,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        HexagonWidget(strokeWidth: 2.w),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.water_drop,
                                              color: const Color(0xFF368AE9),
                                              size: 12.sp,
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              _streakDays.toString().padLeft(
                                                2,
                                                '0',
                                              ),
                                              style: AppTextStyles
                                                  .bodySmallRegular
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Day Streak',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: AppTextStyles.bodySmallRegular
                                        .copyWith(fontSize: 10.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: GlassyWaterBottle(
                              controller: _waterController,
                              bottleAsset: ImageConstants.bottle,
                              width: bottleWidth,
                              height: bottleHeight,
                              // Matches the Figma palette's primary blue (368AE9), with
                              // a slightly deeper shade at the bottom for a touch of
                              // depth rather than the dramatic two-tone green before.
                              topColor: const Color(0xFF4A99E8),
                              bottomColor: const Color(0xFF2B7AD1),
                              imagePadding: const EdgeInsets.fromLTRB(
                                0,
                                0.09,
                                0,
                                0.02,
                              ),
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
                              shoulderFraction: 0.3,
                              // Neck width as a fraction of body width. Measured
                              // directly off the screenshot: the neck's *inner*
                              // passage (where water should stop) is ~14% narrower
                              // than the neck's outer silhouette -- 0.58 was sized
                              // to the outer edge, so the liquid was covering most
                              // of the glass wall's thickness at the top, reading
                              // as overflow. 0.50 lines the liquid's top edge up
                              // with the inner wall instead. If a visible gap shows
                              // up at the neck now, nudge back toward 0.54-0.56.
                              neckWidthRatio: 0.56,
                              bottomRadius: 0.15,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
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
            SizedBox(height: 16.h),
            Text(localizations.homeQuickAdd, style: AppTextStyles.bodySemiBold),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickAddButtonWidget(
                  onTap: () => _waterController.addLevel(0.05),
                  imageUrl: ImageConstants.glass50ML,
                  title: '50 ml',
                ),
                QuickAddButtonWidget(
                  onTap: () => _waterController.addLevel(0.5),
                  imageUrl: ImageConstants.bottle250ML,
                  title: '+500 ml',
                ),
                QuickAddButtonWidget(
                  onTap: () => _waterController.addLevel(0.25),
                  imageUrl: ImageConstants.bottle500ML,
                  title: '+250 ml',
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

//water painter
