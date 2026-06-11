import 'package:flutter_clean_bloc_skeleton/domain/core/app_theme_mode.dart';

abstract class ThemeRepository {
  Future<void> save(AppThemeMode theme);

  Future<AppThemeMode> fetch();
}
