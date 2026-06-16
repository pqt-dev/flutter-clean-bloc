import 'package:injectable/injectable.dart';

import '../../core/result.dart';
import '../../entities/country.dart';
import '../../repositories/country/country_repository.dart';

@lazySingleton
class CountryUseCase {
  final CountryRepository _repository;

  CountryUseCase(this._repository);

  Future<Result<List<Country>>> fetchAllCountries({bool forceRefresh = false}) =>
      _repository.fetchAllCountries(forceRefresh: forceRefresh);
}
