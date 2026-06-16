import 'package:flutter_clean_bloc_skeleton/data/mappers/country_mapper.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/core/result.dart';
import '../../../domain/repositories/country/country_repository.dart';
import '../../datasource/country/country_cache_datasource.dart';
import '../../datasource/country/country_datasource.dart';

@LazySingleton(as: CountryRepository)
class CountryRepositoryImpl implements CountryRepository {
  final CountryDatasource remoteDatasource;
  final CountryCacheDatasource cacheDatasource;

  CountryRepositoryImpl(this.remoteDatasource, this.cacheDatasource);

  @override
  Future<Result<List<Country>>> fetchAllCountries({bool forceRefresh = false}) async {
    if (forceRefresh) cacheDatasource.clear();

    final cached = cacheDatasource.read();
    if (cached != null) {
      return Success(cached.map((e) => e.toEntity()).toList());
    }

    final result = await remoteDatasource.fetchCountries();
    switch (result) {
      case Success(value: final models):
        cacheDatasource.write(models);
        return Success(models.map((e) => e.toEntity()).toList());
      case Failure(error: final error):
        return Failure(error);
    }
  }
}
