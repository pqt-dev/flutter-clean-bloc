import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';

/// Abstract interface for the theme preference data source.
///
/// Owns persistence concerns and speaks in the raw stored string; the
/// repository maps that to the domain [AppThemeMode].
abstract class ThemeDatasource {
  Future<Result<String?>> read();

  Future<Result<void>> write(String value);
}
