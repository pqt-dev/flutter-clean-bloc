import 'package:injectable/injectable.dart';

import '../../../domain/core/result.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/repositories/favourite/favourite_repository.dart';
import '../../datasource/favourite/favourite_datasource.dart';
import '../../mappers/country_mapper.dart';

@LazySingleton(as: FavouriteRepository)
class FavouriteRepositoryImpl implements FavouriteRepository {
  final FavouriteDatasource datasource;

  FavouriteRepositoryImpl(this.datasource);

  @override
  Future<Result<List<Country>>> getFavourites() async {
    final result = await datasource.read();
    return switch (result) {
      Success(value: final models) => Success(models.map((e) => e.toEntity()).toList()),
      Failure(error: final error) => Failure(error),
    };
  }

  @override
  Future<Result<void>> saveFavourites(List<Country> countries) {
    return datasource.write(countries.map((c) => c.toModel()).toList());
  }
}
