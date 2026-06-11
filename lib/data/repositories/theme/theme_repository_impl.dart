
import 'package:flutter_clean_bloc_skeleton/domain/core/app_theme_mode.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../domain/repositories/theme/theme_repository.dart';

final _logger = Logger();

@LazySingleton(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPreferences preferences;

  ThemeRepositoryImpl(this.preferences);

  @override
  Future<AppThemeMode> fetch() async {
    return switch (preferences.getString(StorageKeys.themeModeKey)) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }

  @override
  Future<void> save(AppThemeMode theme) async {
    try {
      await preferences.setString(StorageKeys.themeModeKey, theme.name);
    } catch (e, stackTrace) {
      // SharedPreferences write failure is non-fatal; theme stays in memory.
      _logger.e('Failed to persist theme', error: e, stackTrace: stackTrace);
    }
  }
}
