import 'package:flutter/material.dart';
import 'package:flutter_clean_bloc_skeleton/presentation/theme/app_colors.dart';
import 'package:flutter_clean_bloc_skeleton/presentation/theme/app_theme_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme =
      ThemeData.light(
        useMaterial3: false,
      ).copyWith(
        extensions: [
          _lightThemeExtension,
        ],
        textTheme: GoogleFonts.ubuntuTextTheme(),
      );

  static final _lightThemeExtension = AppThemeExtension(
    colors: {
      Palette.primaryTextColor: AppColors.black,
      Palette.primaryBackground: AppColors.white,
      Palette.secondaryBackground: AppColors.white70,
      Palette.errorColor: AppColors.crimsonRed,
      Palette.primaryTextFieldBackground: AppColors.white12,
      Palette.primaryButtonBackground: AppColors.black87,
      Palette.primaryButtonText: AppColors.white,
    },
  );

  static final darkTheme =
      ThemeData.dark(
        useMaterial3: false,
      ).copyWith(
        extensions: [
          _darkThemeExtension,
        ],
        textTheme: GoogleFonts.ubuntuTextTheme(),
      );

  static final _darkThemeExtension = AppThemeExtension(
    colors: {
      Palette.primaryTextColor: AppColors.white,
      Palette.primaryBackground: AppColors.black,
      Palette.secondaryBackground: AppColors.black54,
      Palette.errorColor: AppColors.crimsonRed,
      Palette.primaryTextFieldBackground: AppColors.black12,
      Palette.primaryButtonBackground: AppColors.white70,
      Palette.primaryButtonText: AppColors.black87,
    },
  );
}
