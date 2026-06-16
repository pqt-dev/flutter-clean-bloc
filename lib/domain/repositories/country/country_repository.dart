import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';

abstract class CountryRepository {
  /// Returns the country list, served from cache when available.
  ///
  /// Pass [forceRefresh] to bypass and refresh the cache from the source.
  Future<Result<List<Country>>> fetchAllCountries({bool forceRefresh = false});
}
