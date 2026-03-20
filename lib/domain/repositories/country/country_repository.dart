import 'package:flutter_clean_bloc/domain/core/result.dart';
import 'package:flutter_clean_bloc/domain/entities/country.dart';

abstract class CountryRepository {
  Future<Result<List<Country>>> fetchAllCountries();
}
