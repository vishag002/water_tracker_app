import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/features/home/presentation/animations/glassy_water_bottle.dart';
import 'package:water_tracker_app/features/home/presentation/animations/glassy_water_controller.dart';
import 'package:water_tracker_app/features/home/presentation/widgets/hexagon_widget.dart';
import 'package:water_tracker_app/features/home/presentation/widgets/quick_add_button_widget.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';
import 'package:water_tracker_app/core/services/general_service.dart';
import 'package:water_tracker_app/features/streak/presentation/providers/streak_provider.dart';
import 'package:water_tracker_app/l10n/app_localizations.dart';
import 'package:water_tracker_app/features/home/presentation/providers/user_name_provider.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_entry_provider.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_goal_provider.dart';
import 'package:water_tracker_app/features/home/domain/daily_intake_calculator.dart';
import 'package:water_tracker_app/features/home/presentation/widgets/water_goal_edit_dialog.dart';
import 'package:water_tracker_app/features/home/presentation/widgets/onboarding_name_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // A sensible default before real data loads — matches the default 2L
  // goal, so there's no visible jump once the real goal arrives. maxLevel
  // and initialLevel get corrected in initState once the goal/entries load
  // (initialLevel stays 0 here since it's only a pre-data placeholder).
  late final GlassyWaterController _waterController = GlassyWaterController(
    minLevel: 0,
    maxLevel: 2.0,
    initialLevel: 0,
    waveAmount: 4.0,
    // idle amplitude — raise for more movement
    easeFactor: 0.04,
    //time taken for filling or removing
    waveSpeed: 0.01, // idle speed — raise to speed up the breathing
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userRepo = ref.read(userRepositoryProvider);
      final hasUser = await userRepo.hasUser();
      if (!hasUser && mounted) {
        await OnboardingNameDialog.show(context);
      }

      final user = await userRepo.getCurrentUser();
      if (user == null || !mounted) return;

      final goalRepo = ref.read(waterGoalRepositoryProvider);
      var existingGoal = await goalRepo.getWaterGoal(user.id);
      if (existingGoal == null) {
        await goalRepo.createWaterGoal(userId: user.id, goal: 2.0, unit: 'L');
        existingGoal = await goalRepo.getWaterGoal(user.id);
      }
      if (!mounted) return;

      // "Full" now means "goal reached" — set this before setLevel below so
      // the very first fill fraction is computed against the right scale.
      _waterController.updateMaxLevel((existingGoal?.goal ?? 2.0).toDouble());

      // One-time restore: pull today's real total from Drift and sync the
      // bottle to it. ref.listen in build() only reacts to changes *after*
      // this point — it can't replay a value that already existed before
      // this widget was watching, so this initial read has to happen here.
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final entries = await ref.read(waterEntriesForDayProvider(today).future);
      if (!mounted) return;

      final totalMl = DailyIntakeCalculator.totalMl(
        entries.map((e) => e.amount).toList(),
      );
      _waterController.setLevel(totalMl / 1000, pulse: false);
    });
  }

  @override
  void dispose() {
    _waterController.dispose();
    super.dispose();
  }

  // _addWaterEntry no longer touches the controller directly — it only
  // persists. The bottle updates itself reactively once the write lands
  // and todaysWaterIntakeMlProvider emits the new total.
  Future<void> _addWaterEntry({required int amountMl}) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;

    await ref
        .read(waterEntryRepositoryProvider)
        .addEntry(userId: userId, amount: amountMl, unit: 'ml');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);
    final goalAsync = ref.watch(currentWaterGoalProvider);
    final todaysIntakeMl = ref.watch(todaysWaterIntakeMlProvider);
    final todaysIntakeLiters = todaysIntakeMl / 1000;

    // Same streakProvider the Streak screen's CurrentStreakCard watches
    // (real water_entries + goal, run through StreakCalculator). Falls
    // back to 0 while loading, on error, or when there's no streak yet.
    final streakAsync = ref.watch(streakProvider(DateTime.now()));
    final streakDays = streakAsync.value?.currentStreak ?? 0;

    // Reacts to every change from here on — new entries, deletions, etc.
    // The initial value is already handled above in initState.
    ref.listen<int>(todaysWaterIntakeMlProvider, (previous, next) {
      _waterController.setLevel(next / 1000, pulse: previous != null);
    });

    // Keeps the bottle's "full" mark synced if the goal is edited later —
    // e.g. via the tap-to-edit goal row below.
    ref.listen(currentWaterGoalProvider, (previous, next) {
      final goal = next.value;
      if (goal != null) {
        _waterController.updateMaxLevel(goal.goal.toDouble());
      }
    });

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
                      userAsync.value?.name ?? '',
                      style: AppTextStyles.headingSemiBold,
                      maxLines: 1,
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     final now = DateTime.now();
                //     final testTime = now.add(const Duration(minutes: 1));

                //     await NotificationService.instance.scheduleDailyReminder(
                //       id: 999,
                //       hour: testTime.hour,
                //       minute: testTime.minute,
                //     );
                //   },
                //   child: const Text('Test Notification'),
                // ),
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
                                              streakDays.toString().padLeft(
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
                          // Today's water status, overlaid on top of the
                          // bottle/liquid. Driven by todaysWaterIntakeMlProvider
                          // and currentWaterGoalProvider. Positioned as a
                          // fraction of bottleHeight (not a fixed px offset)
                          // so it stays roughly centered on the liquid
                          // regardless of how the bottle scales.
                          Positioned(
                            top: bottleHeight * 0.52,
                            left: 0,
                            right: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${todaysIntakeLiters.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')}L',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.headingSemiBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'of ${GeneralService.formatGoal(goalAsync.value?.goal ?? 2.0)}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmallRegular
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                final userId = userAsync.value?.id;
                if (userId == null) return;
                WaterGoalEditDialog.show(
                  context,
                  userId: userId,
                  currentGoal: goalAsync.value?.goal ?? 2.0,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.homeGoalLabel(goalAsync.value?.goal ?? 2.0),
                    style: AppTextStyles.bodySmallRegular,
                  ),
                  SizedBox(width: 5.w),
                  Icon(Icons.edit_outlined, size: 12.sp),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(localizations.homeQuickAdd, style: AppTextStyles.bodySemiBold),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickAddButtonWidget(
                  onTap: () => _addWaterEntry(amountMl: 50),
                  imageUrl: ImageConstants.glass50ML,
                  title: '+50 ml',
                ),
                QuickAddButtonWidget(
                  onTap: () => _addWaterEntry(amountMl: 250),
                  imageUrl: ImageConstants.bottle250ML,
                  title: '+250 ml',
                ),
                QuickAddButtonWidget(
                  onTap: () => _addWaterEntry(amountMl: 500),
                  imageUrl: ImageConstants.bottle500ML,
                  title: '+500 ml',
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
