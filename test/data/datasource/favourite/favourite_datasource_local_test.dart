import 'package:flutter_clean_bloc_skeleton/core/constants/storage_keys.dart';
import 'package:flutter_clean_bloc_skeleton/data/datasource/favourite/favourite_datasource_local.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_model.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_name_model.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FavouriteDatasourceLocal datasource;
  final logger = Logger(level: Level.off);

  CountryModel model(String cca3, String name) =>
      CountryModel(cca3: cca3, name: CountryNameModel(common: name));

  Future<SharedPreferences> prefsWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  List<CountryModel> unwrap(Result<List<CountryModel>> result) {
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => fail('expected Success, got Failure: $error'),
    };
  }

  group('read', () {
    test('returns Success with empty list when nothing stored', () async {
      datasource = FavouriteDatasourceLocal(await prefsWith({}), logger);
      expect(unwrap(await datasource.read()), isEmpty);
    });

    test('returns Failure(ParsingError) when stored data is corrupted', () async {
      datasource = FavouriteDatasourceLocal(
        await prefsWith({StorageKeys.favouritesKey: 'not-json'}),
        logger,
      );
      final result = await datasource.read();
      expect(result, isA<Failure>());
      expect((result as Failure).error, isA<ParsingError>());
    });
  });

  group('write + read round-trip', () {
    test('persists and restores models with identity and display data', () async {
      datasource = FavouriteDatasourceLocal(await prefsWith({}), logger);
      final favourites = [
        model('VNM', 'Vietnam'),
        model('JPN', 'Japan'),
      ];

      expect(await datasource.write(favourites), isA<Success>());
      final restored = unwrap(await datasource.read());

      expect(restored.map((c) => c.cca3), equals(['VNM', 'JPN']));
      expect(restored.map((c) => c.name?.common), equals(['Vietnam', 'Japan']));
    });

    test('overwrites previously saved models', () async {
      datasource = FavouriteDatasourceLocal(await prefsWith({}), logger);

      await datasource.write([model('VNM', 'Vietnam')]);
      await datasource.write([model('JPN', 'Japan')]);
      final restored = unwrap(await datasource.read());

      expect(restored.map((c) => c.cca3), equals(['JPN']));
    });

    test('writing empty list clears favourites', () async {
      datasource = FavouriteDatasourceLocal(await prefsWith({}), logger);

      await datasource.write([model('VNM', 'Vietnam')]);
      await datasource.write([]);

      expect(unwrap(await datasource.read()), isEmpty);
    });
  });
}
