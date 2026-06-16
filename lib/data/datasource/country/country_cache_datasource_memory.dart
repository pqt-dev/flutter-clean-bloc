import 'package:injectable/injectable.dart';

import '../../models/country/country_model.dart';
import 'country_cache_datasource.dart';

@LazySingleton(as: CountryCacheDatasource)
class CountryCacheDatasourceMemory implements CountryCacheDatasource {
  List<CountryModel>? _cache;

  @override
  List<CountryModel>? read() => _cache;

  @override
  void write(List<CountryModel> countries) => _cache = countries;

  @override
  void clear() => _cache = null;
}
