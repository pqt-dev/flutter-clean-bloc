import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';

extension ThemeX on BuildContext {
  Color color(Palette key) {
    final theme = Theme.of(this).extension<AppThemeExtension>();
    return theme?.getColor(key) ?? Colors.transparent;
  }

  /// Whether the currently applied theme is dark.
  ///
  /// Reads the active [ThemeData.brightness] (which reflects the app's selected
  /// [ThemeMode]), not the OS-level brightness, so it stays correct when the
  /// user overrides the system theme.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
