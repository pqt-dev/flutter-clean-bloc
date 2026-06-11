import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:flutter_clean_bloc_skeleton/domain/repositories/favourite/favourite_repository.dart';
import 'package:flutter_clean_bloc_skeleton/domain/use_cases/favourite/favourite_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'favourite_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FavouriteRepository>()])
void main() {
  late MockFavouriteRepository repository;
  late FavouriteUseCase useCase;

  setUp(() {
    repository = MockFavouriteRepository();
    useCase = FavouriteUseCase(repository);
  });

  Country country(String cca3, [String? name]) =>
      Country(cca3: cca3, name: CountryName(common: name ?? cca3));

  group('getFavourites', () {
    test('delegates to repository', () async {
      final stored = [country('VNM')];
      when(repository.getFavourites()).thenAnswer((_) async => stored);

      final result = await useCase.getFavourites();

      expect(result, equals(stored));
      verify(repository.getFavourites()).called(1);
    });
  });

  group('add', () {
    test('adds a new country and persists', () async {
      when(repository.saveFavourites(any)).thenAnswer((_) async {});

      final result = await useCase.add([], country('VNM'));

      expect(result.map((c) => c.cca3), equals(['VNM']));
      verify(repository.saveFavourites(result)).called(1);
    });

    test('does not add a duplicate (same cca3) and does not persist', () async {
      final current = [country('VNM')];

      final result = await useCase.add(current, country('VNM', 'Viet Nam'));

      expect(result, hasLength(1));
      verifyNever(repository.saveFavourites(any));
    });
  });

  group('remove', () {
    test('removes by cca3 and persists', () async {
      when(repository.saveFavourites(any)).thenAnswer((_) async {});
      final current = [country('VNM'), country('JPN')];

      final result = await useCase.remove(current, country('VNM'));

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
