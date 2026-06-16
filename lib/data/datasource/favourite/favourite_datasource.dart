import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';

import '../../models/country/country_model.dart';

/// Abstract interface for the favourites data source.
///
/// Owns persistence concerns (storage access + serialization) and speaks in
/// [CountryModel]s; the repository maps these to domain entities.
abstract class FavouriteDatasource {
  Future<Result<List<CountryModel>>> read();

  Future<Result<void>> write(List<CountryModel> countries);
}
