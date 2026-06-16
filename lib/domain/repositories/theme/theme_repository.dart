import 'package:flutter_clean_bloc_skeleton/domain/core/app_theme_mode.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';

abstract class ThemeRepository {
  Future<Result<void>> save(AppThemeMode theme);

  Future<Result<AppThemeMode>> fetch();
}
