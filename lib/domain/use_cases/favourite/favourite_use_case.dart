import 'package:flutter_clean_bloc/domain/entities/country.dart';
import 'package:flutter_clean_bloc/domain/repositories/favourite/favourite_repository.dart';
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

  Future<List<Country>> getFavourites() => _repository.getFavourites();

  bool _isSame(Country a, Country b) => a.cca3 != null && a.cca3 == b.cca3;

  bool contains(List<Country> current, Country country) =>
      current.any((c) => _isSame(c, country));

  Future<List<Country>> add(List<Country> current, Country country) async {
    if (contains(current, country)) return current;
    final updated = [...current, country];
    await _repository.saveFavourites(updated);
    return updated;
  }

  Future<List<Country>> remove(List<Country> current, Country country) async {
    final updated = current.where((c) => !_isSame(c, country)).toList();
    await _repository.saveFavourites(updated);
    return updated;
  }
}
