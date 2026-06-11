import 'package:flutter_clean_bloc_skeleton/core/constants/storage_keys.dart';
import 'package:flutter_clean_bloc_skeleton/data/repositories/favourite/favourite_repository_impl.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FavouriteRepositoryImpl repository;

  Country country(String cca3, String name) =>
      Country(cca3: cca3, name: CountryName(common: name));

  Future<SharedPreferences> prefsWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  group('getFavourites', () {
    test('returns empty list when nothing stored', () async {
      repository = FavouriteRepositoryImpl(await prefsWith({}));
      expect(await repository.getFavourites(), isEmpty);
    });

    test('returns empty list when stored data is corrupted', () async {
      repository = FavouriteRepositoryImpl(
        await prefsWith({StorageKeys.favouritesKey: 'not-json'}),
      );
      expect(await repository.getFavourites(), isEmpty);
    });
  });

  group('saveFavourites + getFavourites round-trip', () {
    test('persists and restores favourites with identity and display data',
        () async {
      repository = FavouriteRepositoryImpl(await prefsWith({}));
      final favourites = [
        country('VNM', 'Vietnam'),
        country('JPN', 'Japan'),
      ];

      await repository.saveFavourites(favourites);
      final restored = await repository.getFavourites();

      expect(restored.map((c) => c.cca3), equals(['VNM', 'JPN']));
      expect(restored.map((c) => c.name?.common), equals(['Vietnam', 'Japan']));
    });

    test('overwrites previously saved favourites', () async {
      repository = FavouriteRepositoryImpl(await prefsWith({}));

      await repository.saveFavourites([country('VNM', 'Vietnam')]);
      await repository.saveFavourites([country('JPN', 'Japan')]);
      final restored = await repository.getFavourites();

      expect(restored.map((c) => c.cca3), equals(['JPN']));
    });

    test('saving empty list clears favourites', () async {
      repository = FavouriteRepositoryImpl(await prefsWith({}));

      await repository.saveFavourites([country('VNM', 'Vietnam')]);
      await repository.saveFavourites([]);

      expect(await repository.getFavourites(), isEmpty);
    });
  });
}
