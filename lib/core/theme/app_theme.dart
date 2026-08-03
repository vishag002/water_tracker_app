import 'package:flutter/material.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';

class AppThemes {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.colour368AE9,
      surface: AppColors.colourFFFFFF,
      onSurface: AppColors.colour000005,
    ),
    scaffoldBackgroundColor: AppColors.colourF9FAFE,
    // add textTheme, cardTheme, appBarTheme etc.
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.colour368AE9,
      surface: AppColors.colour121A27,
      onSurface: AppColors.colourF9FAFE,
    ),
    scaffoldBackgroundColor: AppColors.colour071017,
  );

  //add later :-
  // static ThemeData get amoled => ThemeData(
  //   brightness: Brightness.dark,
  //   colorScheme: ColorScheme.dark(
  //     primary: AppColors.colour368AE9,
  //     surface: AppColors.colour000005,
  //     onSurface: AppColors.colourF9FAFE,
  //   ),
  //   scaffoldBackgroundColor: AppColors.colour000005,
  // );

  // // Stubbed — fill when ready
  // static ThemeData get ocean => dark.copyWith();
  // static ThemeData get forest => dark.copyWith();
}
