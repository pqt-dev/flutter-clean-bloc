import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/core/app_theme_mode.dart';
import '../../domain/core/result.dart';
import '../../domain/repositories/theme/theme_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeRepository _repository;

  ThemeCubit(this._repository) : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final result = await _repository.fetch();
    if (isClosed) return;
    if (result case Success(:final value)) {
      emit(_toThemeMode(value));
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    // Persist first; applying the theme in memory is non-fatal if the write
    // fails, so the selection still takes effect either way.
    await _repository.save(_toAppThemeMode(theme));
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
