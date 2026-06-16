import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../domain/core/app_error.dart';
import '../../../domain/core/result.dart';
import 'theme_datasource.dart';

@LazySingleton(as: ThemeDatasource)
class ThemeDatasourceLocal implements ThemeDatasource {
  final SharedPreferences preferences;
  final Logger logger;

  ThemeDatasourceLocal(this.preferences, this.logger);

  @override
  Future<Result<String?>> read() async {
    return Success(preferences.getString(StorageKeys.themeModeKey));
  }

  @override
  Future<Result<void>> write(String value) async {
    try {
      await preferences.setString(StorageKeys.themeModeKey, value);
      return const Success<void>(null);
    } catch (e, stackTrace) {
      logger.e('Failed to persist theme', error: e, stackTrace: stackTrace);
      return Failure(UnexpectedError(cause: e, stackTrace: stackTrace));
    }
  }
}
