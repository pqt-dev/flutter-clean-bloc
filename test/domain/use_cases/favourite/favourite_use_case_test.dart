import 'package:flutter_clean_bloc_skeleton/domain/core/app_error.dart';
import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:flutter_clean_bloc_skeleton/domain/repositories/favourite/favourite_repository.dart';
import 'package:flutter_clean_bloc_skeleton/domain/use_cases/favourite/favourite_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'favourite_use_case_test.mocks.dart';

List<Country> unwrap(Result<List<Country>> result) {
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => fail('expected Success, got Failure: $error'),
  };
}

@GenerateNiceMocks([MockSpec<FavouriteRepository>()])
void main() {
  late MockFavouriteRepository repository;
  late FavouriteUseCase useCase;

  setUpAll(() {
    provideDummy<Result<List<Country>>>(const Success(<Country>[]));
    provideDummy<Result<void>>(const Success<void>(null));
  });

  setUp(() {
    repository = MockFavouriteRepository();
    useCase = FavouriteUseCase(repository);
  });

  Country country(String cca3, [String? name]) =>
      Country(cca3: cca3, name: CountryName(common: name ?? cca3));

  group('getFavourites', () {
    test('delegates to repository', () async {
      final stored = [country('VNM')];
      when(repository.getFavourites())
          .thenAnswer((_) async => Success(stored));

      final result = await useCase.getFavourites();

      expect(unwrap(result), equals(stored));
      verify(repository.getFavourites()).called(1);
    });
  });

  group('add', () {
    test('adds a new country and persists', () async {
      when(repository.saveFavourites(any))
          .thenAnswer((_) async => const Success<void>(null));

      final result = unwrap(await useCase.add([], country('VNM')));

      expect(result.map((c) => c.cca3), equals(['VNM']));
      verify(repository.saveFavourites(result)).called(1);
    });

    test('does not add a duplicate (same cca3) and does not persist', () async {
      final current = [country('VNM')];

      final result = unwrap(await useCase.add(current, country('VNM', 'Viet Nam')));

      expect(result, hasLength(1));
      verifyNever(repository.saveFavourites(any));
    });

    test('returns Failure and keeps result when persistence fails', () async {
      when(repository.saveFavourites(any)).thenAnswer(
        (_) async => const Failure(UnexpectedError()),
      );

      final result = await useCase.add([], country('VNM'));

      expect(result, isA<Failure>());
    });
  });

  group('remove', () {
    test('removes by cca3 and persists', () async {
      when(repository.saveFavourites(any))
          .thenAnswer((_) async => const Success<void>(null));
      final current = [country('VNM'), country('JPN')];

      final result = unwrap(await useCase.remove(current, country('VNM')));

      expect(result.map((c) => c.cca3), equals(['JPN']));
      verify(repository.saveFavourites(result)).called(1);
    });
  });

  group('contains', () {
    test('true when cca3 present', () {
      expect(useCase.contains([country('VNM')], country('VNM')), isTrue);
    });

    test('false when cca3 absent', () {
      expect(useCase.contains([country('VNM')], country('JPN')), isFalse);
    });

    test('null cca3 never matches', () {
      final a = Country(name: CountryName(common: 'A'));
      final b = Country(name: CountryName(common: 'B'));
      expect(useCase.contains([a], b), isFalse);
    });
  });
}
