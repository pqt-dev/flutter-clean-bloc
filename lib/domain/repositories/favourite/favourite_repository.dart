import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';

/// Persists the user's favourite countries locally.
abstract class FavouriteRepository {
  Future<List<Country>> getFavourites();

  Future<void> saveFavourites(List<Country> countries);
}
