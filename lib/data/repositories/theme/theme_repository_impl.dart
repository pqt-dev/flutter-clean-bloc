import 'package:flutter_clean_bloc_skeleton/domain/core/app_theme_mode.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/core/result.dart';
import '../../../domain/repositories/theme/theme_repository.dart';
import '../../datasource/theme/theme_datasource.dart';

@LazySingleton(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeDatasource datasource;

  ThemeRepositoryImpl(this.datasource);

  @override
  Future<Result<AppThemeMode>> fetch() async {
    final result = await datasource.read();
    return switch (result) {
      Success(value: final stored) => Success(_toMode(stored)),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<void>> save(AppThemeMode theme) {
    return datasource.write(theme.name);
  }

  AppThemeMode _toMode(String? stored) {
    return switch (stored) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }
}
