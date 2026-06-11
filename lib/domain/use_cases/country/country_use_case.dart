import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';
import 'package:flutter_clean_bloc_skeleton/domain/repositories/country/country_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CountryUseCase {
  final CountryRepository repository;

  CountryUseCase(this.repository);

  Future<Result<List<Country>>> fetchAllCountries() async {
    return repository.fetchAllCountries();
  }
}
