import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker_app/core/theme/app_theme.dart';
import 'package:water_tracker_app/enum/theme_type_enum.dart';

const _themeKey = 'selected_theme';

class ThemeNotifier extends Notifier<ThemeType> {
  @override
  ThemeType build() {
    _loadSavedTheme();
    return ThemeType.system;
  }

  void changeTheme(ThemeType type) {
    state = type;
    _saveTheme(type);
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);
    if (saved != null) {
      state = ThemeType.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ThemeType.system,
      );
    }
  }

  Future<void> _saveTheme(ThemeType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, type.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeType>(
  ThemeNotifier.new,
);

// Derived provider — gives you ThemeData directly
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeType = ref.watch(themeProvider);

  switch (themeType) {
    case ThemeType.light:
      return AppThemes.light;
    case ThemeType.dark:
      return AppThemes.dark;
    // case ThemeType.amoled:
    //   return AppThemes.amoled;
    // case ThemeType.ocean:
    //   return AppThemes.ocean;
    // case ThemeType.forest:
    //   return AppThemes.forest;
    case ThemeType.system:
    default:
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark ? AppThemes.dark : AppThemes.light;
  }
});
