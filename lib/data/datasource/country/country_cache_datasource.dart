import '../../models/country/country_model.dart';

/// In-memory cache for the country list.
///
/// Lets the repository serve a cache-first read so navigating back into the
/// countries screen does not refetch the whole list every time. Returns `null`
/// when nothing is cached yet.
abstract class CountryCacheDatasource {
  List<CountryModel>? read();

  void write(List<CountryModel> countries);

  void clear();
}
