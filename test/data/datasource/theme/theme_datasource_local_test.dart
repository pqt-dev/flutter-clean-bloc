import 'package:flutter_clean_bloc_skeleton/core/constants/storage_keys.dart';
import 'package:flutter_clean_bloc_skeleton/data/datasource/theme/theme_datasource_local.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ThemeDatasourceLocal datasource;
  final logger = Logger(level: Level.off);

  Future<SharedPreferences> prefsWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  String? unwrap(Result<String?> result) {
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => fail('expected Success, got Failure: $error'),
    };
  }

  group('read', () {
    test('returns the stored raw value', () async {
      datasource = ThemeDatasourceLocal(
        await prefsWith({StorageKeys.themeModeKey: 'dark'}),
        logger,
      );
      expect(unwrap(await datasource.read()), equals('dark'));
    });

    test('returns null when nothing stored', () async {
      datasource = ThemeDatasourceLocal(await prefsWith({}), logger);
      expect(unwrap(await datasource.read()), isNull);
    });
  });

  group('write', () {
    test('persists the raw value and round-trips', () async {
      datasource = ThemeDatasourceLocal(await prefsWith({}), logger);

      expect(await datasource.write('light'), isA<Success>());
      expect(unwrap(await datasource.read()), equals('light'));
    });

    test('overwrites previously stored value', () async {
      datasource = ThemeDatasourceLocal(
        await prefsWith({StorageKeys.themeModeKey: 'light'}),
        logger,
      );

      await datasource.write('dark');

      expect(unwrap(await datasource.read()), equals('dark'));
    });
  });
}
