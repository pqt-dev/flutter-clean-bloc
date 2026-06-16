import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';

/// Persists the user's favourite countries locally.
abstract class FavouriteRepository {
  Future<Result<List<Country>>> getFavourites();

  Future<Result<void>> saveFavourites(List<Country> countries);
}
