import 'package:flutter_clean_bloc_skeleton/data/datasource/favourite/favourite_datasource.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_model.dart';
import 'package:flutter_clean_bloc_skeleton/data/models/country/country_name_model.dart';
import 'package:flutter_clean_bloc_skeleton/data/repositories/favourite/favourite_repository_impl.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'favourite_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FavouriteDatasource>()])
void main() {
  late MockFavouriteDatasource datasource;
  late FavouriteRepositoryImpl repository;

  setUpAll(() {
    provideDummy<Result<List<CountryModel>>>(const Success(<CountryModel>[]));
    provideDummy<Result<void>>(const Success<void>(null));
  });

  setUp(() {
    datasource = MockFavouriteDatasource();
    repository = FavouriteRepositoryImpl(datasource);
  });

  CountryModel model(String cca3, String name) =>
      CountryModel(cca3: cca3, name: CountryNameModel(common: name));

  group('getFavourites', () {
    test('maps datasource models to entities on Success', () async {
      when(datasource.read()).thenAnswer(
        (_) async => Success([model('VNM', 'Vietnam')]),
      );

      final result = await repository.getFavourites();

      final countries = switch (result) {
        Success(:final value) => value,
        Failure(:final error) => fail('expected Success, got $error'),
      };
      expect(countries, isA<List<Country>>());
      expect(countries.single.cca3, 'VNM');
      expect(countries.single.name?.common, 'Vietnam');
    });

    test('propagates Failure from datasource', () async {
      when(datasource.read()).thenAnswer(
        (_) async => const Failure(ParsingError()),
      );

      final result = await repository.getFavourites();

      expect(result, isA<Failure>());
      expect((result as Failure).error, isA<ParsingError>());
    });
  });

  group('saveFavourites', () {
    test('maps entities to models and delegates to datasource', () async {
      when(datasource.write(any))
          .thenAnswer((_) async => const Success<void>(null));

      final result = await repository.saveFavourites([
        Country(cca3: 'VNM', name: CountryName(common: 'Vietnam')),
      ]);

      expect(result, isA<Success>());
      final captured =
          verify(datasource.write(captureAny)).captured.single as List<CountryModel>;
      expect(captured.single.cca3, 'VNM');
    });

    test('propagates Failure from datasource', () async {
      when(datasource.write(any))
          .thenAnswer((_) async => const Failure(UnexpectedError()));

      final result = await repository.saveFavourites([]);

      expect(result, isA<Failure>());
    });
  });
}
