import 'package:flutter/material.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';

class AppThemes {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.colour368AE9,
      surface: AppColors.colourF9FAFE,
      onSurface: AppColors.colour000005,
    ),
    scaffoldBackgroundColor: AppColors.colourF9FAFE,
    // add textTheme, cardTheme, appBarTheme etc.
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.colour368AE9,
      surface: AppColors.colour233043,
      onSurface: AppColors.colourF9FAFE,
    ),
    scaffoldBackgroundColor: AppColors.colour233043,
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
