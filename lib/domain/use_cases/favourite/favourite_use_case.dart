import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:flutter_clean_bloc_skeleton/domain/repositories/favourite/favourite_repository.dart';
import 'package:injectable/injectable.dart';

/// Favourite membership rules (keyed by the stable ISO [Country.cca3]) plus
/// persistence orchestration.
///
/// A country with a null `cca3` is treated as non-matchable so it can never be
/// grouped with another country by accident. Mutations persist the updated list
/// through the [FavouriteRepository].
@lazySingleton
class FavouriteUseCase {
  final FavouriteRepository _repository;

  FavouriteUseCase(this._repository);

  Future<Result<List<Country>>> getFavourites() => _repository.getFavourites();

  bool contains(List<Country> current, Country country) =>
      current.containsCountry(country);

  Future<Result<List<Country>>> add(List<Country> current, Country country) async {
    if (contains(current, country)) return Success(current);
    final updated = [...current, country];
    return _persist(updated);
  }

  Future<Result<List<Country>>> remove(List<Country> current, Country country) async {
    final updated = current.where((c) => !c.isSameAs(country)).toList();
    return _persist(updated);
  }

  Future<Result<List<Country>>> _persist(List<Country> updated) async {
    final result = await _repository.saveFavourites(updated);
    return switch (result) {
      Success() => Success(updated),
      Failure(:final error) => Failure(error),
    };
  }
}
