import 'package:flutter_clean_bloc_skeleton/domain/core/result.dart';
import 'package:flutter_clean_bloc_skeleton/domain/entities/country.dart';

abstract class CountryRepository {
  Future<Result<List<Country>>> fetchAllCountries();
}
