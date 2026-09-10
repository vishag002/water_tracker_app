import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';
import 'package:water_tracker_app/core/constants/image_const.dart';
import 'package:water_tracker_app/features/history/presentation/screens/history_screens.dart';
import 'package:water_tracker_app/screens/home/home_screen.dart';
import 'package:water_tracker_app/screens/settings/settings_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  static const _tabs = [
    _NavItem(
      label: 'Home',
      outlineIcon: ImageConstants.liquidDropOutline,
      filledIcon: ImageConstants.liquidDropFill,
    ),
    _NavItem(
      label: 'History',
      outlineIcon: ImageConstants.clockOutline,
      filledIcon: ImageConstants.clockFilled,
    ),
    _NavItem(
      label: 'Settings',
      outlineIcon: ImageConstants.settingsOutline,
      filledIcon: ImageConstants.settingsFilled,
    ),
  ];

  Widget get _currentTab {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return HistoryScreen();
      case 2:
        return SettingsScreen();
      default:
        return const SizedBox();
    }
  }

  void _updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentTab,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          child: SizedBox(height: 56.h, child: _buildNavBar()),
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_tabs.length, (i) {
          final tab = _tabs[i];
          final isSelected = _selectedIndex == i;

          return GestureDetector(
            onTap: () => _updateSelectedIndex(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: 48.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    isSelected ? tab.filledIcon : tab.outlineIcon,
                    width: 22.w,
                    height: 22.h,
                    fit: BoxFit.contain,
                    color: isSelected
                        ? AppColors.colour368AE9
                        : AppColors.textLight,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    tab.label,
                    style: AppTextStyles.captionMedium.copyWith(
                      color: isSelected
                          ? AppColors.colour368AE9
                          : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String outlineIcon;
  final String filledIcon;

  const _NavItem({
    required this.label,
    required this.outlineIcon,
    required this.filledIcon,
  });
}
