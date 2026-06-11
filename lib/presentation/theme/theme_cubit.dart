import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/core/app_theme_mode.dart';
import '../../domain/repositories/theme/theme_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeRepository _repository;

  ThemeCubit(this._repository) : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final appThemeMode = await _repository.fetch();
    if (isClosed) return;
    emit(_toThemeMode(appThemeMode));
  }

  Future<void> setTheme(ThemeMode theme) async {
    final appThemeMode = _toAppThemeMode(theme);
    await _repository.save(appThemeMode);
    if (isClosed) return;
    emit(theme);
  }

  ThemeMode _toThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  AppThemeMode _toAppThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => AppThemeMode.light,
      ThemeMode.dark => AppThemeMode.dark,
      ThemeMode.system => AppThemeMode.system,
    };
  }
}
